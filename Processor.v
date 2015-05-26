module Processor(input clk, reset);
	wire z, ir_write, B_write, pc_src, pc_write, mem_src, mem_write, stack_src, tos, push, pop;
	wire [2:0] inst_op;
	
	Controller cntrl(clk, reset,  z, inst_op, ir_write, B_write, pc_src, pc_write, mem_src, mem_write, stack_src, tos, push, pop);
	DataPath dp( clk, reset, ir_write, B_write, pc_src, pc_write, mem_src, mem_write, stack_src, tos, push, pop,   z, inst_op);
endmodule

module test_processor();
	reg clk = 1'b0, reset = 1'b1;
	Processor prc(clk, reset);
	initial repeat(1000) #5 clk = ~clk;
	initial begin
		#6 reset = 1'b0;
		#500 $stop;
	end
endmodule
