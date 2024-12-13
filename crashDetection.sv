//Detetcs if the player crashes into a car and resets the game if the crash is detected
module crashDetection(GreenPixels, RedPixels, crashCheck, frog_row, frog_col, clk);
	input logic [15:0][15:0] GreenPixels, RedPixels;
	output logic crashCheck;
	input logic [3:0] frog_row, frog_col;
	input logic clk;
	
	always_ff @(posedge clk) begin
		if (RedPixels[frog_row][frog_col] & GreenPixels[frog_row][frog_col]) begin
        crashCheck <= 1'b1;
		end else begin
        crashCheck <= 1'b0;
		end
	end
endmodule
		


module crashDetection_testbench();
	logic [15:0][15:0] GreenPixels, RedPixels;
	logic crashCheck;
	logic CLOCK_50;
	logic [3:0] frog_row, frog_col;

	crashDetection dut (.GreenPixels, .RedPixels, .crashCheck, .CLOCK_50(CLOCK_50), .frog_row, .frog_col);
	
	initial begin
		CLOCK_50 <= 0;
		forever #(100 / 2)
		CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
																																@(posedge CLOCK_50);
																																@(posedge CLOCK_50);
		frog_row <= 4'b0111; frog_col <= 4'b0010; RedPixels[frog_row][frog_col]<= 1;					@(posedge CLOCK_50); //no crash
																																@(posedge CLOCK_50);
																																@(posedge CLOCK_50);
		GreenPixels <= 0; RedPixels <= 0; 									@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		GreenPixels[7][2] <= 1; RedPixels[7][2] <= 1; 					@(posedge CLOCK_50); //crash
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		/*check reset true*/													@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		GreenPixels[5][3] <= 1; RedPixels[5][3] <= 1; 					@(posedge CLOCK_50); //crash
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		$stop;
	end
endmodule
	
		
