`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2021 12:15:08 PM
// Design Name: 
// Module Name: top_cap
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

module top_cap();

    timeunit 1ns/1ns;
    import project_pkg::*;

    logic pclk;
  
  dahua_cap 
    #(.WIDTH(WIDTH), .HEIGTH(HEIGTH))
            dut (.D_IN(D_IN), .pclk(pclk), .resetn(resetn),
                 .FV(FV), .LV(LV), .m_axis_tready(m_axis_tready),
                 .m_axis_tvalid(m_axis_tvalid), .m_axis_tuser(m_axis_tuser),
                 .m_aclk(m_aclk), .m_axis_tlast(m_axis_tlast),
                 .m_axis_tdata(m_axis_tdata)); 
  
  cap_test  
    #(.WIDTH(WIDTH), .HEIGTH(HEIGTH), .V_B_Porch(V_B_Porch), .V_F_Porch(V_F_Porch), .H_B_Porch(H_B_Porch), .H_F_Porch(H_F_Porch))
             tb (.D_IN(D_IN), .pclk(pclk), .resetn(resetn),
                 .FV(FV), .LV(LV), .m_axis_tready(m_axis_tready),
                 .m_axis_tvalid(m_axis_tvalid), .m_axis_tuser(m_axis_tuser),
                 .m_aclk(m_aclk), .m_axis_tlast(m_axis_tlast),
                 .m_axis_tdata(m_axis_tdata)); 
  
   // clock oscillator
  initial begin
    pclk <= 0;
    forever #5ns pclk = ~pclk;
  end
  
endmodule: top_cap
