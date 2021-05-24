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
    import class_pkg::*;
    
//    logic pclk;
    tb_ifc io (.pclk(pclk));
  
  dahua_cap 
    #(.WIDTH(WIDTH), .HEIGTH(HEIGTH))
            dut (.D_IN(io.D_IN), 
                 .pclk(pclk), 
                 .resetn(io.resetn),
                 .FV(io.FV), 
                 .LV(io.LV), 
                 .m_axis_tready(io.m_axis_tready),
                 .m_axis_tvalid(io.m_axis_tvalid), 
                 .m_axis_tuser(io.m_axis_tuser),
                 .m_aclk(io.m_aclk), 
                 .m_axis_tlast(io.m_axis_tlast),
                 .m_axis_tdata(io.m_axis_tdata)); 
  
  cap_test  
            tb (.io(io));

   // clock oscillator
  initial begin
    pclk <= 0;
    forever #5ns pclk = ~pclk;
  end
  
endmodule: top_cap
