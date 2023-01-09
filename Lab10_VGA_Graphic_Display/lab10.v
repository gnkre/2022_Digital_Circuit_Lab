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
    input [3:0] usr_sw,
    output [3:0] usr_led,
    
    // VGA specific I/O ports
    output VGA_HSYNC,
    output VGA_VSYNC,
    output [3:0] VGA_RED,
    output [3:0] VGA_GREEN,
    output [3:0] VGA_BLUE
    );

// Declare system variables
reg  [31:0] fish_clock;
reg  [31:0] fish_clock1;
reg  [32:0] fish_clock2;
reg  [32:0] fish_clock3;
wire [9:0]  pos, pos1, pos2, pos3;
wire        fish_region, fish_region1, fish_region2, fish_region3;

// declare SRAM control signals
wire [16:0] sram_addr_fish;
wire [16:0] sram_addr_fish1;
wire [16:0] sram_addr_background;

wire [11:0] data_in;
wire [11:0] data_out_background;
wire [11:0] data_out_fish;
wire [11:0] data_out_fish1;
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
reg  [11:0] rgb_next_fish; // RGB value for the next pixel
reg  [11:0] rgb_next_fish1;
reg  [11:0] rgb_next_background;
  
// Application-specific VGA signals
reg  [17:0] pixel_addr_fish;
reg  [17:0] pixel_addr_fish1;
reg  [17:0] pixel_addr_background;

// Declare the video buffer size
localparam VBUF_W = 320; // video buffer width
localparam VBUF_H = 240; // video buffer height

// Set parameters for the fish images
localparam FISH_VPOS   = 56; // Vertical location of the fish in the sea image.
localparam FISH_W      = 64; // Width of the fish.
localparam FISH_H      = 32; // Height of the fish.

localparam FISH_VPOS1   = 128;
localparam FISH_W1      = 64; // Width of the fish.
localparam FISH_H1      = 44; // Height of the fish.

reg [17:0] fish_addr[0:7];   // Address array for up to 8 fish images.
reg [17:0] fish_addr1[0:7];
reg [3:0] minus = 0;
reg [3:0] mask = 0;
// Initializes the fish images starting addresses.
// Note: System Verilog has an easier way to initialize an array,
//       but we are using Verilog 2001 :(
initial begin
  fish_addr[0] = 18'd0;         /* Addr for fish image #1 */
  fish_addr[1] = FISH_W*FISH_H; /* Addr for fish image #2 */
  fish_addr[2] = FISH_W*FISH_H*2;
  fish_addr[3] = FISH_W*FISH_H*3;
  fish_addr[4] = FISH_W*FISH_H*4;
  fish_addr[5] = FISH_W*FISH_H*5;
  fish_addr[6] = FISH_W*FISH_H*6;
  fish_addr[7] = FISH_W*FISH_H*7;
end

initial begin
  fish_addr1[0] = 18'd0;         /* Addr for fish image #1 */
  fish_addr1[1] = FISH_W1*FISH_H1; /* Addr for fish image #2 */
  fish_addr1[2] = FISH_W1*FISH_H1*2;
  fish_addr1[3] = FISH_W1*FISH_H1*3;
  fish_addr1[4] = FISH_W1*FISH_H1*4;
  fish_addr1[5] = FISH_W1*FISH_H1*5;
  fish_addr1[6] = FISH_W1*FISH_H1*6;
  fish_addr1[7] = FISH_W1*FISH_H1*7;
end

// Instiantiate the VGA sync signal generator
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

// ------------------------------------------------------------------------
// The following code describes an initialized SRAM memory block that
// stores a 320x240 12-bit seabed image, plus two 64x32 fish images.
sram #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(VBUF_W*VBUF_H))
  ram0_background (.clk(clk), .we(sram_we), .en(sram_en),
          .addr(sram_addr_background), .data_i(data_in), .data_o(data_out_background));

assign sram_we = usr_btn[3]; // In this demo, we do not write the SRAM. However, if
                             // you set 'sram_we' to 0, Vivado fails to synthesize
                             // ram0 as a BRAM -- this is a bug in Vivado.
