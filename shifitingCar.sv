module shiftingCar (clk, reset, enable, carPattern, outShift);
	output logic [15:0] outShift;
	input logic clk, reset;//, CLOCK_50;
	input logic enable;
	input logic [15:0] carPattern;
	
	always_ff @(posedge clk) begin
		if(reset) outShift <= carPattern;
		else if (enable) outShift <= {outShift[0], outShift[15:1]};
	end
endmodule
			

module shiftingCar_testbench();
	logic [15:0] outShift;
	logic clk, reset, CLOCK_50;
	logic enable;
	logic [15:0] carPattern;
	
	shiftingCar dut(.clk(CLOCK_50), .reset, .enable, .carPattern, .outShift);
	
	initial begin
		CLOCK_50 <= 0;
		forever #(100 / 2)
		CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
		reset <= 1;																	@(posedge CLOCK_50); //nothing should happen as reset is 1
																						@(posedge CLOCK_50);
		carPattern <= 16'b0000000000000000;									@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
		carPattern <= 16'b0001001100011000;									@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
		reset <= 0;																	@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
		carPattern <= 16'b000000000000010; enable = 0;					@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
		carPattern <= 16'b0001001100011000;	enable = 0;					@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
		carPattern <= 16'b000000000000010; enable = 1;					@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
		carPattern <= 16'b0001001100011000;	enable = 1;					@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
		reset <= 1;																	@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
		reset <= 0;																	@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);
																						@(posedge CLOCK_50);

		$stop;
	end
endmodule 