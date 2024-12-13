//Slows down the clock to ensure cars(Red LED) are moving slower than the frog(Green LED)
module counter (clk, reset, enable);
	input logic clk, reset; //reset?
	output logic enable; 

	`ifdef ALTERA_RESERVED_QIS
		logic [9:0] counter; // for board
	`else
		logic counter; // for simulation
	`endif
	
	always_ff @(posedge clk) begin
		if (reset) counter <= 0;
		else counter <= counter + 1'b1;
	end
	
	assign enable = (counter == '1);
endmodule

