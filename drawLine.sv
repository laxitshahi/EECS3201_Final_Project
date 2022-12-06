module drawLine(KEY, clk, VGA_HS, xcount, ycount, VGA_HS, VGA_VS);

// input are dip switches for now: they determine what lines are drawn: 2 min, 10-12 max.
input [9:0] KEY;
input wire clk;	// use CLOCK_50
input wire VGA_HS, VGA_VS;
input wire [15:0] xcount, ycount; //
reg [3:0] VGA_R, VGA_G, VGA_B;
// states

// set up position variables
// set up each "head" that will move across the screen. (Set up multiple heads to account fo multiple line objects?)
reg [15:0] head_x1 = 0;
reg [15:0] head_x2 = 0;
reg [15:0] head_x3 = 0;

reg [15:0] start_y1;	assign start_y1 = 200;
reg [15:0] start_y2;	assign start_y2 = 400;
reg [15:0] start_y3;	assign start_y3 = 600;

always @(posedge clk)
begin
// line draw logic
// draw 25x25 square at coordinates y = 100,300 and 500.

// first, focus on x = 100
		if ((xcount > head_x1 && xcount < (head_x1 + 25)) && (ycount > start_y1 && ycount < (start_y1 + 25)))
		begin 
			// draw green
				VGA_R <= 4'b0000;
				VGA_G <= 4'b1111;
				VGA_B <= 4'b0000;	
			end
			head_x1 = head_x1 + 1; // shift the position of the drawing head to move the square.		
end



endmodule