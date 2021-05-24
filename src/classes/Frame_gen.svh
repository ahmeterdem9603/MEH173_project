class Frame_gen;
    virtual tb_ifc v_io;
    //import project_pkg::*;
    
    function new(virtual tb_ifc v_io);
        this.v_io = v_io;
    endfunction
    
    function init_signals();
        diff_compared = 0;
        err_tlast_flag = 0;
        line_no  = 0;
        last_cnt = 0; 
        tuser_cnt = 0;
        tvalid_cnt = 0;
        succeed_line_valid_cnt = 0;
        videoin_ind = 0;
        streamout_ind = 0;
        temp_frame_line = 0;
        //#100ns;
    endfunction
    
    function random_frame_data();
      //assigning random value to elements
        foreach(arry[i,j]) 
            arry[i][j] = $random;
        //displaying array elements
        //foreach(arry[i,j])  
        //$display("\tarry[%0d,%0d] = %0d",i,j, arry[i][j]);  
    endfunction
    
    task run();
        @(posedge v_io.pclk)
    
        init_signals();
        #100ns;
        
    //    frame_generator();
        random_frame_data();
        
        v_io.resetn = 1;
        #(period*10);
        v_io.m_axis_tready = 1;
        #(period*10);
    
        for(framegen_line=0; framegen_line<HEIGTH + V_B_Porch + V_F_Porch; framegen_line++) begin
            for(framegen_pix=0; framegen_pix<WIDTH + H_B_Porch + H_F_Porch; framegen_pix++) begin
                if(framegen_line >= V_B_Porch && framegen_line < HEIGTH + V_B_Porch) begin
                    v_io.FV = 1;
                    if(framegen_pix >= H_B_Porch && framegen_pix < WIDTH + H_B_Porch) begin
                        v_io.LV   = 1;
                        v_io.D_IN = arry[framegen_line][framegen_pix];
                        #period;
                    end
                    else begin
                        v_io.LV = 0;
                        #period;
                    end
                end
                else begin
                    v_io.FV = 0;
                    v_io.LV = 0;
                    #period;
                end             
            end
        end
    endtask

endclass : Frame_gen