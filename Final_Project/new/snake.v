module snake
(
input clk,
input vga_clk,
input snake_clk,
input reset_n,
input up_btn,
input down_btn,
input right_btn,
input left_btn,
input collision, // for obastcle
input levelup, // for upgrade and resize it length
input wire [4:0] size,
input wire same_dir,
input wire [9:0] pixel_x,
input wire [9:0] pixel_y,
input wire pixel_tick,
output snake_region,
output [9:0] top_bound,
output [9:0] bottom_bound,
output [9:0] right_bound,
output [9:0] left_bound,
output [9:0] snake_head_x,
output [9:0] snake_head_y,
output [1:0] dir
);

parameter up = 2'b00, down = 2'b01, right = 2'b10, left = 2'b11;

reg[1:0] dir = right, prev_dir;

reg [9:0] snake_posX [0:24];
reg [9:0] snake_posY [0:24];
reg [9:0] prev_snake_posX [0:24];
reg [9:0] prev_snake_posY [0:24];

reg [9:0] snake_head_x;
reg [9:0] snake_head_y;
reg [4:0] cross_border_x, cross_border_y;
reg [9:0] top_bound, bottom_bound, right_bound, left_bound;
reg [4:0] size;
reg snake_region;
reg bound_region;

reg levelup_done = 0;

wire collision;

initial begin
    snake_posX[0]= 120;
    snake_posX[1]= 100;
    snake_posX[2]= 80;
    snake_posX[3]= 60;
    snake_posX[4]= 40;
    snake_posX[5]= 1000;
    snake_posX[6]= 1000;
    snake_posX[7]= 1000;
    snake_posX[8]= 1000;
    snake_posX[9]= 1000;
    snake_posX[10]= 1000;
    snake_posX[11]= 1000;
    snake_posX[12]= 1000;
    snake_posX[13]= 1000;
    snake_posX[14]= 1000;
    snake_posX[15]= 1000;
    snake_posX[16]= 1000;
    snake_posX[17]= 1000;
    snake_posX[18]= 1000;
    snake_posX[19]= 1000;
    snake_posX[20]= 1000;
    snake_posX[21]= 1000;
    snake_posX[22]= 1000;
    snake_posX[23]= 1000;
    snake_posX[24]= 1000;

    snake_posY[0]= 368;
    snake_posY[1]= 368;
    snake_posY[2]= 368;
    snake_posY[3]= 368;
    snake_posY[4]= 368;
    snake_posY[5]= 1000;
    snake_posY[6]= 1000;
    snake_posY[7]= 1000;
    snake_posY[8]= 1000;
    snake_posY[9]= 1000;
    snake_posY[10]= 1000;
    snake_posY[11]= 1000;
    snake_posY[12]= 1000;
    snake_posY[13]= 1000;
    snake_posY[14]= 1000;
    snake_posY[15]= 1000;
    snake_posY[16]= 1000;
    snake_posY[17]= 1000;
    snake_posY[18]= 1000;
    snake_posY[19]= 1000;
    snake_posY[20]= 1000;
    snake_posY[21]= 1000;
    snake_posY[22]= 1000;
    snake_posY[23]= 1000;
    snake_posY[24]= 1000;
end


always @(posedge clk) begin// or posedge up_btn or posedge down_btn or posedge right_btn or posedge left_btn) begin
    if(levelup)begin
    dir <= right;
    end
    else if (up_btn) begin 
        if(dir!=down) dir <= up; 
    end
    else if(down_btn) begin 
        if(dir!=up) dir <= down; 
    end
    else if(right_btn) begin 
        if(dir!=left) dir <= right;
    end
    else if(left_btn) begin 
        if(dir!=right) dir <= left; 
    end
end

