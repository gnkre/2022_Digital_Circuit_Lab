  `timescale 1ns / 1ps

module apple(
    input  clk,
    input  reset,
    input generate_new_apple,
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    input wire [9:0] snake_bound_left,
    input wire [9:0] snake_bound_right,
    input wire [9:0] snake_bound_up,
    input wire [9:0] snake_bound_down,
    output [9:0] current_apple_x,
    output [9:0] current_apple_y,
    output apple_region
    );

reg [9:0] current_apple_x;
reg [9:0] current_apple_y;
wire [9:0] apple_x;
wire [9:0] apple_y;

reg [9:0] x_coord [0:31];
reg [9:0] y_coord [0:24];

wire [9:0] snake_left_bound_index;// = snake_bound_left / 20;
wire [9:0] snake_right_bound_index;// = snake_bound_left / 20;
wire [9:0] snake_up_bound_index;// = snake_bound_left / 20;
wire [9:0] snake_down_bound_index;// = snake_bound_left / 20;

assign snake_left_bound_index = snake_bound_left / 20;
assign snake_right_bound_index = snake_bound_right / 20;
assign snake_up_bound_index = snake_bound_up / 16;
assign snake_down_bound_index = snake_bound_down / 16;

//assign apple_x = current_apple_x;
//assign apple_y = current_apple_y;

assign apple_region = (pixel_x >= current_apple_x) && (pixel_x < current_apple_x + 20) && (pixel_y >= current_apple_y) && (pixel_y < current_apple_y + 16);
//assign apple_region = (pixel_x >= current_apple_x) && (pixel_x < current_apple_x + 20) && (pixel_y >= current_apple_y) && (pixel_y < current_apple_y + 16)&&( radiussqrX +radiussqrY < 64 );//110550096
//reg [9:0] current_x;
//reg [9:0] current_y ;
//integer radiussqrX = ((current_x-current_apple_x+8) * (current_x-current_apple_x+8));
//integer radiussqrY = ((current_y-current_apple_y+8)* (current_y-current_apple_y + 8));


initial begin
  current_apple_x = 81;
  current_apple_y = 161;  
// = {0, 21, 41, 61, 81, 101, 121, 141, 161, 181, 201, 221, 241, 261, 281, 301, 321, 341, 361, 381, 401, 421, 441, 461, 481, 501, 521, 541, 561, 581, 601, 621};
  x_coord[0] = 21;
  x_coord[1] = 21;
  x_coord[2] = 41;
  x_coord[3] = 61;
  x_coord[4] = 81;
  x_coord[5] = 101;
  x_coord[6] = 101;
  x_coord[7] = 141;
  x_coord[8] = 161;
  x_coord[9] = 181;
  x_coord[10] = 201;
  x_coord[11] = 221;
  x_coord[12] = 241;
  x_coord[13] = 261;
  x_coord[14] = 281;
  x_coord[15] = 301;
  x_coord[16] = 321;
  x_coord[17] = 341;
  x_coord[18] = 361;
  x_coord[19] = 381;
  x_coord[20] = 401;
  x_coord[21] = 421;
  x_coord[22] = 441;
  x_coord[23] = 461;
  x_coord[24] = 481;
  x_coord[25] = 521;
  x_coord[26] = 521;
  x_coord[27] = 541;
  x_coord[28] = 561;
  x_coord[29] = 581;
  x_coord[30] = 601;
  x_coord[31] = 601;
//{0, 17, 33, 49, 65, 81, 97, 113, 129, 145, 161, 177, 193, 209, 225, 241, 257, 273, 289, 305, 321, 337, 353, 368, 384}; 
  y_coord[0] = 17;
  y_coord[1] = 17;
  y_coord[2] = 33;
  y_coord[3] = 49;
  y_coord[4] = 65;
  y_coord[5] = 65;
  y_coord[6] = 97;
  y_coord[7] = 113;
  y_coord[8] = 129;
  y_coord[9] = 145;
  y_coord[10] = 161;
  y_coord[11] = 177;
  y_coord[12] = 177;
  y_coord[13] = 209;
  y_coord[14] = 225;
  y_coord[15] = 241;
  y_coord[16] = 257;
  y_coord[17] = 273;
  y_coord[18] = 289;
  y_coord[19] = 321;
  y_coord[20] = 321;
  y_coord[21] = 337;
  y_coord[22] = 353;
  y_coord[23] = 368;
  y_coord[24] = 384;
end
  // this is the random number generator
reg [9:0] rand_counter_x;
always @(posedge clk) begin
  if (rand_counter_x >= 29) begin
    rand_counter_x <= 16;
  end
  else begin
    rand_counter_x <= rand_counter_x + 1;
  end 
end

reg [9:0] rand_counter_x_zero;
always @(posedge clk) begin
  if (rand_counter_x_zero >= 15) begin
    rand_counter_x_zero <= 0;
  end
  else begin
    rand_counter_x_zero <= rand_counter_x_zero + 1;
  end 
end

reg [9:0] rand_counter_x_one;
always @(posedge clk) begin
  if (rand_counter_x_one >= 29) begin
    rand_counter_x_one <= 0;
  end
  else begin
    rand_counter_x_one <= rand_counter_x_one + 1;
  end 
end

////////////////////////////////////////////////////////////////
reg [9:0] rand_counter_y;
always @(posedge clk) begin
  if (rand_counter_y >= 22) begin
    rand_counter_y <= 13;
  end
  else begin
    rand_counter_y <= rand_counter_y + 1;
  end 
end

reg [9:0] rand_counter_y_zero;
always @(posedge clk) begin
  if (rand_counter_y_zero >= 12) begin
    rand_counter_y_zero <= 0;
  end
  else begin
    rand_counter_y_zero <= rand_counter_y_zero + 1;
  end 
end

reg [9:0] rand_counter_y_one;
always @(posedge clk) begin
  if (rand_counter_y_one >= 22) begin
    rand_counter_y_one <= 0;
  end
  else begin
    rand_counter_y_one <= rand_counter_y_one + 1;
  end 
end
// this will generate new apple x by random counter
always @(posedge generate_new_apple) begin
  if (x_coord[rand_counter_x] < snake_bound_left || x_coord[rand_counter_x] > snake_bound_right) begin
    current_apple_x <= x_coord[rand_counter_x];
  end
  else if (x_coord[rand_counter_x_zero] < snake_bound_left || x_coord[rand_counter_x] > snake_bound_right) begin
    current_apple_x <= x_coord[rand_counter_x_zero];
  end
  else begin
    current_apple_x <= x_coord[rand_counter_x_one];
  end
end

//always @(posedge generate_new_apple) begin
//  if (snake_bound_left > (639 - snake_bound_right)) begin
//    current_apple_x <= x_coord[snake_left_bound_index - 4];
//  end
//  else begin
//    current_apple_x <= x_coord[snake_right_bound_index + 4];
//  end
//end


// this will generate new apple x by random counter
// WARNING : FOR Y, YOU ONLY HAVE 0 ~ 399 PIXEL TO USE. BEWARE OF THE BOUNDARY PROBLEM
always @(posedge generate_new_apple) begin
  if (y_coord[rand_counter_y] < snake_bound_up || y_coord[rand_counter_y] > snake_bound_down) begin
    current_apple_y <= y_coord[rand_counter_y];
  end
  else if (y_coord[rand_counter_y_zero] < snake_bound_up || y_coord[rand_counter_y] > snake_bound_down) begin
    current_apple_y <= y_coord[rand_counter_y_zero];
  end
  else begin
    current_apple_y <= y_coord[rand_counter_y_one];
  end
end

//always @(posedge generate_new_apple) begin
//  if (snake_bound_up > (399 - snake_bound_down)) begin
//    current_apple_y <= y_coord[snake_up_bound_index - 2];
//  end
//  else begin
//    current_apple_y <= y_coord[snake_down_bound_index + 3];
//  end
//end

endmodule
