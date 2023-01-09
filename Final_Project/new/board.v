`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 22:32:22
// Design Name: 
// Module Name: background
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


module board(
    input  clk,
    input  reset,
    input  [9:0] pixel_x,
    input [9:0] pixel_y,
    input pixel_tick,
    input [5:0] current_score,
    input [2:0] level,
    output [11:0] board_shit
    );
wire [2:0] level;
wire        sram_we, sram_en;
wire [16:0] sram_addr;
wire [11:0] data_in;
wire [11:0] data_out;
wire digit_region;
reg  [17:0] pixel_addr;


srambackground #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(320*40 + 12000 + 3600))
  ram0 (.clk(clk), .we(sram_we), .en(sram_en),
          .addr(sram_addr), .data_i(data_in), .data_o(data_out));

assign sram_addr = pixel_addr;
assign sram_we = 0;
assign sram_en = 1;
assign data_in = 12'h000;
assign digit_region = (pixel_x > 180) && (pixel_x <= 240) && (pixel_y > 400);
assign digit_region2 = (pixel_x > 440) && (pixel_x <= 500) && (pixel_y > 400);

assign board_shit = data_out;

always @ (posedge clk) begin
  if (~reset)
    pixel_addr <= 0;
  else
    if (pixel_y > 400) begin
      if (digit_region) begin
        pixel_addr <= 12800 + (current_score * 1200) + ((pixel_y - 400) >> 1) * 30 + (pixel_x - 180 >> 1);
      end
      else if (digit_region2) begin
        pixel_addr <= 24800 + (level * 1200) + ((pixel_y - 400) >> 1) * 30 + (pixel_x - 440 >> 1);
      end
      else begin
        pixel_addr <= ((pixel_y - 400) >> 1) * 320 + (pixel_x >> 1);
      end
    end
end


endmodule