reg[4:0] i, j, k, l;
reg [9:0] temp_bound;
integer o;
always @(posedge snake_clk) begin
    cross_border_x <= cross_border_x == 0 ? 0 : cross_border_x - 1;
    cross_border_y <= cross_border_y == 0 ? 0 : cross_border_y - 1;
    if(levelup) begin
        snake_posX[0] <= 100;
        snake_posX[1] <= 80;
        snake_posX[2] <= 60;
        snake_posX[3] <= 40;
        snake_posX[4] <= 20;
        snake_posX[5] <= 1000;
        snake_posX[6] <= 1000;
        snake_posX[7] <= 1000;
        snake_posX[8] <= 1000;
        snake_posX[9] <= 1000;
        snake_posX[10] <= 1000;
        snake_posX[11] <= 1000;
        snake_posX[12] <= 1000;
        snake_posX[13] <= 1000;
        snake_posX[14] <= 1000;
        snake_posX[15] <= 1000;
        snake_posX[16] <= 1000;
        snake_posX[17] <= 1000;
        snake_posX[18] <= 1000;
        snake_posX[19] <= 1000;
        snake_posX[20] <= 1000;
        snake_posX[21] <= 1000;
        snake_posX[22] <= 1000;
        snake_posX[23] <= 1000;
        snake_posX[24] <= 1000;
    
        snake_posY[0] <= 368;
        snake_posY[1] <= 368;
        snake_posY[2] <= 368;
        snake_posY[3] <= 368;
        snake_posY[4] <= 368;
        snake_posY[5] <= 1000;
        snake_posY[6] <= 1000;
        snake_posY[7] <= 1000;
        snake_posY[8] <= 1000;
        snake_posY[9] <= 1000;
        snake_posY[10] <= 1000;
        snake_posY[11] <= 1000;
        snake_posY[12] <= 1000;
        snake_posY[13] <= 1000;
        snake_posY[14] <= 1000;
        snake_posY[15] <= 1000;
        snake_posY[16] <= 1000;
        snake_posY[17] <= 1000;
        snake_posY[18] <= 1000;
        snake_posY[19] <= 1000;
        snake_posY[20] <= 1000;
        snake_posY[21] <= 1000;
        snake_posY[22] <= 1000;
        snake_posY[23] <= 1000;
        snake_posY[24] <= 1000;
        for(o = 0; o < 25; o = o + 1) begin
            prev_snake_posX[0] <= snake_posX[0];
            prev_snake_posY[0] <= snake_posY[0];
        end
        levelup_done <= 1;
    end
    else begin
        levelup_done <= 0;
    end
    if(!collision) begin 
        prev_snake_posX[0] <= snake_posX[0];
        prev_snake_posY[0] <= snake_posY[0];
    end
    for(i = 24; i > 0; i = i - 1) begin
        if(i < size && !collision && !levelup) begin
            snake_posX[i] = snake_posX[i-1]; 
            snake_posY[i] = snake_posY[i-1]; 

            if(i == size) begin
                top_bound =  snake_posY[i];
                bottom_bound = snake_posY[i];
                left_bound = snake_posX[i];
                right_bound = snake_posX[i];
            end
            else begin
                top_bound = snake_posY[i] < top_bound ? snake_posY[i] : top_bound;
                bottom_bound = snake_posY[i] > bottom_bound ? snake_posY[i] : bottom_bound;
                left_bound = snake_posX[i] < left_bound ? snake_posX[i] : left_bound;
                right_bound = snake_posX[i] > right_bound ? snake_posX[i] : right_bound;
            end
        end
    end
    top_bound <= snake_posY[0] < top_bound ? snake_posY[0] : top_bound;
    bottom_bound <= snake_posY[0] > bottom_bound ? snake_posY[0] : bottom_bound;
    left_bound <= snake_posX[0] < left_bound ? snake_posX[0] : left_bound;
    right_bound <= snake_posX[0] > right_bound ? snake_posX[0] : right_bound;
    case(dir)
        up: 
        begin
            if(collision && same_dir) snake_posY[0] <= prev_snake_posY[0];
            else if(snake_posY[0] == 16) begin
                snake_posY[0] <= 368;
                cross_border_y <= size;
            end
            else snake_posY[0] <=(snake_posY[0] - 16);
        end
        down: 
        begin 
            if(collision && same_dir) snake_posY[0] <= prev_snake_posY[0];
            else if(snake_posY[0] + 16 > 368) begin
                snake_posY[0] <= 16;
                cross_border_y <= size;
            end
            else snake_posY[0] <= (snake_posY[0] + 16);
        end
        right: 
        begin 
            if(collision && same_dir) snake_posX[0] <= prev_snake_posX[0];
            else if(snake_posX[0] + 20 > 600) begin 
                snake_posX[0] <= 20;
                cross_border_x <= size;
            end
            else snake_posX[0] <= (snake_posX[0] + 20);
        end
        left: 
        begin 
            if(collision && same_dir) snake_posX[0] <= prev_snake_posX[0];
            else if(snake_posX[0] == 20) begin 
                snake_posX[0] <= 600;
                cross_border_x <= size;
            end
            else snake_posX[0] <= (snake_posX[0] - 20);
        end
        
    endcase
    //if(cross_border_x > 0) begin
    //    temp_bound = left_bound;
    //    left_bound = right_bound;
    //    right_bound = temp_bound;
    //end
    //if(cross_border_y > 0) begin
    //    temp_bound = top_bound;
    //    top_bound = bottom_bound;
    //    bottom_bound = temp_bound;
    //end
    //bottom_bound = bottom_bound + 16;
    //right_bound = right_bound + 20;
    snake_head_x <= snake_posX[0];
    snake_head_y <= snake_posY[0];
end



always @(posedge vga_clk) begin
    snake_region = 0;
    for(j = 0; j < 25; j = j + 1)begin
        if(snake_region == 0 )
			snake_region = (( pixel_x > snake_posX[j] ) && (pixel_x < snake_posX[j]  + 20) && ( pixel_y > snake_posY[j] ) && ( pixel_y < snake_posY[j] + 16));
	end
end

// ? by
always @(posedge vga_clk) begin
    bound_region = 0;
				
    if(cross_border_x== 0 && cross_border_y == 0) begin
        bound_region = (pixel_x >= left_bound) && (pixel_x <= right_bound) && (pixel_y >= top_bound) && (pixel_y <= bottom_bound);
    end
    else if (cross_border_x > 0 && cross_border_y == 0)begin
        bound_region = ((pixel_x <= left_bound) || (pixel_x >= right_bound)) && (pixel_y >= top_bound) && (pixel_y <= bottom_bound);
    end
    else if (cross_border_x== 0 && cross_border_y > 0)begin
        bound_region = (pixel_x >= left_bound) && (pixel_x <= right_bound) && ((pixel_y <= top_bound) || (pixel_y >= bottom_bound));
    end
    else if (cross_border_x > 0 && cross_border_y > 0)begin
        bound_region = ((pixel_x <= left_bound) || (pixel_x >= right_bound)) && ((pixel_y <= top_bound) || (pixel_y >= bottom_bound));
    end
end




endmodule