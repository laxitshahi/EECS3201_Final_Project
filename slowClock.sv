module clockdiv(slow_clock, CLOCK_50);
// may be better to call this module clockdiv, to avoid using the words slowClock and slow_clock

	//input is the given clock module, output is the slower clock.
	input CLOCK_50;
	output reg slow_clock;
	reg [31:0] counter;	// make it 32 bits wide in case of overflow
	
	parameter maxTime = 32'd6108864; // 2^26. 

	always @(posedge CLOCK_50)
	begin
			counter = counter+1;
			if (counter >= maxTime)
			begin
				counter <= 32'd0;
				slow_clock <= ~slow_clock;
			end
	end
	
endmodule