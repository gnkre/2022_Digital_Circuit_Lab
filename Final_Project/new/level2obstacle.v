`timescale 1ns / 1ps

module level2obstacle(
    input  clk,
    input  reset,
    input  en, 
    //input [1:0] snake_dir,
    //input  [9:0] snake_head_x,
    //input [9:0] snake_head_y,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    //input pixel_tick,
    output crashed,
    output obstacle_region
    );

reg [9:0] o_x [0:25];
reg [9:0] o_y [0:25];



wire obstacle_region;
reg crashed;

//{0, 21, 41, 61, 81, 101, 121, 141, 161, 181, 201, 221, 241, 261, 281, 301, 321, 341, 361, 381, 401, 421, 441, 461, 481, 501, 521, 541, 561, 581, 601, 621};
//{0, 17, 33, 49, 65, /81,  97,  113, 129, 145, /161, 177, 193, 209, 225/, 241, 257, 273, 289, 305/, 321, 337, 353, 368, 384}; 
initial begin
  o_x[0] = 221;
  o_x[1] = 241;
  o_x[2] = 261;
  o_x[3] = 281;
  o_x[4] = 301;
  o_x[5] = 321;
  o_x[6] = 341;
  o_x[7] = 361;

  o_x[8] = 221;
  o_x[9] = 241;
  o_x[10] = 261;
  o_x[11] = 281;
  o_x[12] = 301;
  o_x[13] = 321;
  o_x[14] = 341;
  o_x[15] = 361;

  o_x[16] = 501;
  o_x[17] = 501;
  o_x[18] = 501;
  o_x[19] = 501;
  o_x[20] = 501;

  o_x[21] = 121;
  o_x[22] = 121;
  o_x[23] = 121;
  o_x[24] = 121;
  o_x[25] = 121;
  
  o_y[0] = 81;
  o_y[1] = 81;
  o_y[2] = 81;
  o_y[3] = 81;
  o_y[4] = 81;
  o_y[5] = 81;
  o_y[6] = 81;
  o_y[7] = 81;

  o_y[8] =  305;
  o_y[9] =  305;
  o_y[10] = 305;
  o_y[11] = 305;
  o_y[12] = 305;
  o_y[13] = 305;
  o_y[14] = 305;
  o_y[15] = 305;
  
  o_y[16] = 161;
  o_y[17] = 177;
  o_y[18] = 193;
  o_y[19] = 209;
  o_y[20] = 225;

  o_y[21] = 161;
  o_y[22] = 177;
  o_y[23] = 193;
  o_y[24] = 209;
  o_y[25] = 225;

end


assign obstacle_region = en &&
(((pixel_x >= o_x[0]) && (pixel_x < o_x[0] + 20) && (pixel_y >= o_y[0]) && (pixel_y < o_y[0] + 16)) ||
((pixel_x >= o_x[1]) && (pixel_x < o_x[1] + 20) && (pixel_y >= o_y[1]) && (pixel_y < o_y[1] + 16)) ||
((pixel_x >= o_x[2]) && (pixel_x < o_x[2] + 20) && (pixel_y >= o_y[2]) && (pixel_y < o_y[2] + 16)) ||
((pixel_x >= o_x[3]) && (pixel_x < o_x[3] + 20) && (pixel_y >= o_y[3]) && (pixel_y < o_y[3] + 16)) ||
((pixel_x >= o_x[4]) && (pixel_x < o_x[4] + 20) && (pixel_y >= o_y[4]) && (pixel_y < o_y[4] + 16)) ||
((pixel_x >= o_x[5]) && (pixel_x < o_x[5] + 20) && (pixel_y >= o_y[0]) && (pixel_y < o_y[5] + 16)) ||
((pixel_x >= o_x[6]) && (pixel_x < o_x[6] + 20) && (pixel_y >= o_y[0]) && (pixel_y < o_y[6] + 16)) ||
((pixel_x >= o_x[7]) && (pixel_x < o_x[7] + 20) && (pixel_y >= o_y[7]) && (pixel_y < o_y[7] + 16)) ||
((pixel_x >= o_x[8]) && (pixel_x < o_x[8] + 20) && (pixel_y >= o_y[8]) && (pixel_y < o_y[8] + 16)) ||
((pixel_x >= o_x[9]) && (pixel_x < o_x[9] + 20) && (pixel_y >= o_y[9]) && (pixel_y < o_y[9] + 16)) ||
((pixel_x >= o_x[10]) && (pixel_x < o_x[10] + 20) && (pixel_y >= o_y[10]) && (pixel_y < o_y[10] + 16)) ||
((pixel_x >= o_x[11]) && (pixel_x < o_x[11] + 20) && (pixel_y >= o_y[11]) && (pixel_y < o_y[11] + 16)) ||
((pixel_x >= o_x[12]) && (pixel_x < o_x[12] + 20) && (pixel_y >= o_y[12]) && (pixel_y < o_y[12] + 16)) ||
((pixel_x >= o_x[13]) && (pixel_x < o_x[13] + 20) && (pixel_y >= o_y[13]) && (pixel_y < o_y[13] + 16)) ||
((pixel_x >= o_x[14]) && (pixel_x < o_x[14] + 20) && (pixel_y >= o_y[14]) && (pixel_y < o_y[14] + 16)) ||
((pixel_x >= o_x[15]) && (pixel_x < o_x[15] + 20) && (pixel_y >= o_y[15]) && (pixel_y < o_y[15] + 16)) ||
((pixel_x >= o_x[16]) && (pixel_x < o_x[16] + 20) && (pixel_y >= o_y[16]) && (pixel_y < o_y[16] + 16)) ||
((pixel_x >= o_x[17]) && (pixel_x < o_x[17] + 20) && (pixel_y >= o_y[17]) && (pixel_y < o_y[17] + 16)) ||
((pixel_x >= o_x[18]) && (pixel_x < o_x[18] + 20) && (pixel_y >= o_y[18]) && (pixel_y < o_y[18] + 16)) ||
((pixel_x >= o_x[19]) && (pixel_x < o_x[19] + 20) && (pixel_y >= o_y[19]) && (pixel_y < o_y[19] + 16)) ||
((pixel_x >= o_x[20]) && (pixel_x < o_x[20] + 20) && (pixel_y >= o_y[20]) && (pixel_y < o_y[20] + 16)) ||
((pixel_x >= o_x[21]) && (pixel_x < o_x[21] + 20) && (pixel_y >= o_y[21]) && (pixel_y < o_y[21] + 16)) ||
((pixel_x >= o_x[22]) && (pixel_x < o_x[22] + 20) && (pixel_y >= o_y[22]) && (pixel_y < o_y[22] + 16)) ||
((pixel_x >= o_x[23]) && (pixel_x < o_x[23] + 20) && (pixel_y >= o_y[23]) && (pixel_y < o_y[23] + 16)) ||
((pixel_x >= o_x[24]) && (pixel_x < o_x[24] + 20) && (pixel_y >= o_y[24]) && (pixel_y < o_y[24] + 16)) ||
((pixel_x >= o_x[25]) && (pixel_x < o_x[25] + 20) && (pixel_y >= o_y[25]) && (pixel_y < o_y[25] + 16)));


endmodule