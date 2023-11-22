`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2023 12:55:41 PM
// Design Name: 
// Module Name: moving_avg_verilog
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


module moving_avg_verilog(


    input adc_clk_p_i,
    input adc_clk_n_i,
    input [13:0] adc_dat_a_i,
    input [13:0] adc_dat_b_i,
    output [13:0] dac_dat_o,
    output dac_wrt_o,
    output dac_rst_o,
    output dac_clk_o,
    output dac_sel_o
   
//    input rst
  
    );
    ///DAC
wire  [14-1:0] adc_dat_a_o;     //!< ADC CHA data
wire  [14-1:0] adc_dat_b_o;     //!< ADC CHB data
wire          adc_clk_o;       //!< ADC clock
wire           adc_rst_i;       //!< ADC reset - active low
wire           ser_clk_o;
wire    [ 14-1: 0] dac_dat_a_i  ;

//
wire rst;
wire          clk;
wire          empty;
wire          full;
wire  [14-1:0] fifo_data;
integer       cnt = 0;
reg           wr_en;
reg           rd_en;
reg           adc_clk_in;

reg  [31:0]   sum;
reg  [31:0]   sum_test;

reg  [31:0]   moving_avg;
reg  [14-1:0] moving_avg_good;

reg   [13:0] moove;
reg   [13:0] dac_dat_o_interm;
integer       param [0:11];

initial begin
    param[0]  = 1;
    param[1]  = 2;
    param[2]  = 3;
    param[3]  = 4;
    param[4]  = 5;
    param[5]  = 6;
    param[6]  = 7;
    param[7]  = 8;
    param[8]  = 9;
    param[9]  = 10;
    param[10] = 11;
    param[11] = 12;
end

SRL16E #(
   .INIT(16'h1111) // Initial Value of Shift Register
) SRL16E_inst (
   .Q(rst),       // SRL data output
   .A0(0),     // Select[0] input
   .A1(1),     // Select[1] input
   .A2(0),     // Select[2] input
   .A3(0),     // Select[3] input    // Clock enable input
   .CLK(clk),   // Clock input
   .D(0)        // SRL data input
);


fifo_generator_0 your_instance_name (
  .clk(clk),      // input wire clk
  .srst(rst),    // input wire srst
  .din(adc_dat_a_i),      // input wire [13 : 0] din
  .wr_en(wr_en),  // input wire wr_en
  .rd_en(rd_en),  // input wire rd_en
  .dout(fifo_data),    // output wire [13 : 0] dout
  .full(full),    // output wire full
  .empty(empty)  // output wire empty
);

//IBUFDS  IBUFDS_inst (
//   .O(clk),  // Buffer output
//   .I(adc_clk_p_i),  // Diff_p buffer input (connect directly to top-level port)
//   .IB(adc_clk_n_i) // Diff_n buffer input (connect directly to top-level port)
//);


red_pitaya_analog u_red_pitaya_analog (
  // ADC IC
  .adc_dat_a_i       (adc_dat_a_i),
  .adc_dat_b_i       (moove),
  .adc_clk_p_i       (adc_clk_p_i),
  .adc_clk_n_i       (adc_clk_n_i),

  // DAC IC
  .dac_dat_o         (dac_dat_o),
  .dac_wrt_o         (dac_wrt_o),
  .dac_sel_o         (dac_sel_o),
  .dac_clk_o         (dac_clk_o),
  .dac_rst_o         (dac_rst_o),

  // User interface
  .adc_dat_a_o       (adc_dat_a_o),
  .adc_dat_b_o       (adc_dat_b_o),
  .adc_clk_o         (adc_clk_o),
  .adc_rst_i         (adc_rst_i),
  .ser_clk_o         (ser_clk_o),

  .dac_dat_a_i       (adc_dat_a_i),
  .dac_dat_b_i       (moove),
  .adc_clk(clk)
);



always @(posedge clk or posedge rst) begin :moving_avg_verilog

//   reg [31:0] sum ;
//    reg [31:0] moving_avg ;
//    reg [14-1:0] moving_avg_good ;
    if (rst) begin
        sum <= 32'b0;
        sum_test<=32'b0;
        wr_en <= 1'b0;
        rd_en <= 1'b0;
        moving_avg <= 32'b0;

        moving_avg_good <= {14{1'b0}};
        moove <= {14{1'b0}};
        cnt <= 2 ** param[2] - 2;
    end else if (clk) begin
        wr_en <= 1'b1;
        sum <= $signed(sum) + $signed( adc_dat_a_i )- $signed(fifo_data);
//        sum_test<=sum;
        if (cnt > 0) begin
            rd_en <= 1'b0;
            cnt <= cnt - 1;
        end else begin
            rd_en <= 1'b1;
        end
        
        moving_avg = $signed(sum) >>> param[3];
        moving_avg_good = moving_avg[13:0];
        moove = moving_avg_good;
       
    end
end
//assign dac_dat_o=moove;

endmodule
//if (rst) begin
 
//   
        
//        moving_avg = $signed(sum) >>> param[3];
//        moving_avg_good = moving_avg[13:0];
//        moove = moving_avg_good;
//        dac_dat_o_intern=moove;
//    end
//end


//assign dac_dat_o=dac_dat_o_intern;
//endmodule



//     sum <= 32'b0;
//        wr_en <= 1'b0;
//        rd_en <= 1'b0;
//        moving_avg <= 32'b0;
//        moving_avg_good <= 14'b0;  // 14 bits of zero
//        moove <= 14'b0;  // 14 bits of zero
//        cnt <= (2 ** param[2]) - 2;
//    end else begin
//        if (clk) begin
       
//            wr_en <= 1'b1;
//            sum <= $signed(sum) + ($signed(adc_dat_a_i) - $signed(fifo_data));
//                if (cnt > 0) begin
//                    rd_en <= 1'b0;
//                    cnt <= cnt - 1;
//                end else begin
//                    rd_en <= 1'b1;
//                end
//            moving_avg = $signed(sum) >>> param[3];
//            moving_avg_good = moving_avg[13:0];
//            assign moove = moving_avg_good;
//        end
//    end
//end


//endmodule
