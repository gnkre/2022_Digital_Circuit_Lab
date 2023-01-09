`timescale 1ns / 1ps
/////////////////////////////////////////////////////////
module lab5(
  input clk,
  input reset_n,
  input [3:0] usr_btn,
  output [3:0] usr_led,
  output LCD_RS,
  output LCD_RW,
  output LCD_E,
  output [3:0] LCD_D
);

// turn off all the LEDs
assign usr_led = 4'b0000;
//module bit2ASCII b1
wire btn_level, btn_pressed;
reg prev_btn_level;
reg [127:0] row_A = "Press BTN3 to   "; // Initialize the text of the first row. 
//reg [127:0] row_B = "show a message.."; // Initialize the text of the second row.
reg [127:0] row_B = "Press BTN3 to   ";
reg btn_pres;
reg [15:0] fb_result[24:0];
reg [5:0] for_counter = 2;
reg [39:0] time_counter = 0;
reg is_it_done = 0;
reg signed [10:0] index = 0;
reg signed [10:0] index1 = 1;
reg [7:0] temp_res [3:0];
reg [7:0] temp_res1 [3:0];
reg scroll = 1;
wire pressed;
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
    
debounce btn_db0(
  .clk(clk),
  .pb_1(usr_btn[3]),
  .pb_out(btn_level)
);
assign pressed = (btn_pres == 0 && btn_level == 1);

always @(posedge clk)
begin
    btn_pres <= btn_level;
end

always @(posedge clk)
begin
    if (pressed == 1)
    begin
        if (scroll == 0) begin
            scroll = 1;
        end
        else begin
            scroll = 0;
        end
    end
    if (~reset_n) 
    begin
        //fb_counter = 0;
    end
    else if (is_it_done == 0) 
    begin
        if (for_counter >= 25) 
        begin
            is_it_done = 1;
        end
        else 
        begin
            fb_result[0] = 0;
            fb_result[1] = 1;
            fb_result[for_counter] = fb_result[for_counter - 1] + fb_result[for_counter - 2];
            for_counter = for_counter + 1;
        end
    end
    else 
    begin
        row_A = "Fibo #   is     ";
        row_A[79:72] = ((index + 1) / 16);
        row_A[71:64] = (index + 1) % 16;
        if (row_A[79:72] >= 10)
        begin
            row_A[79:72] = (row_A[79:72] - 10) + "A";
        end
        else
        begin
            row_A[79:72] = row_A[79:72] + "0";
        end
        if (row_A[71:64] >= 10)
        begin
            row_A[71:64] = (row_A[71:64] - 10) + "A";
        end
        else
        begin
            row_A[71:64] = row_A[71:64] + "0";
        end
        // index module bit2ASCII
        temp_res1[3] = (fb_result[index] / 4096);
        temp_res1[2] = ((fb_result[index] / 256) % 16);
        temp_res1[1] = (fb_result[index] / 16) % 16;
        temp_res1[0] = fb_result[index] % 16;

        if (temp_res1[3] > 0) 
        begin
            if (temp_res1[3] > 9) 
            begin
                row_A[31:24] = "A" + (temp_res1[3] - 10);
            end
            else 
            begin
                row_A[31:24] = "0" + (temp_res1[3]);
            end
        end
        else
        begin
            row_A[31:24] = "0";
        end
        
        if (temp_res1[2] > 0) 
        begin
            if (temp_res1[2] > 9) 
            begin
                row_A[23:16] = "A" + (temp_res1[2] - 10);
            end
            else 
            begin
                row_A[23:16] = "0" + (temp_res1[2]);
            end
        end
        else
        begin
            row_A[23:16] = "0";
        end
        
        if (temp_res1[1] > 0) 
        begin
            if (temp_res1[1] > 9) 
            begin
                row_A[15:8] = "A" + (temp_res1[1] - 10);
            end
            else 
            begin
                row_A[15:8] = "0" + (temp_res1[1]);
            end
        end
        else
        begin
            row_A[15:8] = "0";
        end
        
        if (temp_res1[0] > 0) 
        begin
            if (temp_res1[0] > 9) 
            begin
                row_A[7:0] = "A" + (temp_res1[0] - 10);
            end
            else 
            begin
                row_A[7:0] = "0" + (temp_res1[0]);
            end
        end
        else
        begin
            row_A[7:0] = "0";
        end
        row_B = "Fibo #   is     ";
    // index start
        row_B[79:72] = ((index1 + 1) / 16);
        row_B[71:64] = (index1 + 1) % 16;
        if (row_B[79:72] >= 10)
        begin
            row_B[79:72] = (row_B[79:72] - 10) + "A";
        end
        else
        begin
            row_B[79:72] = row_B[79:72] + "0";
        end
        if (row_B[71:64] >= 10)
        begin
            row_B[71:64] = (row_B[71:64] - 10) + "A";
        end
        else
        begin
            row_B[71:64] = row_B[71:64] + "0";
        end
        // index module bit2ASCII
        temp_res[3] = (fb_result[index1] / 4096);
        temp_res[2] = ((fb_result[index1] / 256) % 16);
        temp_res[1] = (fb_result[index1] / 16) % 16;
        temp_res[0] = fb_result[index1] % 16;

        if (temp_res[3] > 0) 
        begin
            if (temp_res[3] > 9) 
            begin
                row_B[31:24] = "A" + (temp_res[3] - 10);
            end
            else 
            begin
                row_B[31:24] = "0" + (temp_res[3]);
            end
        end
        else
        begin
            row_B[31:24] = "0";
        end
        
        if (temp_res[2] > 0) 
        begin
            if (temp_res[2] > 9) 
            begin
                row_B[23:16] = "A" + (temp_res[2] - 10);
            end
            else 
            begin
                row_B[23:16] = "0" + (temp_res[2]);
            end
        end
        else
        begin
            row_B[23:16] = "0";
        end
        
        if (temp_res[1] > 0) 
        begin
            if (temp_res[1] > 9) 
            begin
                row_B[15:8] = "A" + (temp_res[1] - 10);
            end
            else 
            begin
                row_B[15:8] = "0" + (temp_res[1]);
            end
        end
        else
        begin
            row_B[15:8] = "0";
        end
        
        if (temp_res[0] > 0) 
        begin
            if (temp_res[0] > 9) 
            begin
                row_B[7:0] = "A" + (temp_res[0] - 10);
            end
            else
            begin
                row_B[7:0] = "0" + (temp_res[0]);
            end
        end
        else
        begin
            row_B[7:0] = "0";
        end
    end
    if (time_counter < 80000000) 
    begin
        time_counter = time_counter + 1;
    end
    else if (time_counter >= 80000000) 
    begin
        time_counter = 0;
        if (scroll == 0) begin
            index = index + 1;
            index1 = index1 + 1;
        end
        else if (scroll == 1) begin
            index = index - 1;
            index1 = index1 - 1;
        end
        if (index > 24)
        begin
            index = 0;
        end
        else if (index < 0) begin
            index = 24;
        end
        if (index1 < 0) begin
            index1 = 24;
        end
        else if (index1 > 24) begin
            index1 = 0;
        end
    end
end
endmodule

module debounce(input pb_1,clk,output pb_out);
wire slow_clk_en;
wire Q1,Q2,Q2_bar,Q0;
clock_enable u1(clk,slow_clk_en);
my_dff_en d0(clk,slow_clk_en,pb_1,Q0);

my_dff_en d1(clk,slow_clk_en,Q0,Q1);
my_dff_en d2(clk,slow_clk_en,Q1,Q2);
assign Q2_bar = ~Q2;
assign pb_out = Q1 & Q2_bar;
endmodule
// Slow clock enable for debouncing button 
module clock_enable(input Clk_100M,output slow_clk_en);
    reg [26:0]counter=0;
    always @(posedge Clk_100M)
    begin
       counter <= (counter>=249999)?0:counter+1;
    end
    assign slow_clk_en = (counter == 249999)?1'b1:1'b0;
endmodule
// D-flip-flop with clock enable signal for debouncing module 
module my_dff_en(input DFF_CLOCK, clock_enable,D, output reg Q=0);
    always @ (posedge DFF_CLOCK) begin
  if(clock_enable==1) 
           Q <= D;
    end
endmodule 