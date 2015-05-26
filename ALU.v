module ALU (input [2:0] fn, input [7:0] op_A, op_B, output reg [7:0] out); 

	always@(*)begin
		out = 8'b0;
		case (fn) 
			3'b000 : out = op_A + op_B;
			3'b001 : out = op_A - op_B;
			3'b010 : out = op_A & op_B;
			3'b011 : out = ~op_A ;
		endcase
	end

endmodule