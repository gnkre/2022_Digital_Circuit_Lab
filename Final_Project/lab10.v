`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Dept. of Computer Science, National Chiao Tung University
// Engineer: Chun-Jen Tsai 
// 
// Create Date: 2018/12/11 16:04:41
// Design Name: 
// Module Name: lab9
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: A circuit that show the animation of a fish swimming in a seabed
//              scene on a screen through the VGA interface of the Arty I/O card.
// 
// Dependencies: vga_sync, clk_divider, sram 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module lab10(
    input  clk,
    input  reset_n,
    input  [3:0] usr_btn,
    input  [3:0] usr_sw,
    output [3:0] usr_led,
    
    // VGA specific I/O ports
    output VGA_HSYNC,
    output VGA_VSYNC,
    output [3:0] VGA_RED,
    output [3:0] VGA_GREEN,
    output [3:0] VGA_BLUE
    );

//snake
reg [9:0] snake_pos [0:5][0:1];  // snake coordinates
wire      snake_region;
wire dark_green;
wire [11:0] board_shit;

// for FSM
localparam[1:0] S_MAIN_START = 0, S_MAIN_PLAY = 1,
                S_MAIN_OVER = 2;
reg P, P_next;
//background
reg [3:0] row_pixel_cnt;
reg [3:0] col_pixel_cnt;
reg dk_grn;
reg [31:0] grid_count;

wire [11:0] curr_color;
wire [5:0] current_score;
localparam [11:0] snake_color = 12'he71;

// for detect the snake dead
wire isdead;
wire win;
wire [2:0]level;


wire [11:0]data_apple;
wire [16:0] apple_sram;
reg [16:0] apple_counter;


// declare SRAM control signals
wire [16:0] sram_addr;
wire [11:0] data_in;
wire [11:0] data_out;
wire        sram_we, sram_en;

// General VGA control signals
wire vga_clk;         // 50MHz clock for VGA control
wire video_on;        // when video_on is 0, the VGA controller is sending
                      // synchronization signals to the display device.
  
wire pixel_tick;      // when pixel tick is 1, we must update the RGB value
                      // based for the new coordinate (pixel_x, pixel_y)
  
wire [9:0] pixel_x;   // x coordinate of the next pixel (between 0 ~ 639) 
wire [9:0] pixel_y;   // y coordinate of the next pixel (between 0 ~ 479)
  
reg  [11:0] rgb_reg;  // RGB value for the current pixel
reg  [11:0] rgb_next; // RGB value for the next pixel



// Declare the video buffer size
localparam VBUF_W = 320; // video buffer width
localparam VBUF_H = 240; // video buffer height

vga_sync vs0(
  .clk(vga_clk), .reset(~reset_n), .oHS(VGA_HSYNC), .oVS(VGA_VSYNC),
  .visible(video_on), .p_tick(pixel_tick),
  .pixel_x(pixel_x), .pixel_y(pixel_y)
);

clk_divider#(2) clk_divider0(
  .clk(clk),
  .reset(~reset_n),
  .clk_out(vga_clk)
);

background bk0(
  .clk(clk), 
  .reset(~reset_n), 
  .pixel_x(pixel_x), 
  .pixel_y(pixel_y), 
  .pixel_tick(pixel_tick), 
  .background_color(curr_color)
);

board bod0(
  .clk(clk), 
  .reset(reset_n), 
  .pixel_x(pixel_x), 
  .pixel_y(pixel_y), 
  .pixel_tick(pixel_tick), 
  .current_score(current_score),
  .level(level),
  .board_shit(board_shit)
);






wire test_clk;

clk_divider#(10000000) clk_divider1(
  .clk(clk),
  .reset(~reset_n),
  .clk_out(test_clk)
);

reg light;
always @(posedge test_clk) begin
  light <= light ^ 1;
end

assign usr_led[0] = light;
wire obstacle_region;
wire en1, en2, en3;
wire [9:0] apple_x;
wire [9:0] apple_y;

objects obj0(
    .clk(clk),
    .reset(reset_n),
    .slow_clk(test_clk),
    .usr_btn(usr_btn),
    .pixel_x(pixel_x),
    .pixel_y(pixel_y),
    .pixel_tick(pixel_tick),
    .vga_clk(vga_clk),
    .current_score(current_score),
    .snake_region(snake_region),
    .apple_region(apple_region),
    .apple_x(apple_x),
    .apple_y(apple_y),
    .obstacle_region(obstacle_region),
    .en1(en1),
    .en2(en2),
    .en3(en3),
    .level(level),
    .isdead(isdead),
    .win(win)
);



//------------------------APPLE SRAM-----------------------------------
wire        sram_we_apple, sram_en_apple;
wire [16:0] sram_addr_apple;
wire [11:0] data_in_apple;
wire [11:0] data_out_apple;
reg  [17:0] pixel_addr_apple;

sramappleram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(20*16))
  ram0 (.clk(clk), .we(sram_we_apple), .en(sram_en_apple),
          .addr(sram_addr_apple), .data_i(data_in_apple), .data_o(data_out_apple)
       );


assign sram_addr_apple = pixel_addr_apple;
assign sram_we_apple = 0;
assign sram_en_apple = 1;
assign data_in_apple = 12'h000;

always @ (posedge clk) begin
  if (apple_region == 0)
    pixel_addr_apple <= 0;
  if (apple_region) begin
    pixel_addr_apple <= (pixel_y - apple_y) * 20 + (pixel_x - apple_x);
  end
end

//------------------------gg SRAM-----------------------------------
wire        sram_we_gg, sram_en_gg;
wire [16:0] sram_addr_gg;
wire [11:0] data_in_gg;
wire [11:0] data_out_gg;
reg  [17:0] pixel_addr_gg;

sramgg #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(76800))
  ramgg (.clk(clk), .we(sram_we_gg), .en(sram_en_gg),
          .addr(sram_addr_gg), .data_i(data_in_gg), .data_o(data_out_gg)
       );


assign sram_addr_gg = pixel_addr_gg;
assign sram_we_gg = usr_sw[0];
assign sram_en_gg = 1;
assign data_in_gg = 12'h000;

always @ (posedge clk) begin
    if (isdead) begin
        pixel_addr_gg <= (pixel_y >> 1) * 320 + (pixel_x >> 1);
    end
end

//------------------------win SRAM-----------------------------------
wire        sram_we_win, sram_en_win;
wire [16:0] sram_addr_win;
wire [11:0] data_in_win;
wire [11:0] data_out_win;
reg  [17:0] pixel_addr_win;

sramwin #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(19200))
  ramwin (.clk(clk), .we(sram_we_win), .en(sram_en_win),
          .addr(sram_addr_win), .data_i(data_in_win), .data_o(data_out_win)
       );


assign sram_addr_win = pixel_addr_win;
assign sram_we_win = usr_sw[0];
assign sram_en_win = 1;
assign data_in_win = 12'h000;

always @ (posedge clk) begin
    pixel_addr_win <= (pixel_y >> 2) * 160 + (pixel_x >> 2);
end
//always @ (posedge clk) begin
//  if (apple_counter == 319)
//    apple_counter <= 0;
//  apple_counter <= apple_counter + 1;
//end

//-------------------------------------------------------------------------

assign usr_led[1] = en1;
assign usr_led[2] = en2;
assign usr_led[3] = en3;


// ------------------------------------------------------------------------
// The following code describes an initialized SRAM memory block that
// stores a 320x240 12-bit seabed image, plus two 64x32 fish images.
/*sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(VBUF_W*VBUF_H+FISH_W*FISH_H*2))
  ram0 (.clk(clk), .we(sram_we), .en(sram_en),
          .addr(sram_addr), .data_i(data_in), .data_o(data_out));*/

//assign sram_we = usr_btn[3]; // In this demo, we do not write the SRAM. However, if
//                             // you set 'sram_we' to 0, Vivado fails to synthesize
//                             // ram0 as a BRAM -- this is a bug in Vivado.
//assign sram_en = 1;          // Here, we always enable the SRAM block.
//assign sram_addr = pixel_addr;
//assign data_in = 12'h000; // SRAM is read-only so we tie inputs to zeros.
// End of the SRAM memory block.
// ------------------------------------------------------------------------

// VGA color pixel generator
assign {VGA_RED, VGA_GREEN, VGA_BLUE} = rgb_reg;

//assign apple_sram = apple_counter;
//reg [5:0] counter = 0;            
//always@(posedge clk) begin
//    if(apple_region && counter < 20) begin
//        apple_counter <= apple_counter + 1;
//        counter <= counter + 1;
//    end
//    else if(counter == 20) begin
//        counter <= 0;
//    end
//    if(apple_counter == 320)begin
//        apple_counter <= 0;
//    end
//end

always @(posedge clk) begin
  if (pixel_tick) begin
    rgb_reg <= rgb_next;
  end
end

//assign dark_green = ((col_count % 50) == 0);
// ------------------------------------------------------------------------
// An animation clock for the motion of the fish, upper bits of the
// fish clock is the x position of the fish on the VGA screen.
// Note that the fish will move one screen pixel every 2^20 clock cycles,
// or 10.49 msec
/*assign pos = fish_clock[31:20]; // the x position of the right edge of the fish image
                                // in the 640x480 VGA screen
always @(posedge clk) begin
  if (~reset_n || fish_clock[31:21] > VBUF_W + FISH_W)
    fish_clock <= 0;
  else
    fish_clock <= fish_clock + 1;
end*/
// End of the animation clock code.
// ------------------------------------------------------------------------



// ------------------------------------------------------------------------
// Send the video data in the sram to the VGA controller


always @(*) begin
  if (~video_on)
    rgb_next = 12'h000; // Synchronization period, must set RGB values to zero.
  else if(win) begin
    rgb_next <= data_out_win;//12'hfff;
  end
  else if(isdead) begin
    rgb_next <= data_out_gg;//12'h999;
  end
  else if (pixel_y > 400)begin
    rgb_next = board_shit;
  end
  else if (obstacle_region) begin
    rgb_next <= 12'hfff;
  end
  else if (snake_region) begin
    rgb_next <= snake_color;
  end
  else if (apple_region && data_out_apple != 12'h0f0) begin// && data_apple != 12'h0f0) begin
    rgb_next <= data_out_apple;
  end
  else if(pixel_y < 16 || pixel_y > 383) begin
    rgb_next <= 12'h291;
  end
  else if(pixel_x <= 20 || pixel_x > 619) begin
    rgb_next <= 12'h291;
  end
  else begin
    rgb_next = curr_color;
  end
    //rgb_next = data_out; // RGB value at (pixel_x, pixel_y)
end
// End of the video data display code.
// ------------------------------------------------------------------------
endmodule