assign sram_en = 1;          // Here, we always enable the SRAM block.
assign sram_addr_background = pixel_addr_background;
assign data_in = 12'h000; // SRAM is read-only so we tie inputs to zeros.
// End of the SRAM memory block.
// ------------------------------------------------------------------------


// ------------------------------------------------------------------------
// The following code describes an initialized SRAM memory block that
// stores a 320x240 12-bit seabed image, plus two 64x32 fish images.
sramfish #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(FISH_W*FISH_H*8))
  ram1_fish (.clk(clk), .we(sram_we), .en(sram_en),
          .addr(sram_addr_fish), .data_i(data_in), .data_o(data_out_fish));

//assign sram_we = usr_btn[3]; // In this demo, we do not write the SRAM. However, if
                             // you set 'sram_we' to 0, Vivado fails to synthesize
                             // ram0 as a BRAM -- this is a bug in Vivado.
//assign sram_en = 1;          // Here, we always enable the SRAM block.
assign sram_addr_fish = pixel_addr_fish;
//assign data_in = 12'h000; // SRAM is read-only so we tie inputs to zeros.
// End of the SRAM memory block.
// ------------------------------------------------------------------------


// ------------------------------------------------------------------------
// The following code describes an initialized SRAM memory block that
// stores a 320x240 12-bit seabed image, plus two 64x32 fish images.
sramfish1 #(.DATA_WIDTH(12), .ADDR_WIDTH(18), .RAM_SIZE(FISH_W1*FISH_H1*8))
  ram2_fish (.clk(clk), .we(sram_we), .en(sram_en),
          .addr(sram_addr_fish1), .data_i(data_in), .data_o(data_out_fish1));

//assign sram_we = usr_btn[3]; // In this demo, we do not write the SRAM. However, if
                             // you set 'sram_we' to 0, Vivado fails to synthesize
                             // ram0 as a BRAM -- this is a bug in Vivado.
//assign sram_en = 1;          // Here, we always enable the SRAM block.
assign sram_addr_fish1 = pixel_addr_fish1;
//assign data_in = 12'h000; // SRAM is read-only so we tie inputs to zeros.
// End of the SRAM memory block.
// ------------------------------------------------------------------------

// VGA color pixel generator
//assign {VGA_RED, VGA_GREEN, VGA_BLUE} = rgb_reg;
assign VGA_RED = rgb_reg[11:8] - (minus & mask);
assign VGA_GREEN = rgb_reg[7:4];
assign VGA_BLUE = rgb_reg[3:0] + (minus & mask);

// ------------------------------------------------------------------------
// An animation clock for the motion of the fish, upper bits of the
// fish clock is the x position of the fish on the VGA screen.
// Note that the fish will move one screen pixel every 2^20 clock cycles,
// or 10.49 msec
assign pos = fish_clock[31:20]; // the x position of the right edge of the fish image
                                // in the 640x480 VGA screen
assign pos1 = fish_clock1[30:19];

assign pos2 = fish_clock2[32:21];

assign pos3 = fish_clock3[29:18];

always @(posedge clk) begin
  if (~reset_n || fish_clock[31:21] > VBUF_W + FISH_W)
    fish_clock <= 0;
  else if (usr_btn[0] == 1) fish_clock <= fish_clock + 3;
  else
    fish_clock <= fish_clock + 1;
end

always @(posedge clk) begin
  if (~reset_n || fish_clock1[30:20] > VBUF_W + FISH_W)
    fish_clock1 <= 0;
  else if (usr_btn[0] == 1) fish_clock1 <= fish_clock1 + 3;
  else
    fish_clock1 <= fish_clock1 + 1;
end

always @(posedge clk) begin
  if (~reset_n || fish_clock2[32:22] > VBUF_W + FISH_W)
    fish_clock2 <= 0;
  else if (usr_btn[1] == 1) fish_clock2 <= fish_clock2 + 3;
  else
    fish_clock2 <= fish_clock2 + 1;
