module hvsync(clk, hsync, vsync, activeDisplayRegion, column, row, reset_n);
//800x600 lab monitors => ~40MHz at 60fps
	input wire clk;	// call the slowclock and pipe to here
	input reset_n;
	output hsync, vsync;	// pass this synchronization signal to the controller output
	output reg activeDisplayRegion;	
	output reg [15:0] column, row;
	
	reg vga_hsync_active, vga_vsync_active = 0;
		
	wire x_end = (column == 1056); // 800 visible + 40 frontporch + 128 sync pulse + 88 backporch
	wire y_end = (row == 628);// 600 visible + 1 frontporch + 4 sync pulse + 23 backporch
		
	// horizontal(line) counter
	always @(posedge clk)
	begin
		
			if (x_end == 1) column = 0;			// if we reach the active + sync, reset.
			else column = column + 1;			// increment through active if we haven't 
	
	//vertical(frame) counter

			if (x_end == 1) 
			begin 
				if (y_end == 1) row = 0;	
				else row = row + 1;
			end

			vga_hsync_active = (column > (800 + 40) && column < (800 + 40 + 128));	// if true, we are in sync pulse region
			vga_vsync_active = (row > (600 + 1) && row < (600 + 1 + 4));		

			if (column < 800 && row < 600) activeDisplayRegion = 1'b1;// if true, we are in visible region
			else activeDisplayRegion = 1'b0;
	end
	
	assign hsync = ~vga_hsync_active;
	assign vsync = ~vga_vsync_active;
	
endmodule