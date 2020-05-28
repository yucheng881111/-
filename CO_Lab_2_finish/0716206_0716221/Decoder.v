// Author: 0716206 陳昱丞, 0716221 余忠旻

module Decoder(
    instr_op_i,
    RegWrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    Branch_o,
    zero_extend,
    lui_ctrl,
    sltiu_ctrl,
    shamp_i,
    shamp_o
    );

//I/O ports
input  [6-1:0] instr_op_i;
input  [5-1:0] shamp_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;

output         sltiu_ctrl;
output         lui_ctrl;
output         zero_extend;
output  [5-1:0] shamp_o;

//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg            zero_extend;
reg            lui_ctrl;
reg         sltiu_ctrl;
reg    [5-1:0] shamp_o;

always @(*) begin
	if(instr_op_i==6'b000000)begin   //R-types
		RegDst_o = 1'b1;
		Branch_o = 1'b0;
		ALUSrc_o = 1'b0;
		RegWrite_o = 1'b1;
		zero_extend = 1'b0;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 3'b000;
		shamp_o = shamp_i;
	end else if(instr_op_i==6'b001000)begin  //addi
		RegDst_o = 1'b0;
		Branch_o = 1'b0;
		ALUSrc_o = 1'b1;
		RegWrite_o = 1'b1;
		zero_extend = 1'b0;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 3'b001;
		shamp_o = 5'b00000;
	end else if(instr_op_i==6'b000100)begin  //beq
		RegDst_o = 1'b0;
		Branch_o = 1'b1;
		ALUSrc_o = 1'b0;
		RegWrite_o = 1'b0;
		zero_extend = 1'b0;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 3'b010;
		shamp_o = 5'b00000;
	end else if(instr_op_i==6'b000101)begin  //bne
		RegDst_o = 1'b0;
		Branch_o = 1'b1;
		ALUSrc_o = 1'b0;
		RegWrite_o = 1'b0;
		zero_extend = 1'b0;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 3'b011;
		shamp_o = 5'b00000;
	end else if(instr_op_i==6'b001111)begin  //lui
		RegDst_o = 1'b0;
		Branch_o = 1'b0;
		ALUSrc_o = 1'b1;
		RegWrite_o = 1'b1;
		zero_extend = 1'b0;
		lui_ctrl = 1'b1;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 3'b100;
		shamp_o = 5'b00000;
	end else if(instr_op_i==6'b001101)begin  //ori
		RegDst_o = 1'b0;
		Branch_o = 1'b0;
		ALUSrc_o = 1'b1;
		RegWrite_o = 1'b1;
		zero_extend = 1'b1;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 3'b101;
		shamp_o = 5'b00000;
	end else if(instr_op_i==6'b001011)begin  //sltiu
		RegDst_o = 1'b0;
		Branch_o = 1'b0;
		ALUSrc_o = 1'b1;
		RegWrite_o = 1'b1;
		zero_extend = 1'b1;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b1;
		ALU_op_o = 3'b110;
		shamp_o = 5'b00000;
	end
end




endmodule
