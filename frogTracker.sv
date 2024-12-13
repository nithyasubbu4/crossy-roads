//Tracks the position of the green(frog) LED and takes in the user input to move the frog
module frogTracker (clk, reset, Right, Up, Down, Left, GrnPixels, frog_pos, row_count, col_count);
	output logic [7:0] frog_pos;
	output logic [3:0] row_count, col_count;
	output logic [15:0][15:0] GrnPixels;
	input logic clk, reset; //, CLOCK_50;
	input logic Right, Up, Down, Left;
		
	assign frog_pos = (16 * row_count) + col_count;
	
	
	always_ff @(posedge clk or posedge reset) begin
		
		if(reset) begin
			row_count <= 4'b1111; //15
			col_count <= 4'b0110; //6
				
		end 
		
		else begin
			if (Right && col_count > 0) 
				col_count <= col_count - 1;
			
			else if(Up && row_count > 0)
				row_count <= row_count - 1;
			
			else if(Down && row_count < 15) 
				row_count <= row_count + 1;
			
			else if(Left && col_count < 15)
				col_count <= col_count + 1;
			
		end
	end
	
	always_comb begin
		
		GrnPixels = '0; // Clear all green pixels

		GrnPixels[row_count][col_count] = 1'b1;  // Light up only current frog position

	end
endmodule

module frogTracker_testbench();
	logic [7:0] frog_pos;
	logic [3:0] row_count, col_count;
	logic [15:0][15:0] GrnPixels;
	logic clk, reset, CLOCK_50;
	logic Right, Up, Down, Left;
	
	frogTracker dut (.clk(CLOCK_50), .reset, .Right, .Up, .Down, .Left, .frog_pos, .Right, .Up, .Down, .Left);
	
	initial begin
		CLOCK_50 <= 0;
		forever #(100 / 2)
		CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
	
			reset = 1;														@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
			reset = 0;														@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		Right <= 0; Left <= 0; Up <= 0; Down <= 0;				@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		
		Right <= 1;						@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Right <= 0;						@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Right <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		Right <= 0; 						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		Up <= 1;							@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Up <= 0;							@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		Up <= 1;								@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		Up <= 0;							@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Down <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		Down <= 0;							@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		Down <= 1;						@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Down <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		Left <= 1; 							@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		Left <= 0; 						@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Left <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		Left <= 0;							@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		Right <= 0;						@(posedge CLOCK_50);
											@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		
		reset <= 1;    					@(posedge CLOCK_50); //reset test again
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		reset <= 0;    				@(posedge CLOCK_50); //reset test again
											@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		
		Right <= 1;		            	@(posedge CLOCK_50);
												@(posedge CLOCK_50);
	   Right <= 0;	               	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Up <= 1;		            	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Up <= 0;		            		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
	   Left <= 1;		            	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Left <= 0;		            @(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Down <= 0;		            	@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		Down <= 1;		            	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
	   Right <= 0;		            @(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Right <= 1;		            	@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		Left <= 0;		            	@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Left <= 1;		            @(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Up <= 1;		            		@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		Up <= 0;		            		@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Down <= 0;		            @(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Down <= 1;		            	@(posedge CLOCK_50);
											   @(posedge CLOCK_50);
		Left <= 1;							@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Left <= 0;						@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		
		reset <= 1;							@(posedge CLOCK_50); //reset to try illegal
												@(posedge CLOCK_50);
		reset <= 0;							@(posedge CLOCK_50);
												@(posedge CLOCK_50); //Left illegal
		Left <= 1;						@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		Left <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		Down <= 1;							@(posedge CLOCK_50);
												@(posedge CLOCK_50); //Down illegal
		Down <= 0; 						@(posedge CLOCK_50);
											@(posedge CLOCK_50);
											@(posedge CLOCK_50);
		$stop;
	end
endmodule	