`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Dept. of Computer Science, National Chiao Tung University
// Engineer: Chun-Jen Tsai
// 
// Create Date: 2017/05/08 15:29:41
// Design Name: 
// Module Name: lab6
// Project Name: 
// Target Devices: 
// Tool Versions:
// Description: The sample top module of lab 6: sd card reader. The behavior of
//              this module is as follows
//              1. When the SD card is initialized, display a message on the LCD.
//                 If the initialization fails, an error message will be shown.
//              2. The user can then press usr_btn[2] to trigger the sd card
//                 controller to read the super block of the sd card (located at
//                 block # 8192) into the SRAM memory.
//              3. During SD card reading time, the four LED lights will be turned on.
//                 They will be turned off when the reading is done.
//              4. The LCD will then displayer the sector just been read, and the
//                 first byte of the sector.
//              5. Everytime you press usr_btn[2], the next byte will be displayed.
// 
// Dependencies: clk_divider, LCD_module, debounce, sd_card
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module lab8(
  // General system I/O ports
  input  clk,
  input  reset_n,
  input  [3:0] usr_btn,
  output [3:0] usr_led,

  // SD card specific I/O ports
  output spi_ss,
  output spi_sck,
  output spi_mosi,
  input  spi_miso,

  // 1602 LCD Module Interface
  output LCD_RS,
  output LCD_RW,
  output LCD_E,
  output [3:0] LCD_D
);

localparam [2:0] S_MAIN_INIT = 3'b000, S_MAIN_IDLE = 3'b001,
                 S_MAIN_WAIT = 3'b010, S_MAIN_READ = 3'b011,
                 S_MAIN_DONE = 3'b100, S_MAIN_SHOW = 3'b101,
                 S_MAIN_FINAL = 3'b111, S_MAIN_MID = 3'b110;

// Declare system variables
wire btn_level, btn_pressed;
reg  prev_btn_level;
reg  [5:0] send_counter;
reg  [2:0] P, P_next;
reg  [9:0] sd_counter;
reg  [7:0] data_byte;
reg  [31:0] blk_addr;
reg  [127:0] row_A = "SD card cannot  ";
reg  [127:0] row_B = "be initialized! ";
reg  done_flag; // Signals the completion of reading one SD sector.
reg found_start_tag = 0;
reg found_end_tag = 0;
reg [15:0] ans;
reg [3:0] five_true = 0;
// Declare SD card interface signals
wire clk_sel;
wire clk_500k;
reg  rd_req;
reg  [31:0] rd_addr;
wire init_finished;
wire [7:0] sd_dout;
wire sd_valid;

// Declare the control/data signals of an SRAM memory block
wire [7:0] data_in;
wire [7:0] data_out;
wire [8:0] sram_addr;
wire       sram_we, sram_en;

assign clk_sel = (init_finished)? clk : clk_500k; // clock for the SD controller
assign usr_led = 0;//{0, P};

clk_divider#(200) clk_divider0(
  .clk(clk),
  .reset(~reset_n),
  .clk_out(clk_500k)
);

debounce btn_db0(
  .clk(clk),
  .btn_input(usr_btn[2]),
  .btn_output(btn_level)
);

LCD_module lcd0( 
  .clk(clk),
  .reset(~reset_n),
  .row_A(row_A),
  .row_B(row_B),
  .LCD_E(LCD_E),
  .LCD_RS(LCD_RS),
  .LCD_RW(LCD_RW),
  .LCD_D(LCD_D)
);

sd_card sd_card0(
  .cs(spi_ss),
  .sclk(spi_sck),
  .mosi(spi_mosi),
  .miso(spi_miso),

  .clk(clk_sel),
  .rst(~reset_n),
  .rd_req(rd_req),
  .block_addr(rd_addr),
  .init_finished(init_finished),
  .dout(sd_dout),
  .sd_valid(sd_valid)
);

sram ram0(
  .clk(clk),
  .we(sram_we),
  .en(sram_en),
  .addr(sram_addr),
  .data_i(data_in),
  .data_o(data_out)
);

//
// Enable one cycle of btn_pressed per each button hit
//
always @(posedge clk) begin
  if (~reset_n)
    prev_btn_level <= 0;
  else
    prev_btn_level <= btn_level;
end

assign btn_pressed = (btn_level == 1 && prev_btn_level == 0)? 1 : 0;

// ------------------------------------------------------------------------
// The following code sets the control signals of an SRAM memory block
// that is connected to the data output port of the SD controller.
// Once the read request is made to the SD controller, 512 bytes of data
// will be sequentially read into the SRAM memory block, one byte per
// clock cycle (as long as the sd_valid signal is high).
assign sram_we = sd_valid;          // Write data into SRAM when sd_valid is high.
assign sram_en = 1;                 // Always enable the SRAM block.
assign data_in = sd_dout;           // Input data always comes from the SD controller.
assign sram_addr = sd_counter[8:0]; // Set the driver of the SRAM address signal.
// End of the SRAM memory block
// ------------------------------------------------------------------------
reg  [11:0] block_counter = 0;
// ------------------------------------------------------------------------
// FSM of the SD card reader that reads the super block (512 bytes)
always @(posedge clk) begin
  if (~reset_n) begin
    P <= S_MAIN_INIT;
    //done_flag <= 0;
  end
  else begin
    P <= P_next;
    /*if (P == S_MAIN_DONE)
      done_flag <= 1;
    else if (P == S_MAIN_SHOW && P_next == S_MAIN_IDLE)
      done_flag <= 0;
    else
      done_flag <= done_flag;
    if (blk_addr > 40960)
      P <= S_MAIN_FINAL;*/
  end
end
reg done_all;
always @(*) begin // FSM next-state logic
  case (P)
    S_MAIN_INIT: // wait for SD card initialization
      if (init_finished == 1) P_next = S_MAIN_IDLE;
      else P_next = S_MAIN_INIT;
    S_MAIN_IDLE: // wait for button click
      if (btn_pressed == 1) P_next = S_MAIN_WAIT;
      else P_next = S_MAIN_IDLE;
    S_MAIN_WAIT: // issue a rd_req to the SD controller until it's ready
      P_next = S_MAIN_READ;
    S_MAIN_READ: // wait for the input data to enter the SRAM buffer
      if (sd_counter == 512) begin
        P_next = S_MAIN_MID;
      end
      else begin
        P_next = S_MAIN_READ;
      end
    S_MAIN_MID: begin
      P_next = S_MAIN_DONE;
    end
    S_MAIN_DONE: begin // read byte 0 of the superblock from sram[]
      P_next = S_MAIN_SHOW;
      //blk_addr = blk_addr + 1;
    end
    S_MAIN_SHOW: begin
      if (sd_counter < 512 && done_all != 1) begin
        P_next = S_MAIN_MID;
      end
      else if (done_all) begin
        P_next = 3'b111;
      end
      else begin
        P_next = S_MAIN_WAIT;
      end
    end
    S_MAIN_FINAL:
      P_next = S_MAIN_FINAL;
    default:
      P_next = S_MAIN_IDLE;
  endcase
end



// FSM output logic: controls the 'rd_req' and 'rd_addr' signals.
reg [11:0] fa;
always @(*) begin
  rd_req = (P == S_MAIN_WAIT);
  rd_addr = blk_addr;
end

always @(posedge clk) begin
  if (~reset_n) blk_addr <= 32'h2000;
  else if (P == S_MAIN_SHOW && P_next == S_MAIN_WAIT)
    blk_addr <= blk_addr + 1; // In lab 6, change this line to scan all blocks
end

// FSM output logic: controls the 'sd_counter' signal.
// SD card read address incrementer
always @(posedge clk) begin
  if (~reset_n || (P == S_MAIN_READ && P_next == S_MAIN_MID) || (P == S_MAIN_SHOW && P_next == S_MAIN_WAIT))
    sd_counter <= 0;
  else if ((P == S_MAIN_READ && sd_valid) ||
           (P == S_MAIN_SHOW && P_next == S_MAIN_MID))
    sd_counter <= sd_counter + 1;
end

// FSM ouput logic: Retrieves the content of sram[] for display
always @(posedge clk) begin
  if (~reset_n) data_byte <= 8'b0;
  else if (sram_en && P == S_MAIN_DONE) data_byte <= data_out;
end
// End of the FSM of the SD card reader
// ------------------------------------------------------------------------
/*always @(posedge clk) begin
  if (~reset_n) begin
    
  end
  else if (P == S_MAIN_DONE && done_all == 0 && sram_en == 1) begin
    temp[39:8] = temp[31:0];
    temp[7:0] = data_byte;
  end
  if (found_start_tag == 0 && temp == "DLAB_") begin
    found_start_tag = 1;
  end
  else if (found_start_tag == 1 && found_end_tag == 0 && temp == "DLAB_") begin
    found_end_tag = 1;
    found_start_tag = 0;
    done_all = 1;
  end
end*/
//reg file_found;// reprsent in the text
reg [63:0] temp;// find start word
always@ (posedge clk) begin
    if(~reset_n) begin
        found_start_tag <= 0;
        done_all <= 0;
        temp <= 64'b0;
    end
    
    //use replace to find the start text
    if(sram_en && P == S_MAIN_DONE && done_all == 0) begin
        temp[63:8] <= temp[55:0];
        temp[7:0] <= data_out;
    end
    if(P == S_MAIN_SHOW && done_all == 0) begin
        if(found_start_tag == 0 && temp == "DLAB_TAG" ) begin
            //file <= 1;
            found_start_tag = 1;
        end
        else if(found_start_tag == 1 && temp == "DLAB_END") begin
            found_start_tag = 0;
            done_all <= 1;
            //file <= 0;
        end
    end
end
// ------------------------------------------------------------------------
// LCD Display function.
reg [10:0] cttothree = 0;
always @(posedge clk) begin
  if (found_start_tag == 1 && P == S_MAIN_SHOW) begin
    if(data_out <= "Z" && data_out >= "A" || data_out <= "z" && data_out >= "a") begin
      cttothree = cttothree + 1;
    end
    else begin
      if (cttothree == 3) begin
        ans = ans + 1;
        cttothree = 0;
      end
      else begin
        cttothree = 0;
      end
    end
  end
end
always @(posedge clk) begin
  if (~reset_n) begin
    row_A = "SD card cannot  ";
    row_B = "be initialized! ";
  end
  else if (P == 3'b111) begin
    row_A <= { "Found ", ((ans[15:12] > 9)? "7" : "0") + ans[15:12], ((ans[11:8] > 9)? "7" : "0") + ans[11:8], ((ans[7:4] > 9)? "7" : "0") + ans[7:4],
               ((ans[3:0] > 9)? "7" : "0") + ans[3:0], " words" };
    row_B <= "in the text file";
  end
  else if (P == S_MAIN_IDLE) begin
    row_A <= "Hit BTN2 to read";
    row_B <= "the SD card ... ";
  end
  //else if (P == S_MAIN_DONE) begin
  //  row_A <= "Data at [0x---] ";
  //  row_A[39:32] <= ((blk_addr[11:08] > 9)? "7" : "0") + blk_addr[11:08];
  //  row_A[31:24] <= ((blk_addr[07:04] > 9)? "7" : "0") + blk_addr[07:04];
  //  row_A[23:16] <= ((blk_addr[03:00] > 9)? "7" : "0") + blk_addr[03:00];
  //end
  //else if (P == S_MAIN_FINAL) begin
  //  row_A = "Data at [0x---] ";
  //  //df = blk_addr % 2048;
  //  //row_A[71:64] = ((blk_addr[27:24] > 9)? "7" : "0") + blk_addr[27:24];
  //  //row_A[63:56] = ((blk_addr[23:20] > 9)? "7" : "0") + blk_addr[23:20];
  //  //row_A[55:48] = ((blk_addr[19:16] > 9)? "7" : "0") + blk_addr[19:16];
  //  row_A[47:40] = ((blk_addr[15:12] > 9)? "7" : "0") + blk_addr[15:12];
  //  row_A[39:32] = ((blk_addr[11:08] > 9)? "7" : "0") + blk_addr[11:08];
  //  row_A[31:24] = ((blk_addr[07:04] > 9)? "7" : "0") + blk_addr[07:04];
  //  row_A[23:16] = ((blk_addr[03:00] > 9)? "7" : "0") + blk_addr[03:00];
  //  row_B = "be initiali   ! ";
  //  //df = blk_addr % 2048;
  //  row_B[39:32] = ((fa[11:08] > 9)? "7" : "0") + fa[11:08];
  //  row_B[31:24] = ((fa[07:04] > 9)? "7" : "0") + fa[07:04];
  //  row_B[23:16] = ((fa[03:00] > 9)? "7" : "0") + fa[03:00];
  //end
end
// End of the LCD display function
// ------------------------------------------------------------------------

endmodule
