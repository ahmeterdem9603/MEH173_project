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
    import project_pkg::*;
    import class_pkg::*;
    (tb_ifc.tb io);

    timeunit 1ns/1ns;
    
    Axis_test axis;
    Frame_gen frame;
    Error_test error;
  
    initial begin
        axis  = new(io);
        frame = new(io);
        error = new(io);
        
        frame.run();
        error.test_run();
        $finish();
    end
 
 always @(posedge io.pclk) begin
      axis.stream_test_run();  
 end 

endmodule