end

always @(posedge clk) begin
  if (~reset_n || fish_clock3[29:19] > VBUF_W + FISH_W)
    fish_clock3 <= 0;
  else if (usr_btn[1] == 1) fish_clock3 <= fish_clock3 + 3;
  else
    fish_clock3 <= fish_clock3 + 1;
end
// End of the animation clock code.
// ------------------------------------------------------------------------

// ------------------------------------------------------------------------
// Video frame buffer address generation unit (AGU) with scaling control
// Note that the width x height of the fish image is 64x32, when scaled-up
// on the screen, it becomes 128x64. 'pos' specifies the right edge of the
// fish image.
assign fish_region =
           pixel_y >= (FISH_VPOS<<1) && pixel_y < (FISH_VPOS+FISH_H)<<1 &&
           (pixel_x + 127) >= pos && pixel_x < pos + 1;


assign fish_region1 =
           pixel_y >= (FISH_VPOS1<<1) && pixel_y < (FISH_VPOS1+FISH_H1)<<1 &&
           (pixel_x + 127) >= pos1 && pixel_x < pos1 + 1;

assign fish_region2 =
           pixel_y >= ((FISH_VPOS + 56)<<1) && pixel_y < (56+FISH_VPOS+FISH_H)<<1 &&
           (pixel_x + 127) >= pos2 && pixel_x < pos2 + 1;


assign fish_region3 =
           pixel_y >= ((30)<<1) && pixel_y < (30+FISH_H1)<<1 &&
           (pixel_x + 127) >= pos3 && pixel_x < pos3 + 1;

// THE CKT FOR READING BACKGROUND ONLY
// ------------------------------------------------------------------------ 
always @ (posedge clk) begin
  if (~reset_n)
    pixel_addr_background <= 0;
  else begin
    // Scale up a 320x240 image for the 640x480 display.
    // (pixel_x, pixel_y) ranges from (0,0) to (639, 479)
    pixel_addr_background <= (pixel_y >> 1) * VBUF_W + (pixel_x >> 1);
  end
end
// End of the AGU code.
// ------------------------------------------------------------------------


// THE CKT FOR READING FISH ONLY
// ------------------------------------------------------------------------ 
always @ (posedge clk) begin
  if (~reset_n)
    pixel_addr_fish <= 0;
  else if (fish_region) begin
    pixel_addr_fish <= fish_addr[fish_clock[23:21]] + ((pixel_y>>1) - FISH_VPOS)*FISH_W + ((pixel_x +(FISH_W*2-1)-pos)>>1);
      //fish_addr[fish_clock[23]] + ((pixel_y>>1)-FISH_VPOS)*FISH_W + ((pixel_x +(FISH_W*2-1)-pos)>>1);
  end
  else if (fish_region2) begin
    pixel_addr_fish <= fish_addr[fish_clock2[24:22]] + ((pixel_y>>1)-(FISH_VPOS + 56))*FISH_W + ((pixel_x +(FISH_W*2-1)-pos2)>>1);
  end
end
// End of the AGU code.
// ------------------------------------------------------------------------

// THE CKT FOR READING FISH ONLY
// ------------------------------------------------------------------------ 
always @ (posedge clk) begin
  if (~reset_n)
    pixel_addr_fish1 <= 0;
  else if (fish_region1) begin
    pixel_addr_fish1 <= fish_addr1[fish_clock1[23:21]] + ((pixel_y>>1)-FISH_VPOS1)*FISH_W1 + ((pixel_x +(FISH_W1*2-1)-pos1)>>1);
      //fish_addr[fish_clock[23]] + ((pixel_y>>1)-FISH_VPOS)*FISH_W + ((pixel_x +(FISH_W*2-1)-pos)>>1);
  end
  else if (fish_region3) begin
    pixel_addr_fish1 <= fish_addr1[fish_clock3[22:20]] + ((pixel_y>>1)-30)*FISH_W1 + ((pixel_x +(FISH_W1*2-1)-pos3)>>1);
      //fish_addr[fish_clock[23]] + ((pixel_y>>1)-FISH_VPOS)*FISH_W + ((pixel_x +(FISH_W*2-1)-pos)>>1);
  end
