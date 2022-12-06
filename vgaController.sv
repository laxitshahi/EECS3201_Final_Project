module vgaController(CLOCK_50, VGA_HS, VGA_VS, VGA_R, VGA_G, VGA_B, KEY, SW, LEDR);
	input CLOCK_50;
	input [1:0] KEY;
	input [9:0] SW;
	output reg [3:0] VGA_R, VGA_G, VGA_B;
	output reg VGA_HS, VGA_VS;
	output [9:0] LEDR;
	
	wire hsync, vsync;
	wire activeDisplayRegion;
	wire [15:0] column, row;
	wire [2:0] toggleLife;
	integer toggle = 0;
	integer life = 3;
	integer stop = 0;
	
	// if we get rid of slowclock, we can just run at 72MHz. 
	// No clean way of getting ANY of the lower freq signals without using a PLL.
	// By instantiating this, we "plug it in" and it handles the frame refresh. 
	hvsync vgaSynchro(
								.clk(CLOCK_50),
								.reset_n(KEY[0]),
								.hsync(hsync),
								.vsync(vsync),
								.column(column),
								.row(row),
								.activeDisplayRegion(activeDisplayRegion)
						   );
				
	
clockdiv clock (
	.clk(CLOCK_50),
	.slow_clock(clkout),
	.slow_life(clklife)
	);			
		
		integer count, countee = 0;
	always@(posedge clklife) begin
		if(KEY[0] == 0 && life < 1) life = 3;
		if(toggle == 1) life = life - 1;
		case(life) 
				3: LEDR[6:4] = 3'b111;
				2: LEDR[6:4] = 3'b011;
				1: LEDR[6:4] = 3'b001;
				default: LEDR[6:4] = 3'b000;
			
			endcase
	end
	
	always@(posedge clkout) 
	begin
	if(stop == 0)begin
	if(SW[9]) 
	begin
		countee = countee - 2;
	end else begin
		countee = countee;
	end
	
	if(SW[0]) begin
		countee = countee + 2;
	end else begin
		countee = countee;
	end
	
	if(countee == 800)begin
		countee = 0;
	end else if(countee == -50) begin
		countee=300;
	end
	
	end else countee = 600;
	
	if(life <= 0) stop = 1;
	
	if(count == 600) begin
		count = -50;
	end
	else begin
		count = count + 5;
	end
	
	//reset
	if(KEY[0] == 0 && stop == 1) begin
	stop = 0;
	end
end					
						
	// demo, remove this entire block and replace with drawing module			
	always @(posedge CLOCK_50)
	begin
	
			if (activeDisplayRegion == 1)
			begin	//background
					VGA_R <= 4'b1111;
					VGA_G <= 4'b1011;
					VGA_B <= 4'b0101;
					// wall
				if (column > 375 && column < 801 && row > 0 && row < 600) 
				begin
					VGA_R <= 4'b1111;
					VGA_G <= 4'b0111;
					VGA_B <= 4'b0000;
				end	
					
					// bullets
				if (column > 100 && column < 120 && row > (0 + count - 170) && row < (20 + count - 170)) // box 3
				begin
					VGA_R <= 4'b1000;
					VGA_G <= 4'b1011;
					VGA_B <= 4'b0111;
				end
				else if (column > 130 && column < 150 && row > (0 + count - 100) && row < (20 + count - 100)) // box 4
				begin
					VGA_R <= 4'b1000;
					VGA_G <= 4'b1011;
					VGA_B <= 4'b0111;
				end
				else if (column > 200 && column < 250 && row > (0 + count + 2) && row < (20 + count + 2)) //large box5
				begin
					VGA_R <= 4'b0000;
					VGA_G <= 4'b1111;
					VGA_B <= 4'b0000;
				end
				else if (column > 60 && column < 80 && row > (0 + count - 150) && row < (20 + count - 150)) //box 2
				begin
					VGA_R <= 4'b1000;
					VGA_G <= 4'b1011;
					VGA_B <= 4'b0111;
				end
				else if (column > 20 && column < 40 && row > (0 + count - 50) && row < (20 + count - 50)) //box 1
				begin
					VGA_R <= 4'b1000;
					VGA_G <= 4'b1011;
					VGA_B <= 4'b0111;
				end
				
				// ship
				else if(column > (0 + 2+countee) && column < (20 + 2+countee) && row > 440 && row < 460) begin
					VGA_R <= 4'b0001;
					VGA_G <= 4'b1011;
					VGA_B <= 4'b1111;
					// check if collision
					 if (0 + 2+countee > 185 && 20 + 2+countee < 265 &&  425 < (0 + count + 2) && 475 > (20 + count + 2)) begin
					 LEDR[0] = 1'b1;
					 toggle = 1;
					 end
					 
					 //box 1
					 else if(0 + 2+countee > 5 && 0 + 2+countee < 55 && 425 < (0 + count - 50) && 475 > (20 + count - 50)) begin
					  LEDR[0] = 1'b1;
					  toggle = 1;
					 end
					 
					  //box 2
					 else if(0 + 2+countee > 45 && 0 + 2+countee < 95 && 425 < (0 + count - 150) && 475 > (20 + count - 150)) begin
					  LEDR[0] = 1'b1;
					  toggle = 1;
					 end
					 
					 //box 3
					 else if(0 + 2+countee > 85 && 0 + 2+countee < 135 && 425 < (0 + count - 150) && 475 > (20 + count - 150)) begin
					  LEDR[0] = 1'b1;
					  toggle = 1;
					 end
					 
					 //box 4
					 else if(0 + 2+countee > 115 && 0 + 2+countee < 165 && 425 < (0 + count - 100) && 475 > (20 + count - 100)) begin
					  LEDR[0] = 1'b1;
					  toggle = 1;
					 end
					 
					 else begin
					 LEDR[0] = 1'b0;
					 toggle = 0;
					 end
				end

				

			end
			else if (activeDisplayRegion != 1)
			begin
				VGA_R = 4'b0000; 
				VGA_G = 4'b0000; 
				VGA_B = 4'b0000;	// change to black background otherwise
			end
		VGA_HS <= hsync;
		VGA_VS <= vsync;
	end
	
endmodule