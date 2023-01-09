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


module background(
    input  clk,
    input  reset,
    input  [9:0] pixel_x,
    input [9:0] pixel_y,
    input pixel_tick,
    output [11:0] background_color
    );
localparam [11:0] color1 = 12'h3c2, color2 = 12'h1d2;

srambackground #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(320*80))
  ram0 (.clk(clk), .we(sram_we), .en(sram_en),
          .addr(sram_addr), .data_i(data_in), .data_o(data_out));


          
reg [11:0] curr_color = color1;
reg [11:0] row_init_color = color1;
reg [9:0] col_count = 0;
reg [9:0] row_count = 0;
assign background_color = curr_color;

always @(posedge clk) begin
  if(pixel_tick) begin
    col_count <= col_count + 1;
    if (col_count == 639) begin
      col_count <= 0;
      row_count <= row_count + 1;
    end
    if(row_count == 479) begin
      row_count <= 0;
    end
  end
  if (pixel_x == 0 && pixel_y == 0) begin 
    row_count <= 0;
    col_count <= 0;
  end
end


always @(posedge clk) begin
    if (pixel_x == 0 && pixel_y == 0) begin 
      row_init_color = color1;
      curr_color <= row_init_color; 
    end
    else if(col_count == 0  && row_init_color == color1 && (row_count % 40 == 0 || row_count == 479)) begin
      row_init_color <= color2;
      curr_color <= row_init_color;
    end
    else if (col_count == 0  && row_init_color == color2 && (row_count % 40 == 0 || row_count == 479))begin
      row_init_color <= color1;
      curr_color <= row_init_color; 
    end
    else if (col_count == 0 && row_count % 40 != 0) begin
      curr_color <= row_init_color;
    end
    else if ((col_count % 40) == 0 && col_count != 0 && curr_color == color1) begin
      curr_color <= color2;
    end
    else if ((col_count % 40) == 0 && col_count != 0 && curr_color == color2) begin
      curr_color <= color1;
    end
    else curr_color <= curr_color;
end
    
    

endmodule
