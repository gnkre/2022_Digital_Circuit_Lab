module alu(
    output [7:0]alu_out,
    output zero,
    input [2:0]opcode,
    input [7:0]data,
    input [7:0]accum,
    input clk,
    input reset
);
    reg [7:0]aluu = 0;
    reg zeroo = 1;
    always @(posedge clk) begin
        if (reset == 0 && opcode >= 0) begin
            if (opcode == 3'b000) begin
                aluu = accum;
            end
            else if (opcode == 3'b001) begin
                aluu = accum + data;
            end
            else if (opcode == 3'b010) begin
                aluu = accum - data;
            end
            else if (opcode == 3'b011) begin
                aluu = accum & data;
            end
            else if (opcode == 3'b100) begin
                aluu = accum ^ data;
            end
            else if (opcode == 3'b101) begin
                if (accum[7] == 1) begin
                    aluu = -(accum);
                end
                else begin
                    aluu = accum;
                end
            end
            else if (opcode == 3'b110) begin
                aluu = accum * data;
            end
            else begin
                aluu = data;
            end
        end
        else if (reset == 1) begin
            aluu = 0;
            zeroo = 1;
        end
    end
    assign alu_out = aluu;
    assign zero = zeroo;
    always @(alu_out) begin
        if (alu_out > 0) begin
            zeroo = 0;
        end
        else begin
            zeroo = 1;
        end
    end
endmodule
