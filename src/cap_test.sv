`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2021 11:41:29 AM
// Design Name: 
// Module Name: cap_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cap_test
    #(parameter WIDTH = 640,
      parameter HEIGTH = 480,
            
      parameter V_B_Porch = 120,
      parameter V_F_Porch = 100,
      
      parameter H_B_Porch = 120,
      parameter H_F_Porch = 200)
      
   (output logic [15:0] D_IN,
    output logic pclk, resetn, FV, LV, m_axis_tready,
    input  logic m_axis_tvalid, m_axis_tuser, m_aclk, m_axis_tlast,
    input  logic [15:0] m_axis_tdata
    );
    timeunit 1ns/1ns;
   
  logic [15:0] arry [WIDTH + V_B_Porch + V_F_Porch][HEIGTH + H_B_Porch + H_F_Porch];
  logic [31:0] framegen_pix,framegen_line;
  time period = 10ns;
  
  logic err_tlast_flag = 0;
  logic [15:0] last_cnt, line_no, tuser_cnt = 0;
  
  logic [15:0] compared_in[HEIGTH*WIDTH], compared_out[HEIGTH*WIDTH];
  logic [31:0] diff_compared = 0;
  logic [15:0] tvalid_cnt, succeed_line_valid_cnt = 0;
  
  int videoin_ind, streamout_ind = 0;
  
  logic [15:0] temp_frame_line = 0;
  
  
  initial begin
  @(posedge pclk);
    resetn = 0; 
    FV = 0;
    LV = 0;
    diff_compared = 0;
    line_no  = 0;
    last_cnt = 0; 
    tuser_cnt = 0;
    #100ns;
    
//    frame_generator();
    
    resetn = 1;
    #(period*10);
    m_axis_tready = 1;
    #(period*10);
    
    for(framegen_line=0; framegen_line<HEIGTH + V_B_Porch + V_F_Porch; framegen_line++) begin
        for(framegen_pix=0; framegen_pix<WIDTH + H_B_Porch + H_F_Porch; framegen_pix++) begin
            if(framegen_line >= V_B_Porch && framegen_line < HEIGTH + V_B_Porch) begin
                FV = 1;
                if(framegen_pix >= H_B_Porch && framegen_pix < WIDTH + H_B_Porch) begin
                    LV   = 1;
                    D_IN = 10;//arry[i][j];
                    #period;
                end
                else begin
                    LV = 0;
                    #period;
                end
            end
            else begin
                FV = 0;
                LV = 0;
                #period;
            end             
        end
    end
    
    #(period*100) err_tlast_signal();
    #(period*100) err_comparator_test();
    #(period*100) err_tvalid_test();
    #(period*100) err_tuser_test();
  end
   
 always @(posedge pclk) begin
    test_tlast_signal();
    test_tvalid_signal();
    video_comparator();
    test_tuser_signal();
 end 

function test_tuser_signal();
    if(m_axis_tvalid == 1) begin
        if(m_axis_tuser == 1) begin
            temp_frame_line = framegen_line;
            tuser_cnt = tuser_cnt + 1;
        end
    end
endfunction

function err_tuser_test();
    if (tuser_cnt == 1) begin
        if (temp_frame_line == V_B_Porch) begin
            $display("\nAXI-Stream tuser signal test is successful. temp_frame_line = %d, tuser_cnt = %d",temp_frame_line, tuser_cnt);
        end
        else begin 
            $display("\nAXI-Stream tuser signal different location failed. temp_frame_line = %d, tuser_cnt = %d",temp_frame_line, tuser_cnt);
        end
    end
    else begin
        $display("\nAXI-Stream tuser signal number test is failed. temp_frame_line = %d, tuser_cnt = %d",temp_frame_line, tuser_cnt);
    end
endfunction


function test_tvalid_signal();
    if(m_axis_tvalid == 1) begin
        tvalid_cnt = tvalid_cnt + 1;
    end
    else begin
        if(tvalid_cnt == WIDTH) begin 
            succeed_line_valid_cnt = succeed_line_valid_cnt + 1;
        end
        tvalid_cnt = 0;
    end
endfunction

function err_tvalid_test();
    if(succeed_line_valid_cnt == HEIGTH) begin
        $display("\nAXI-Stream tvalid signal test is successful. succeed_line_valid_cnt = %d", succeed_line_valid_cnt);
    end
    else begin
        $display("\nAXI-Stream tvalid signal test is failed. succeed_line_valid_cnt = %d", succeed_line_valid_cnt);
    end
endfunction


function err_comparator_test();
    if(videoin_ind == HEIGTH*WIDTH && streamout_ind == HEIGTH*WIDTH) begin
        for (int a=0; a<HEIGTH*WIDTH; a++) begin
            diff_compared = diff_compared + (compared_in[a] - compared_out[a]);
//            $display("\n%d. diff_compared value = %d", a, diff_compared);     
        end
        
        if(diff_compared == 0) begin
            $display("\nVideo compared test is successful.");
        end
        else begin
            $display("\nVideo compared test is failed. diff_compared value = %d", diff_compared);
        end
    end
endfunction


function video_comparator();
    if(LV == 1) begin
        compared_in[videoin_ind] = D_IN;//video_in_data;
        videoin_ind = videoin_ind + 1;
    end
    if(m_axis_tvalid == 1) begin
        compared_out[streamout_ind] = m_axis_tdata;
        streamout_ind = streamout_ind + 1;
    end
endfunction


function err_tlast_signal();
    if(line_no == HEIGTH) begin
        err_tlast_flag = 0;
        $display("\nAXI-Stream tlast signal test is successful. tlast line no = %d", line_no);
    end
    else begin
        err_tlast_flag = 1;
        $display("\nAXI-Stream tlast signal test is failed. tlast line no = %d", line_no);
    end
endfunction


function test_tlast_signal();
    if(FV == 1) begin
        if(line_no == 0) begin
            if(LV == 1) begin
                 if (m_axis_tlast == 1) begin
                    last_cnt = 0;     
                 end
                 else begin
                    if (last_cnt == WIDTH-1 ) begin
                        //$display("\nValidator test is successful. Value = %d , Line no = %d",last_cnt, line_no);
                        line_no = line_no + 1;
                        last_cnt = 0;
                    end
                    else begin  
                        last_cnt = last_cnt + 1;
                    end
                end                                
            end
        end
        else begin 
            if (m_axis_tlast == 1) begin
                last_cnt = 0;     
            end
            else begin    
                last_cnt = last_cnt + 1;         
                if (last_cnt == WIDTH + H_B_Porch + H_F_Porch - 1) begin
                    //$display("\nValidator test is successful. Value = %d , Line no = %d",last_cnt, line_no);
                    line_no = line_no + 1;
                end
//                else begin
//                    last_cnt = last_cnt + 1;
//                end
            end
        end
    end
endfunction
    
   
//  // test clocks
//  initial begin
//    pclk <= 0;
//    forever #5ns pclk = ~pclk;
//  end
    
//  function void frame_generator();
//  //assigning random value to elements
//    foreach(arry[i,j]) 
//        arry[i][j] = $random;
//    //displaying array elements
//    foreach(arry[i,j])  
//      $display("\tarry[%0d,%0d] = %0d",i,j, arry[i][j]);   
    
//  endfunction
  
endmodule
