module dFlipFlop (clk, reset, button, out);
	input logic clk;
	input logic reset;
	input logic button;
	output logic out;
	
	logic double_out;
	
		always_ff @(posedge clk) begin 
			double_out <= button;
			
		end
		
		always_ff @(posedge clk) begin 
			out <= double_out;
			
		end
		
	endmodule
