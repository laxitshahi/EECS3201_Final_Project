module clockdiv(input clk, RST, output logic slow_clock,output logic slow_life);
	logic [27:0] counter;
	logic [27:0] counter2;
	parameter xx=28'd833_333;
	parameter life = 28'd5_249_999;
	
	always @ (posedge clk)
			begin
				counter<=counter+1;
				counter2<=counter2+1;
				if(counter >= xx)
					begin
						counter <= 28'b0;
						slow_clock<=~slow_clock;
					end
					
				if(counter2 >= life)
					begin
						counter2<=28'b0;
						slow_life<=~slow_life;
					end
			end

endmodule