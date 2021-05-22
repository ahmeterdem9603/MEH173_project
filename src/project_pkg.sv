`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2021 10:25:25 PM
// Design Name: 
// Module Name: project_pkg
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

package project_pkg;
    timeunit 1ns/1ns;
    
    parameter WIDTH = 480;
    parameter HEIGTH = 640;
    parameter H_B_Porch = 120;
    parameter H_F_Porch = 200;
    parameter V_B_Porch = 120;
    parameter V_F_Porch = 100;
   
  logic resetn, pclk, FV, LV, 
        m_axis_tvalid, m_axis_tready,
        m_axis_tuser, m_aclk, m_axis_tlast;
  logic [15:0] D_IN, m_axis_tdata;
  
  
    logic [15:0] arry [WIDTH + V_B_Porch + V_F_Porch][HEIGTH + H_B_Porch + H_F_Porch];
    logic [31:0] framegen_pix,framegen_line;
    time period = 10ns;
    
    logic err_tlast_flag;
    logic [15:0] last_cnt, line_no, tuser_cnt;
    
    logic [15:0] compared_in[HEIGTH*WIDTH], compared_out[HEIGTH*WIDTH];
    logic [31:0] diff_compared;
    logic [15:0] tvalid_cnt, succeed_line_valid_cnt;
    
    int videoin_ind, streamout_ind;
    
    logic [15:0] temp_frame_line;
  
endpackage: project_pkg
