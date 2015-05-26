module DataPath(input clk, reset, ir_write, B_write, pc_src, pc_write, mem_src, mem_write, stack_src, tos, push, pop, output reg  z, output [2:0] inst_op);

	//pc & inst Memory
	reg  [4:0] pc, next_pc;
	reg  [7:0] IR, B_reg;
	assign inst_op = IR[7:5];
	
	//data memory
	reg  [4:0] 	mem_addr;
	reg  [7:0] mem_write_data;
	wire [7:0] mem_out_data;
	
	//stack
	reg  [7:0] stack_in;
	wire [7:0] stack_out;
	
	//ALU
	reg [7:0] alu_A, alu_B;
	wire [7:0] alu_out;
	reg  [7:0] alu_reg;
	
	//Modules
	DataMem data_mem (clk, mem_write, mem_addr , mem_write_data, mem_out_data);
	Stack 	stack(clk, tos, push,pop, stack_in, stack_out);
	ALU 	alu(inst_op , alu_A, alu_B, alu_out); 
	
	

	always @(*) begin //calculate the new pc
		//PC
		case(pc_src)
			1'b0: next_pc <= IR[4:0];
			1'b1: next_pc <= pc + 1;
		endcase
		
		//Stack
		case(stack_src)
			1'b0: stack_in <= mem_out_data;
			1'b1: stack_in <= alu_reg;
		endcase
		//z
		if(stack_out == 8'b0)
			z = 1'b1;
		else z = 1'b0;
		//ALU
		alu_A <= stack_out;
		alu_B <= B_reg;
		
		
		//Data Memory
		case(mem_src)
			1'b0: mem_addr <= IR[4:0];
			1'b1: mem_addr <= pc;
		endcase
		mem_write_data <= stack_out;
	end
	
	always @(posedge clk)begin //set new values to registers
		if(reset == 1'b0)
		begin
			if(pc_write)
				pc = next_pc;
			if(ir_write)
				IR <= mem_out_data;
			B_reg <= stack_out;
			alu_reg <= alu_out;
		end
		else begin
			{pc,IR, B_reg} = 0;
			alu_reg = 8'b0;
		end
	end
endmodule