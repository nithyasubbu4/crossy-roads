//Displays a message based on the status of the players game(crash, victory, game-in-play)
module messageDisplay (clk, reset, crashCheck, victory, enable, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input logic clk;
	input logic reset;
   input logic crashCheck;
	input logic victory;
	input logic enable;
   output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	
	enum {IDLE, MESSAGE} ps, ns;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            ps <= IDLE;
        else
            ps <= ns;
    end


    always_comb begin
        ns = ps;

        case (ps)
            IDLE: begin
                if (crashCheck || victory)
                    ns = MESSAGE;
            end
            
				MESSAGE: begin
                if (enable) // Move to IDLE after delay
                    ns = IDLE;
            end
        endcase
    end

    // Output Logic
    always_comb begin
        HEX0 = 7'b1111111;
        HEX1 = 7'b1111111;
        HEX2 = 7'b1111111;
        HEX3 = 7'b1111111;
        HEX4 = 7'b1111111;
        HEX5 = 7'b1111111;

        if (ps == MESSAGE) begin
            if (crashCheck) begin
                HEX0 = 7'b0111110; // C
                HEX1 = 7'b0111001; // R
                HEX2 = 7'b0001000; // A
                HEX3 = 7'b0100100; // S
                HEX4 = 7'b1001000; // H
            
				end else if (victory) begin
                HEX0 = 7'b0111111; // V
                HEX1 = 7'b0001000; // I
                HEX2 = 7'b1000111; // C
                HEX3 = 7'b0000110; // T
                HEX4 = 7'b0111111; // O
                HEX5 = 7'b1000111; // R
            end
        end
    end
endmodule
