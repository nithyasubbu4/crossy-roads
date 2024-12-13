module userInput(clk, reset, button, out);
	output logic out;
	input logic clk, reset;
	input logic button;

	enum {on, off} ps, ns;
	
	always_comb begin 
		case(ps)
			on: if(button) ns = on;
			
		       else ns = off;
				 
			off: if(button) ns = on;
				  
				  else ns = off;
		endcase
		
	end
	
	assign out = (ps == on & ns == off);
	
	always_ff @(posedge clk) begin
		if(reset)
			ps <= off;
		
		else
			ps <= ns;
		
	end
endmodule

module userInput_testbench();
	logic clk, reset;
	logic button;
	logic out;
	
	userInput dut(.out, .clk, .reset, .button);
	
	
	initial begin
		clk <= 0;
		forever #(50)
		clk <= ~clk;
	end
	
	initial begin
		reset <= 1;			@(posedge clk);
								@(posedge clk);
		
		reset <= 0;       @(posedge clk);
								@(posedge clk);

		
		button <= 1;		@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								
		
		button <=0; 		@(posedge clk);
								@(posedge clk);
								@(posedge clk);

		button <= 1;		@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								
		
		button <=0; 		@(posedge clk);
								@(posedge clk);
								@(posedge clk);

		button <= 1;		@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								
		
		button <=0; 		@(posedge clk);
								@(posedge clk);
								@(posedge clk);

		button <= 1;		@(posedge clk);
								@(posedge clk);
								@(posedge clk);
								
		
		button <=0; 		@(posedge clk);
								@(posedge clk);
								@(posedge clk);

		button <= 1;		@(posedge clk);
								@(posedge clk);
								@(posedge clk);
		$stop;
		
		end
	endmodule
		
		
		
	
	
	