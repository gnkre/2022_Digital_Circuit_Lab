`timescale 1ns / 1ps
module lab4(
  input  clk,            // System clock at 100 MHz
  input  reset_n,        // System reset signal, in negative logic
  input  [3:0] usr_btn,  // Four user pushbuttons
  output [3:0] usr_led   // Four yellow LEDs
);


reg signed [3:0] counter = 4'b0000;
reg [3:0] finaloutput = 0;
reg [26:0] ctr = 0;
reg [26:0] ctrmain = 0;
localparam min = -8, max = 7;
localparam pwnfive = 50000, pwntwentyfive = 250000, pwnfifty = 500000, pwnseventyfive = 750000, pwnonehundured = 999000;
reg [2:0] pwnstatus = 0;
reg [19:0] pwnctr = 0;


always @(posedge clk, negedge reset_n) begin
    if (reset_n == 0) begin
        ctr <= 0;
        ctrmain <= 0;
        finaloutput <= 0;
        pwnstatus <= 0;
        pwnctr <= 0;
        counter <= 0;
    end
    else if (clk == 1) begin
        pwnctr <= pwnctr + 1;
        if (pwnctr == 999990) begin
            pwnctr <= 0;
            finaloutput <= counter;
        end
        if (pwnstatus == 0) begin
            if (pwnctr == pwnfive) begin
                finaloutput <= 0;
            end
        end
        else if (pwnstatus == 1) begin
            if (pwnctr == pwntwentyfive) begin
                finaloutput <= 0;
            end
        end
        else if (pwnstatus == 2) begin
            if (pwnctr == pwnfifty) begin
                finaloutput <= 0;
            end
        end
        else if (pwnstatus == 3) begin
            if (pwnctr == pwnseventyfive) begin
                finaloutput <= 0;
            end
        end
        else if (pwnstatus == 4) begin
            if (pwnctr == pwnonehundured) begin
                finaloutput <= 0;
            end
        end
        if (usr_btn[0] == 1 && ctr < 10000000) begin
            ctr <= ctr + 1;
        end
        else if (usr_btn[0] == 1 && ctr >= 10000000) begin
            ctr <= 0;
            if (counter > min) begin
                counter = counter - 1;
            end
        end
        
        else if (usr_btn[1] == 1 && ctr < 10000000) begin
            ctr <= ctr + 1;
        end
        else if (usr_btn[1] == 1 && ctr >= 10000000) begin
            ctr <= 0;
            if (counter < max) begin
                counter = counter + 1;
            end
        end
        
        else if (usr_btn[2] == 1 && ctr < 10000000) begin
            ctr <= ctr + 1;
        end
        else if (usr_btn[2] == 1 && ctr >= 10000000) begin
            ctr <= 0;
            if (pwnstatus > 0) begin
                pwnstatus <= pwnstatus - 1;
            end
        end
        
        else if (usr_btn[3] == 1 && ctr < 10000000) begin
            ctr <= ctr + 1;
        end
        else if (usr_btn[3] == 1 && ctr >= 10000000) begin
            ctr <= 0;
            if (pwnstatus < 4) begin
                pwnstatus <= pwnstatus + 1;
            end
        end
        
        else if (ctrmain >= 17000000) begin //make it smaller
            ctrmain <= 0;
            ctr <= 0;
        end
        else begin
            ctrmain <= ctrmain + 1;
        end
    end
end

//assign usr_led = counter;
assign usr_led = finaloutput;

endmodule