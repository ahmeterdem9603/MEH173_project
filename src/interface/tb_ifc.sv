`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2021 06:24:52 PM
// Design Name: 
// Module Name: tb_ifc
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

interface tb_ifc (input logic pclk);
  timeunit 1ns/1ns;

  // user-defined types are defined in instr_register_pkg.sv
  //import project_pkg::*;

  // ADD CODE TO DECLARE THE INTERFACE SIGNALS AND A TESTBENCH MODPORT
	logic 	resetn, FV, LV, m_axis_tvalid, m_axis_tready, m_axis_tuser, m_aclk, m_axis_tlast;
	logic [15:0] D_IN, m_axis_tdata;
	
    modport tb (output resetn, FV, LV, m_axis_tready, D_IN,
                input  pclk, m_axis_tvalid, m_axis_tuser, m_axis_tlast, m_aclk, m_axis_tdata);
endinterface: tb_ifc