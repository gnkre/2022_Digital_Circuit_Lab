`timescale 1ns / 1ps




// The "objects" module is responsible for dealing with situations like snake eating apple or count scores

module objects(
    input  clk,
    input  reset,
    input slow_clk,
    input  [3:0] usr_btn,
    input  [9:0] pixel_x,
    input [9:0] pixel_y,
    input pixel_tick,
    input vga_clk,
    output [5:0] current_score,
    output snake_region,
    output apple_region,
    output [9:0] apple_x,
    output [9:0] apple_y,
    output obstacle_region,
    output collision,
    output en1,
    output en2,
    output en3,
    output [2:0] level,
    output isdead,
    output win
);

reg [8:0] curr_score = 0;

assign current_score = (curr_score / 10);
wire [9:0] top_bound;
wire [9:0] bottom_bound;
wire [9:0] right_bound;
wire [9:0] left_bound;
wire [9:0] snake_head_x;
wire [9:0] snake_head_y;
wire snake_region;
//wire collision;
wire prev_collision;
wire [1:0] direction;
reg [1:0] prev_direction;
reg same_dir;

reg [4:0] size = 5;
localparam [4:0] max_size = 25;
// wire obstacle; // for hiiting the obstacle

// for change map
reg [2:0]level = 0;

wire obstacle_region1;
wire obstacle_region2;
wire obstacle_region3;

assign obstacle_region = obstacle_region1  || obstacle_region2 || obstacle_region3;
reg en1 = 1;
reg en2 = 0;
reg en3 = 0;

// for dead
reg isdead = 0;
reg first = 1;
reg win = 0;
reg levelup = 0;


snake snake0(
  .clk(clk),
  .vga_clk(vga_clk),
  .snake_clk(slow_clk),
  .reset_n(reset_n),
  .up_btn(usr_btn[1]),
  .down_btn(usr_btn[2]),
  .right_btn(usr_btn[0]),
  .left_btn(usr_btn[3]),
  .collision(collision),
  .levelup(levelup),
  .size(size),
  .same_dir(same_dir),
  .pixel_x(pixel_x),
  .pixel_y(pixel_y),
  .pixel_tick(pixel_tick),
  .snake_region(snake_region),
  .top_bound(top_bound),
  .bottom_bound(bottom_bound),
  .right_bound(right_bound),
  .left_bound(left_bound),
  .snake_head_x(snake_head_x),
  .snake_head_y(snake_head_y),
  .dir(direction)
);

leveloneobstacle ob0(
    .clk(clk),
    .reset(reset_n),
    .en(en1),
    .pixel_x(pixel_x),
    .pixel_y(pixel_y),
    .obstacle_region(obstacle_region1)
);

level2obstacle ob1(
    .clk(clk),
    .reset(reset_n),
    .en(en2),
    .pixel_x(pixel_x),
    .pixel_y(pixel_y),
    .obstacle_region(obstacle_region2)
);

level3obstacle ob2(
    .clk(clk),
    .reset(reset_n),
    .en(en3),
    .pixel_x(pixel_x),
    .pixel_y(pixel_y),
    .obstacle_region(obstacle_region3)
);

wire [9:0] apple_x;
wire [9:0] apple_y;
wire apple_region;
wire generate_new_apple;

apple apple0(
  .clk(clk), 
  .reset(reset_n),
  .generate_new_apple(generate_new_apple),
  .pixel_x(pixel_x),
  .pixel_y(pixel_y),
  .snake_bound_left(left_bound),
  .snake_bound_right(right_bound),
  .snake_bound_up(top_bound),
  .snake_bound_down(bottom_bound),
  .current_apple_x(apple_x),
  .current_apple_y(apple_y),
  .apple_region(apple_region)
);

reg apple_yay;
assign generate_new_apple = apple_yay;
//assign collision = (snake_region && obstacle_region);
reg collision;
// && levelup == 0 -> to slove level up collision
always@(posedge slow_clk) begin
    /*if(curr_score == 0 && level == 0 && levelup == 0) begin
        isdead <= 1;
    end
    else 
    */
    if(!first && (level == 1 || level == 2) && current_score == 0 && levelup == 0) begin
        isdead <= 1;
    end
    else if(collision && current_score == 0 && levelup == 0) begin
        isdead <= 1;
    end
end

always@(*) begin
    if(level == 1) begin
        en2 = 1;
        en1 = 0;
        en3 = 0;
    end
    else if(level == 2) begin
        en2 = 0;
        en3 = 1;
        en1 = 0;
    end
    else begin
        en2 = 0;
        en3 = 0;
        en1 = 1;
    end
end

always @(posedge clk) begin
  if(snake_region && obstacle_region && same_dir) begin
    collision <= 1;
  end
  else if (collision == 1 && !same_dir) begin
    collision <= 0;
  end
end

always @(posedge clk) begin
  prev_direction <= direction;
  same_dir <= prev_direction == direction;
end
reg [3:0] slow_ctr_for_decrease;
wire slow_slow_clk;

clk_divider#(1000000) clk_divider1(
  .clk(clk),
  .reset(0),
  .clk_out(slow_slow_clk)
);

always @(posedge slow_slow_clk) begin
  if (collision == 0) begin
    slow_ctr_for_decrease <= 0;
  end
  else if (collision == 1) begin
    slow_ctr_for_decrease <= slow_ctr_for_decrease == 11 ? 0 : slow_ctr_for_decrease + 1;
  end
  
end

always @(posedge slow_clk) begin
    if(curr_score >= 90) begin
        curr_score <= 30;
        level <= level + 1;
        first <= 1; 
   end
   if(level == 3) begin
        level <= 0;
        win <= 1;
   end
  if ((snake_head_x >= (apple_x - 5)) && (snake_head_x < (apple_x + 5)) && (snake_head_y >= (apple_y - 5)) && (snake_head_y < (apple_y + 5))) begin
    if((level == 1 || level == 2) && first == 1 && current_score == 0) begin
        curr_score <= curr_score + 10;
        first <= 0;
    end
    else begin
        curr_score <= curr_score + 10;
        apple_yay <= 1;
    end
  end
  else if (collision) begin
    curr_score <= curr_score == 0 ? 0 : curr_score - 1;
  end
  else begin
    apple_yay <= 0;
  end
end

always @(posedge slow_clk) begin
  if(levelup) begin
    size <= 5;
  end
  if(apple_yay) begin
    size <= size == max_size ? max_size : size + 1;
  end
end

// for upgrade
always@(posedge slow_clk) begin
    if(current_score == 9) begin
        levelup <= 1;
    end
    else begin
        levelup <= 0;
    end
end
endmodule
