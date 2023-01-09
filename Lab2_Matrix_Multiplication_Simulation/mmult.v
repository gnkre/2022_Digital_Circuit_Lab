module mmult(
    input clk,
    input reset_n,
    input enable,
    input [0:9*8-1] A_mat,
    input [0:9*8-1] B_mat,
    output valid,
    output reg [0:9*17-1] C_mat
);

    reg [3:0]counter = 0;
    reg _valid = 0;
    assign valid = _valid;
    reg [7:0] A_temp [2:0][2:0];
    reg [7:0] B_temp [2:0][2:0];
    reg [16:0] C_temp [2:0][2:0];
    integer ctr = 0;
    reg [16:0] temp;
    integer i, j;

    always @(negedge reset_n) begin
        for(i = 0;i <= 2; i = i + 1) begin
            for(j = 0; j <= 2; j = j + 1) begin
                A_temp[i][j] = A_mat[(i*3+j)*8 +: 8];
                B_temp[i][j] = B_mat[(i*3+j)*8 +: 8];
                C_temp£w[i][j] = 17'd0;
            end
        end
    end
    always @(posedge clk) begin
        if (ctr != 3 && enable == 1) begin
            //use = instead of <=
            C_temp[ctr][0] = (A_temp[ctr][0] * B_temp[0][0]) + (A_temp[ctr][1] * B_temp[1][0]) + (A_temp[ctr][2] * B_temp[2][0]);
            C_temp[ctr][1] = (A_temp[ctr][0] * B_temp[0][1]) + (A_temp[ctr][1] * B_temp[1][1]) + (A_temp[ctr][2] * B_temp[2][1]);
            C_temp[ctr][2] = (A_temp[ctr][0] * B_temp[0][2]) + (A_temp[ctr][1] * B_temp[1][2]) + (A_temp[ctr][2] * B_temp[2][2]);
            $display ("C[%d][%d] is %d", ctr, 0, C_temp[ctr][0]);
            $display ("C[%d][%d] is %d", ctr, 1, C_temp[ctr][1]);
            $display ("C[%d][%d] is %d", ctr, 2, C_temp[ctr][2]);
            $display ("===%d===", ctr);
            ctr = ctr + 1;
            _valid <= 0;
        end
        else if (ctr == 3 && enable == 1) begin
            for(i = 0; i <= 2; i = i + 1) begin
                for(j = 0; j <= 2; j = j + 1) begin
                    C_mat[(i * 3 + j) * 17 +: 17] = C_temp[i][j];
                end
            end
            _valid <= 1;

        end
    end
endmodule
