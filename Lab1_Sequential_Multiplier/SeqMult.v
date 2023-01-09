//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/21 07:42:15
// Design Name: 
// Module Name: SeqMult
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


module SeqMultiplier(
    input [7:0] A,
    input [7:0] B,
    input clk,
    input enable,
    output [15:0] C
);
    reg [3:0]counter;
    reg [15:0]temp_prod;
    reg [7:0]mult_number;
    wire shift;

    assign shift = |(counter ^ 7);
    assign C = temp_prod;

    always @(posedge clk) begin
        if (!enable) begin
            temp_prod <= 0;
            counter <= 0;
            mult_number <= B;
        end
        else begin
            temp_prod <= (temp_prod + (A & {8{mult_number[7]}})) << shift;
            mult_number <= mult_number << 1;
            counter <= counter + shift;
        end
    end
endmodule