end
// End of the AGU code.
// ------------------------------------------------------------------------

// THE CKT FOR READING FISH ONLY
// ------------------------------------------------------------------------ 

// End of the AGU code.
// ------------------------------------------------------------------------


// ------------------------------------------------------------------------
// Send the video data in the sram to the VGA controller
always @(posedge clk) begin


  if (pixel_tick && fish_region && rgb_next_fish1 == 12'h0f0 && fish_region3 && rgb_next_fish != 12'h0f0) rgb_reg <= rgb_next_fish;
  else if (pixel_tick && fish_region && rgb_next_fish1 == 12'h0f0 && fish_region3 && rgb_next_fish == 12'h0f0) rgb_reg <= rgb_next_background;
  else if (pixel_tick && fish_region && rgb_next_fish1 != 12'h0f0 && fish_region3) rgb_reg <= rgb_next_fish1;
  else if (pixel_tick && fish_region && rgb_next_fish == 12'h0f0 && fish_region3 == 0) rgb_reg <= rgb_next_background;
  else if (pixel_tick && fish_region && rgb_next_fish != 12'h0f0 && fish_region3 == 0) rgb_reg <= rgb_next_fish;
  else if (pixel_tick && fish_region3 && rgb_next_fish1 == 12'h0f0) rgb_reg <= rgb_next_background;
  else if (pixel_tick && fish_region3 && rgb_next_fish1 != 12'h0f0) rgb_reg <= rgb_next_fish1;

  else if (pixel_tick && fish_region1 && rgb_next_fish1 == 12'h0f0 && fish_region2 && rgb_next_fish != 12'h0f0) rgb_reg <= rgb_next_fish;
  else if (pixel_tick && fish_region1 && rgb_next_fish1 == 12'h0f0 && fish_region2 && rgb_next_fish == 12'h0f0) rgb_reg <= rgb_next_background;
  else if (pixel_tick && fish_region1 && rgb_next_fish1 != 12'h0f0 && fish_region2) rgb_reg <= rgb_next_fish1;
  else if (pixel_tick && fish_region1 && rgb_next_fish1 == 12'h0f0 && fish_region2 == 0) rgb_reg <= rgb_next_background;
  else if (pixel_tick && fish_region1 && rgb_next_fish1 != 12'h0f0 && fish_region2 == 0) rgb_reg <= rgb_next_fish1;
  else if (pixel_tick && fish_region2 && rgb_next_fish == 12'h0f0) rgb_reg <= rgb_next_background;
  else if (pixel_tick && fish_region2 && rgb_next_fish != 12'h0f0) rgb_reg <= rgb_next_fish;

  else if (pixel_tick) rgb_reg <= rgb_next_background;
end


always @(posedge clk) begin
  if (usr_sw[0] == 1) begin
    minus <= minus + 1;
    mask <= 0;
  end
  else if (usr_sw[1] == 1) begin
    minus <= minus + 1;
    mask <= 4'b1111;
  end
  else minus <= 0;
end


always @(*) begin
  if (~video_on) begin
    rgb_next_background = 12'h000; // Synchronization period, must set RGB values to zero.
    rgb_next_fish = 0;
    rgb_next_fish1 = 0;
  end
  else begin
    rgb_next_background = data_out_background; // RGB value at (pixel_x, pixel_y)
    if (usr_sw[0] == 1) begin
      rgb_next_background[11:8] = rgb_next_background[11:8] - minus;
      rgb_next_background[7:4] = rgb_next_background[7:4];
      rgb_next_background[3:0] = rgb_next_background[3:0] + minus;
    end
    rgb_next_fish = data_out_fish;
    rgb_next_fish1 = data_out_fish1;
  end
end
// End of the video data display code.
// ------------------------------------------------------------------------


endmodule
