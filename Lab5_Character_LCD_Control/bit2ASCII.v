`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/20 20:23:12
// Design Name: 
// Module Name: bit2ASCII
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


module bit2ASCII(
input [4:0] index, output [127:0] result
    );
reg [127:0] temp = "Fibo #   is     "; //7 8       12 13 14 15

always @ (posedge num_in) begin
    if (index >= 10) begin
        temp[71:64] <= (index - (index % 10)) / 10 + "0";
    end
    else begin
        temp[71:64] <= "0";
    end
    temp[63:56] <= (index % 10) + "0";
end
 assign result = temp;
    
endmodule
