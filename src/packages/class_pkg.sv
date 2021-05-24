`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2021 07:09:18 PM
// Design Name: 
// Module Name: class_pkg
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

package class_pkg;
  timeunit 1ns/1ns;

  import project_pkg::*;
  export project_pkg::*;

  typedef class Frame_gen;
  typedef class Error_test;
  typedef class Axis_test;

  `include "Frame_gen.svh"
  `include "Error_test.svh"
  `include "Axis_test.svh"

endpackage 