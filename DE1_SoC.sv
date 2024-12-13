// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic [9:0]  LEDR;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
    output logic [35:0] GPIO_1;
    input logic CLOCK_50;
	 
	logic key0_dFlip, key1_dFlip, key2_dFlip, key3_dFlip;

	logic KEY0, KEY1, KEY2, KEY3;
	
	logic reset, enable;
	logic [3:0] curr_row, curr_col;
	 
	 
	 /* Set up system base clock to 1526 Hz (50 MHz / 2**(14+1))
	    ===========================================================*/
	 logic [31:0] clk;
	 logic SYSTEM_CLOCK;
	 
	 clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
	 
	 `ifdef ALTERA_RESERVED_QIS
		assign SYSTEM_CLOCK = clk[14]; // 1526 Hz clock signal
	 `else
		assign SYSTEM_CLOCK = CLOCK_50; //for simulation
	 `endif
	 
	 /* If you notice flickering, set SYSTEM_CLOCK faster.
	    However, this may reduce the brightness of the LED board. */
	
	 
	 /* Set up LED board driver
	    ================================================================== */
	 logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs
    logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs
	 logic RST;                   // reset - toggle this on startup
	 logic [7:0] frog_pos;
	 
	 	 
	 logic crashCheck;
	 logic victory;
	 
	    always_comb begin

        HEX0 = 7'b1111111; // Default: segments off
        HEX1 = 7'b1111111;
        HEX2 = 7'b1111111;
        HEX3 = 7'b1111111;
        HEX4 = 7'b1111111;
		  HEX5 = 7'b1111111;


        if (crashCheck) begin
            // Crash detected
            //crashCheck = 1;
            HEX0 = 7'b0111110; // C
            HEX1 = 7'b0111001; // R
            HEX2 = 7'b0001000; // A
            HEX3 = 7'b0100100; // S
            HEX4 = 7'b1001000; // H
				HEX5 = 7'b1111111;

        end else if (victory) begin
            // Victory detected
            //victory = 1;
				HEX0 = 7'b0111111; //  "V"
				HEX1 = 7'b0001000; //  "I"
				HEX2 = 7'b1000111; //  "C"
				HEX3 = 7'b0000110; //  "T"
				HEX4 = 7'b0111111; //  "O"
				HEX5 = 7'b1000111; //  "R"

        end
    end
	 
	 assign LEDR[1] = crashCheck;
	 assign LEDR[4] = victory;
	 
	 assign RST = SW[9] | victory | crashCheck; //CHANGED from key0 since its being used

	 /* Standard LED Driver instantiation - set once and 'forget it'. 
	    See LEDDriver.sv for more info. Do not modify unless you know what you are doing! */
	 LEDDriver Driver (.CLK(SYSTEM_CLOCK), .RST, .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);
	 
	 
	 /* LED board test submodule - paints the board with a static pattern.
	    Replace with your own code driving RedPixels and GrnPixels.
		 
	 	 KEY0      : Reset
		 =================================================================== */
	// LED_test test (.RST(~KEY[0]), .RedPixels, .GrnPixels);
	 
	
	dFlipFlop key0_F1 (.clk(SYSTEM_CLOCK), .reset(RST), .button(~KEY[0]), .out(key0_dFlip));
	dFlipFlop key1_F1 (.clk(SYSTEM_CLOCK), .reset(RST), .button(~KEY[1]), .out(key1_dFlip));
	dFlipFlop key2_F1 (.clk(SYSTEM_CLOCK), .reset(RST), .button(~KEY[2]), .out(key2_dFlip));
	dFlipFlop key3_F1 (.clk(SYSTEM_CLOCK), .reset(RST), .button(~KEY[3]), .out(key3_dFlip));
	
	userInput input_zero (.clk(SYSTEM_CLOCK), .reset(RST), .button(key0_dFlip), .out(KEY0));
	userInput input_one (.clk(SYSTEM_CLOCK), .reset(RST), .button(key1_dFlip), .out(KEY1));
	userInput input_two (.clk(SYSTEM_CLOCK), .reset(RST), .button(key2_dFlip), .out(KEY2));
	userInput input_three (.clk(SYSTEM_CLOCK), .reset(RST), .button(key3_dFlip), .out(KEY3));
	
	counter c1 (.clk(SYSTEM_CLOCK), .reset(RST), .enable);
	
	//controls the pattern of the cars
	shiftingCar row01 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b0000000000000000), .outShift(RedPixels[00]));
	shiftingCar row02 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b1100001100000110), .outShift(RedPixels[01]));
	shiftingCar row03 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b0001000000011000), .outShift(RedPixels[02]));
	shiftingCar row04 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b1111000000000000), .outShift(RedPixels[03]));
	shiftingCar row05 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b0000000000011001), .outShift(RedPixels[04]));
	shiftingCar row06 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b0000001110000000), .outShift(RedPixels[05]));
	shiftingCar row07 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b1100000000000110), .outShift(RedPixels[06]));
	shiftingCar row08 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b0000110001100000), .outShift(RedPixels[07]));
	shiftingCar row09 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b0000000000000000), .outShift(RedPixels[08]));
	shiftingCar row10 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b1000001000100000), .outShift(RedPixels[09]));
	shiftingCar row11 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b0001100000000110), .outShift(RedPixels[10]));
	shiftingCar row12 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b0000000111000000), .outShift(RedPixels[11]));
	shiftingCar row13 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b0001100000000000), .outShift(RedPixels[12]));
	shiftingCar row14 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b0000000000011100), .outShift(RedPixels[13]));
	shiftingCar row15 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b0011110000000000), .outShift(RedPixels[14]));
	shiftingCar row16 (.clk(SYSTEM_CLOCK), .reset(RST), .enable(enable) , .carPattern(16'b0000000000000000), .outShift(RedPixels[15]));
	
	frogTracker frog_position (.clk(SYSTEM_CLOCK), .reset(RST), .Right(KEY0), .Up(KEY1), .Down(KEY2), .Left(KEY3), .GrnPixels(GrnPixels), .frog_pos(frog_pos), .row_count(curr_row), .col_count(curr_col));	
	
	crashDetection checkCrash (.GreenPixels(GrnPixels), .RedPixels(RedPixels), .crashCheck(crashCheck), .frog_row(curr_row), .frog_col(curr_col), .clk(SYSTEM_CLOCK));
	checkVictory getVictory (.clk(SYSTEM_CLOCK), .GreenPixels(GrnPixels), .victory(victory), .frog_row(curr_row));
	messageDisplay getMessage (.clk(SYSTEM_CLOCK), .reset(RST), .crashCheck(crashCheck), .victory(victory), .enable(enable), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));

endmodule

//Testbench for the DE1_SoC

module DE1_SoC_testbench();
	logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic [35:0] GPIO_1;
	
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .SW, .LEDR, .GPIO_1, .CLOCK_50);
	
	initial begin
		CLOCK_50 <= 0;
		forever #(100 / 2)
		CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
																					@(posedge CLOCK_50);
		/*check reset true*/													@(posedge CLOCK_50);
		SW[9] <= 1;																@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		/*check reset false*/												@(posedge CLOCK_50);
		SW[9] <= 0;																@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		KEY[0] <= 0; KEY[3] <= 0; KEY[1] <= 0; KEY[2] <= 0;		@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		KEY[1] <= 1;															@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		KEY[1] <= 0;															@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		KEY[1] <= 1;															@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		KEY[1] <= 0;															@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		KEY[0] <= 1;															@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		KEY[0] <= 0;															@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		KEY[0] <= 1;															@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		KEY[0] <= 0;															@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		KEY[0] <= 1;															@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		KEY[0] <= 0;															@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		KEY[3] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[3] <= 0; 						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[1] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[1] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[2] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[2] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[1] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[1] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[3] <= 1; 						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[3] <= 0; 						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[3] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[3] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		SW[9] <= 1;							@(posedge CLOCK_50); //reset test again
												@(posedge CLOCK_50);
		SW[9] <= 0;							@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;		            @(posedge CLOCK_50);
												@(posedge CLOCK_50);
	   KEY[0] <= 0;	               @(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[1] <= 1;		            @(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[1] <= 0;		            @(posedge CLOCK_50);
												@(posedge CLOCK_50);
	   KEY[3] <= 1;		            @(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[3] <= 0;		            @(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[2] <= 0;		            @(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[2] <= 1;		            @(posedge CLOCK_50);
												@(posedge CLOCK_50);
	   KEY[0] <= 0;		            @(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[0] <= 1;		            @(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[3] <= 0;		            @(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[3] <= 1;		            @(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[1] <= 0;		            @(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[1] <= 1;		            @(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[2] <= 0;		            @(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[2] <= 1;		            @(posedge CLOCK_50);
											   @(posedge CLOCK_50);
		KEY[3] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[3] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		SW[9] <= 1;							@(posedge CLOCK_50); //reset to try illegal
												@(posedge CLOCK_50);
		SW[9] <= 0;							@(posedge CLOCK_50);
												@(posedge CLOCK_50); //left illegal
		KEY[3] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[3] <= 0;						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
		KEY[2] <= 1;						@(posedge CLOCK_50);
												@(posedge CLOCK_50); //down illegal
		KEY[2] <= 0; 						@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
												@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
				/*check reset true*/											@(posedge CLOCK_50);
		SW[9] <= 1;																@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
																					@(posedge CLOCK_50);
		/*check reset false*/											@(posedge CLOCK_50);
		SW[9] <= 0;															@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);

		$stop;
	end
endmodule
	