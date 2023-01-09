`timescale 1ns / 1ps

module lab9(
  input clk,
  input reset_n,
  input [3:0] usr_btn,
  output [3:0] usr_led,
  output LCD_RS,
  output LCD_RW,
  output LCD_E,
  output [3:0] LCD_D
);

localparam [2:0] S_INIT = 3'b000, S_RESET_ALL_CORE = 3'b001, S_FEED_INPUT = 3'b010, S_MD5_CAL= 3'b011, 
  S_COMPARE_ALL_CORE = 3'b100, S_SHOW_RESULT = 3'b101, S_MINUS = 3'b110, S_OFFSET = 3'b111; 


reg [127:0] row_A = "Press BTN3 to   ";
reg [127:0] row_B = "start cracking..";

wire btn_level, btn_pressed;
reg  prev_btn_level;
reg [2:0] P, P_next;


reg [0:8*8-1] test_num_str ;
wire reset_md5, output_valid, input_valid;
wire [0:128-1] output_hash; 
reg [0:8*32-1] output_hash_str;
reg [8*8-1:0] answer_str;

reg [32-1:0] test_num_0 = 32'd0;
reg [32-1:0] test_num_1 = 32'd0;
reg [32-1:0] test_num_2 = 32'd0;
reg [32-1:0] test_num_3 = 32'd0;
reg [32-1:0] test_num_4 = 32'd0;
reg [32-1:0] test_num_5 = 32'd0;
reg [32-1:0] test_num_6 = 32'd0;
reg [32-1:0] test_num_7 = 32'd0;
reg [32-1:0] test_num_8 = 32'd0;
reg [32-1:0] test_num_9 = 32'd0;
reg [32-1:0] test_num_10 = 32'd0;
reg [32-1:0] test_num_11 = 32'd0;
reg [32-1:0] test_num_12 = 32'd0;
reg [32-1:0] test_num_13 = 32'd0;
reg [32-1:0] test_num_14 = 32'd0;
reg [32-1:0] test_num_15 = 32'd0;

reg [32-1:0] num_cvt_ans = 32'd0;
reg [32-1:0] num_cvt0 = 32'd0;
reg [32-1:0] num_cvt1 = 32'd0;
reg [32-1:0] num_cvt2 = 32'd0;
reg [32-1:0] num_cvt3 = 32'd0;
reg [32-1:0] num_cvt4 = 32'd0;
reg [32-1:0] num_cvt5 = 32'd0;
reg [32-1:0] num_cvt6 = 32'd0;
reg [32-1:0] num_cvt7 = 32'd0;
reg [32-1:0] num_cvt8 = 32'd0;
reg [32-1:0] num_cvt9 = 32'd0;
reg [32-1:0] num_cvt10 = 32'd0;
reg [32-1:0] num_cvt11 = 32'd0;
reg [32-1:0] num_cvt12 = 32'd0;
reg [32-1:0] num_cvt13 = 32'd0;
reg [32-1:0] num_cvt14 = 32'd0;
reg [32-1:0] num_cvt15 = 32'd0;

reg [8*8-1:0]test_str;
reg [127:0] clk_count;
reg [7:0] cvt_idx;

reg [8*7-1:0] time_str;

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
  
wire output_valid_0, hash_match_0;
wire [0:127] output_hash_0;
reg [8*8-1:0]test_str_0;
md5 md5_0(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_0),
  .input_ready(input_valid),
  .ans(output_hash_0),
  .output_ready(output_valid_0),
  .hash_match(hash_match_0)
);

wire output_valid_1, hash_match_1;
wire [0:127] output_hash_1;
reg [8*8-1:0]test_str_1;
md5 md5_1(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_1),
  .input_ready(input_valid),
  .ans(output_hash_1),
  .output_ready(output_valid_1),
  .hash_match(hash_match_1)
);

wire output_valid_2, hash_match_2;
wire [0:127] output_hash_2;
reg [8*8-1:0]test_str_2;
md5 md5_2(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_2),
  .input_ready(input_valid),
  .ans(output_hash_2),
  .output_ready(output_valid_2),
  .hash_match(hash_match_2)
);

wire output_valid_3, hash_match_3;
wire [0:127] output_hash_3;
reg [8*8-1:0]test_str_3;
md5 md5_3(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_3),
  .input_ready(input_valid),
  .ans(output_hash_3),
  .output_ready(output_valid_3),
  .hash_match(hash_match_3)
);

wire output_valid_4, hash_match_4;
wire [0:127] output_hash_4;
reg [8*8-1:0]test_str_4;
md5 md5_4(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_4),
  .input_ready(input_valid),
  .ans(output_hash_4),
  .output_ready(output_valid_4),
  .hash_match(hash_match_4)
);

wire output_valid_5, hash_match_5;
wire [0:127] output_hash_5;
reg [8*8-1:0]test_str_5;
md5 md5_5(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_5),
  .input_ready(input_valid),
  .ans(output_hash_5),
  .output_ready(output_valid_5),
  .hash_match(hash_match_5)
);

wire output_valid_6, hash_match_6;
wire [0:127] output_hash_6;
reg [8*8-1:0]test_str_6;
md5 md5_6(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_6),
  .input_ready(input_valid),
  .ans(output_hash_6),
  .output_ready(output_valid_6),
  .hash_match(hash_match_6)
);

wire output_valid_7, hash_match_7;
wire [0:127] output_hash_7;
reg [8*8-1:0]test_str_7;
md5 md5_7(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_7),
  .input_ready(input_valid),
  .ans(output_hash_7),
  .output_ready(output_valid_7),
  .hash_match(hash_match_7)
);

wire output_valid_8, hash_match_8;
wire [0:127] output_hash_8;
reg [8*8-1:0]test_str_8;
md5 md5_8(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_8),
  .input_ready(input_valid),
  .ans(output_hash_8),
  .output_ready(output_valid_8),
  .hash_match(hash_match_8)
);

wire output_valid_9, hash_match_9;
wire [0:127] output_hash_9;
reg [8*8-1:0]test_str_9;
md5 md5_9(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_9),
  .input_ready(input_valid),
  .ans(output_hash_9),
  .output_ready(output_valid_9),
  .hash_match(hash_match_9)
);

wire output_valid_10, hash_match_10;
wire [0:127] output_hash_10;
reg [8*8-1:0]test_str_10;
md5 md5_10(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_10),
  .input_ready(input_valid),
  .ans(output_hash_10),
  .output_ready(output_valid_10),
  .hash_match(hash_match_10)
);

wire output_valid_11, hash_match_11;
wire [0:127] output_hash_11;
reg [8*8-1:0]test_str_11;
md5 md5_11(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_11),
  .input_ready(input_valid),
  .ans(output_hash_11),
  .output_ready(output_valid_11),
  .hash_match(hash_match_11)
);

wire output_valid_12, hash_match_12;
wire [0:127] output_hash_12;
reg [8*8-1:0]test_str_12;
md5 md5_12(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_12),
  .input_ready(input_valid),
  .ans(output_hash_12),
  .output_ready(output_valid_12),
  .hash_match(hash_match_12)
);

wire output_valid_13, hash_match_13;
wire [0:127] output_hash_13;
reg [8*8-1:0]test_str_13;
md5 md5_13(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_13),
  .input_ready(input_valid),
  .ans(output_hash_13),
  .output_ready(output_valid_13),
  .hash_match(hash_match_13)
);

wire output_valid_14, hash_match_14;
wire [0:127] output_hash_14;
reg [8*8-1:0]test_str_14;
md5 md5_14(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_14),
  .input_ready(input_valid),
  .ans(output_hash_14),
  .output_ready(output_valid_14),
  .hash_match(hash_match_14)
);

wire output_valid_15, hash_match_15;
wire [0:127] output_hash_15;
reg [8*8-1:0]test_str_15;
md5 md5_15(
  .clk(clk),
  .reset(reset_md5),
  .init_msg(test_str_15),
  .input_ready(input_valid),
  .ans(output_hash_15),
  .output_ready(output_valid_15),
  .hash_match(hash_match_15)
);

wire matched;
assign matched = (hash_match_0 | hash_match_1 | hash_match_2 | hash_match_3 | hash_match_4 | hash_match_5
 | hash_match_6 | hash_match_7 | hash_match_8 | hash_match_9 | hash_match_10 | hash_match_11 | hash_match_12
 | hash_match_13 | hash_match_14 | hash_match_15);
assign usr_led = {matched, P};

debounce btn_db0(
  .clk(clk),
  .btn_input(usr_btn[3]),
  .btn_output(btn_level)
);           

assign reset_md5 = (P == S_RESET_ALL_CORE);
assign input_valid = (P == S_FEED_INPUT);

always @(posedge clk) begin
  if (~reset_n)
    prev_btn_level <= 0;
  else
    prev_btn_level <= btn_level;
end

assign btn_pressed = (btn_level == 1 && prev_btn_level == 0)? 1 : 0;

reg [31:0] ms_count;
always @(posedge clk) begin
  if (~reset_n)  begin
    clk_count <= 0;
    ms_count <= 0;
  end 
  else if (P == S_INIT) begin
    clk_count <= 0;
    ms_count <= 0;
  end
  else if(P != S_INIT && !matched)begin
    if(clk_count >= 100000) begin
        clk_count <= 0;
        ms_count <= ms_count + 1;
    end 
    else begin
      clk_count <= clk_count +1;
    end
  end
  else if(P == S_SHOW_RESULT && cvt_idx <= 6) begin
      ms_count <= ms_count / 10;
  end 
end

always @(posedge clk) begin
  if (~reset_n) begin
    time_str <="0000000";
  end
  else if(P==S_SHOW_RESULT && cvt_idx <= 6) begin
    time_str[(cvt_idx*8+7)-:8] <= (ms_count % 10) + "0";
  end 
end


always @(posedge clk) begin
  if (~reset_n) begin
    row_A <= "Press BTN3 to   ";
    row_B <= "start cracking..";
  end
  else begin
    if(P == S_INIT)begin
      row_A <= "Press BTN3 to   ";
      row_B <= "start cracking..";
    end
    else if (P == S_MD5_CAL) begin
      row_A <= "crckin' crkin'..";
      row_B <= "..crckin' crkin'";
    end
    else if(P == S_SHOW_RESULT)begin
      if(matched) begin//output_valid_3 == 1 || output_valid_0 == 1 || output_valid_2 == 1 || output_valid_1 == 1 || output_valid_4 == 1)begin
        row_A <= {"passwd: ", answer_str};
        row_B <= {"Time: ",time_str , " ms"};
      end
    end
  end
end



always @(posedge clk) begin
  if ( (P ==S_RESET_ALL_CORE) | (P ==S_SHOW_RESULT) ) begin
    if (cvt_idx > 100) cvt_idx <= 100;
    else cvt_idx <= cvt_idx +1;
  end
  else begin
    cvt_idx <= 0;
  end
end

always @(posedge clk) begin
  if (~reset_n) begin
    test_num_0 <= "00000000";
    test_num_1 <= "00000001";
    test_num_2 <= "00000002";
    test_num_3 <= "00000003";
    test_num_4 <= "00000004";
    test_num_5 <= "00000005";
    test_num_6 <= "00000006";
    test_num_7 <= "00000007";
    test_num_8 <= "00000008";
    test_num_9 <= "00000009";
    test_num_10 <= "00000009" + 1;
    test_num_11 <= "00000009" + 2;
    test_num_12 <= "00000009" + 3;
    test_num_13 <= "00000009" + 4;
    test_num_14 <= "00000009" + 5;
    test_num_15 <= "00000009" + 6;
  end
  else if (P == S_INIT)begin
    test_num_0 <= "00000000";
    test_num_1 <= "00000001";
    test_num_2 <= "00000002";
    test_num_3 <= "00000003";
    test_num_4 <= "00000004";
    test_num_5 <= "00000005";
    test_num_6 <= "00000006";
    test_num_7 <= "00000007";
    test_num_8 <= "00000008";
    test_num_9 <= "00000009";
    test_num_10 <= "00000009" + 1;
    test_num_11 <= "00000009" + 2;
    test_num_12 <= "00000009" + 3;
    test_num_13 <= "00000009" + 4;
    test_num_14 <= "00000009" + 5;
    test_num_15 <= "00000009" + 6;
  end
  else if(P == S_COMPARE_ALL_CORE) begin
    test_num_0 <= test_num_0 + 16;
    test_num_1 <= test_num_1 + 16;
    test_num_2 <= test_num_2 + 16;
    test_num_3 <= test_num_3 + 16;
    test_num_4 <= test_num_4 + 16;
    test_num_5 <= test_num_5 + 16;
    test_num_6 <= test_num_6 + 16;
    test_num_7 <= test_num_7 + 16;
    test_num_8 <= test_num_8 + 16;
    test_num_9 <= test_num_9 + 16;
    test_num_10 <= test_num_10 + 16;
    test_num_11 <= test_num_11 + 16;
    test_num_12 <= test_num_12 + 16;
    test_num_13 <= test_num_13 + 16;
    test_num_14 <= test_num_14 + 16;
    test_num_15 <= test_num_15 + 16;
  end
end


always @(posedge clk) begin
    if (~reset_n) begin
      num_cvt0 <= 0;
      num_cvt1 <= 0;
      num_cvt2 <= 0;
      num_cvt3 <= 0;
      num_cvt4 <= 0;
      num_cvt5 <= 0;
      num_cvt6 <= 0;
      num_cvt7 <= 0;
      num_cvt8 <= 0;
      num_cvt9 <= 0;
      num_cvt10 <= 0;
      num_cvt11 <= 0;
      num_cvt12 <= 0;
      num_cvt13 <= 0;
      num_cvt14 <= 0;
      num_cvt15 <= 0;
    end
    else if(P == S_COMPARE_ALL_CORE) begin
      num_cvt0 <= test_num_0 - 1;
      num_cvt1 <= test_num_1 - 1;
      num_cvt2 <= test_num_2 - 1;
      num_cvt3 <= test_num_3 - 1;
      num_cvt4 <= test_num_4 - 1;
      num_cvt5 <= test_num_5 - 1;
      num_cvt6 <= test_num_6 - 1;
      num_cvt7 <= test_num_7 - 1;
      num_cvt8 <= test_num_8 - 1;
      num_cvt9 <= test_num_9 - 1;
      num_cvt10 <= test_num_10 - 1;
      num_cvt11 <= test_num_11 - 1;
      num_cvt12 <= test_num_12 - 1;
      num_cvt13 <= test_num_13 - 1;
      num_cvt14 <= test_num_14 - 1;
      num_cvt15 <= test_num_15 - 1;
    end
    else if(P == S_INIT) begin
      num_cvt0 <= test_num_0;
      num_cvt1 <= test_num_1;
      num_cvt2 <= test_num_2;
      num_cvt3 <= test_num_3;
      num_cvt4 <= test_num_4;
      num_cvt5 <= test_num_5;
      num_cvt6 <= test_num_6;
      num_cvt7 <= test_num_7;
      num_cvt8 <= test_num_8;
      num_cvt9 <= test_num_9;
      num_cvt10 <= test_num_10;
      num_cvt11 <= test_num_11;
      num_cvt12 <= test_num_12;
      num_cvt13 <= test_num_13;
      num_cvt14 <= test_num_14;
      num_cvt15 <= test_num_15;
    end
    else if(P== S_RESET_ALL_CORE && cvt_idx < 8) begin
      test_str_0[(cvt_idx*8+7)-:8] <= (num_cvt0 % 10) + "0";
      test_str_1[(cvt_idx*8+7)-:8] <= (num_cvt1 % 10) + "0";
      test_str_2[(cvt_idx*8+7)-:8] <= (num_cvt2 % 10) + "0";
      test_str_3[(cvt_idx*8+7)-:8] <= (num_cvt3 % 10) + "0";
      test_str_4[(cvt_idx*8+7)-:8] <= (num_cvt4 % 10) + "0";
      test_str_5[(cvt_idx*8+7)-:8] <= (num_cvt5 % 10) + "0";
      test_str_6[(cvt_idx*8+7)-:8] <= (num_cvt6 % 10) + "0";
      test_str_7[(cvt_idx*8+7)-:8] <= (num_cvt7 % 10) + "0";
      test_str_8[(cvt_idx*8+7)-:8] <= (num_cvt8 % 10) + "0";
      test_str_9[(cvt_idx*8+7)-:8] <= (num_cvt9 % 10) + "0";
      test_str_10[(cvt_idx*8+7)-:8] <= (num_cvt10 % 10) + "0";
      test_str_11[(cvt_idx*8+7)-:8] <= (num_cvt11 % 10) + "0";
      test_str_12[(cvt_idx*8+7)-:8] <= (num_cvt12 % 10) + "0";
      test_str_13[(cvt_idx*8+7)-:8] <= (num_cvt13 % 10) + "0";
      test_str_14[(cvt_idx*8+7)-:8] <= (num_cvt14 % 10) + "0";
      test_str_15[(cvt_idx*8+7)-:8] <= (num_cvt15 % 10) + "0";
      num_cvt0 <= num_cvt0 / 10;
      num_cvt1 <= num_cvt1 / 10;
      num_cvt2 <= num_cvt2 / 10;
      num_cvt3 <= num_cvt3 / 10;
      num_cvt4 <= num_cvt4 / 10;
      num_cvt5 <= num_cvt5 / 10;
      num_cvt6 <= num_cvt6 / 10;
      num_cvt7 <= num_cvt7 / 10;
      num_cvt8 <= num_cvt8 / 10;
      num_cvt9 <= num_cvt9 / 10;
      num_cvt10 <= num_cvt10 / 10;
      num_cvt11 <= num_cvt11 / 10;
      num_cvt12 <= num_cvt12 / 10;
      num_cvt13 <= num_cvt13 / 10;
      num_cvt14 <= num_cvt14 / 10;
      num_cvt15 <= num_cvt15 / 10;
    end
    else if (P == S_MINUS) begin
      if (hash_match_0) num_cvt_ans <= num_cvt0 - 16;
      else if (hash_match_1) num_cvt_ans <= num_cvt1 - 16;
      else if (hash_match_2) num_cvt_ans <= num_cvt2 - 16;
      else if (hash_match_3) num_cvt_ans <= num_cvt3 - 16;
      else if (hash_match_4) num_cvt_ans <= num_cvt4 - 16;
      else if (hash_match_5) num_cvt_ans <= num_cvt5 - 16;
      else if (hash_match_6) num_cvt_ans <= num_cvt6 - 16;
      else if (hash_match_7) num_cvt_ans <= num_cvt7 - 16;
      else if (hash_match_8) num_cvt_ans <= num_cvt8 - 16;
      else if (hash_match_9) num_cvt_ans <= num_cvt9 - 16;
      else if (hash_match_10) num_cvt_ans <= num_cvt10 - 16;
      else if (hash_match_11) num_cvt_ans <= num_cvt11 - 16;
      else if (hash_match_12) num_cvt_ans <= num_cvt12 - 16;
      else if (hash_match_13) num_cvt_ans <= num_cvt13 - 16;
      else if (hash_match_14) num_cvt_ans <= num_cvt14 - 16;
      else if (hash_match_15) num_cvt_ans <= num_cvt15 - 16;
    end
    else if (P==S_SHOW_RESULT && cvt_idx < 8) begin
      answer_str[(cvt_idx*8+7)-:8] <= (num_cvt_ans % 10) + "0";
      num_cvt_ans <= num_cvt_ans / 10;
    end 
end




always @(posedge clk) begin
  if (~reset_n) P <= S_INIT;
  else P <= P_next;
end


always @(*) begin
  case (P)
    S_INIT:
      if(btn_pressed) P_next = S_RESET_ALL_CORE;
      else P_next = S_INIT;
    S_RESET_ALL_CORE:
      if(cvt_idx >= 8) P_next = S_FEED_INPUT;
      else P_next =S_RESET_ALL_CORE;
    S_FEED_INPUT:
      P_next = S_MD5_CAL;
    S_MD5_CAL:
      if (output_valid_0 && output_valid_1 && output_valid_2 && output_valid_3 && output_valid_4) P_next = S_COMPARE_ALL_CORE;
      else P_next = S_MD5_CAL;
    S_COMPARE_ALL_CORE:
      if(matched) P_next = S_MINUS;
      else P_next = S_RESET_ALL_CORE;
    S_MINUS:
      P_next = S_SHOW_RESULT;
    S_SHOW_RESULT:
      if (btn_pressed == 1) P_next = S_INIT;
      else P_next = S_SHOW_RESULT;
endcase
end



endmodule
