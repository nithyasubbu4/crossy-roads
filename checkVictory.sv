//If a player sucessfully reaches the other side of the LED board they are awarded a win
module checkVictory(clk, GreenPixels, victory, frog_row);
    input logic [15:0][15:0] GreenPixels; 
	 input logic [3:0] frog_row;
	 input logic clk;
    output logic victory;
	 
	 
	always_ff @(posedge clk) begin
		if (frog_row == 0) begin
        victory <= 1'b1;
		end else begin
        victory <= 1'b0;
		end
	end 
endmodule
