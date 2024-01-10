`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 01:06:23 PM
// Design Name: 
// Module Name: fifo
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


module fifo(

    );
endmodule


fifo_generator_0 your_instance_name (
  .clk(clk),                    // input wire clk
  .srst(srst),                  // input wire srst
  .din(din),                    // input wire [13 : 0] din
  .wr_en(wr_en),                // input wire wr_en
  .rd_en(rd_en),                // input wire rd_en
  .dout(dout),                  // output wire [13 : 0] dout
  .full(full),                  // output wire full
  .empty(empty),                // output wire empty
  .almost_empty(almost_empty)  // output wire almost_empty
);