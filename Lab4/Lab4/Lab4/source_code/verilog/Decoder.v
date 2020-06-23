// Author: 0716206 陳昱丞, 0716221 余忠旻

module Decoder(
    instr_op_i,
    RegWrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    Branch_o,
    Jump_o,
    Jal_o,
    zero_extend,
    lui_ctrl,
    sltiu_ctrl,
    shamp_i,
    shamp_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    );

//I/O ports
input  [6-1:0] instr_op_i;
input  [5-1:0] shamp_i;

output         RegWrite_o;
output [4-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output		   Jump_o;
output		   Jal_o;
output		   MemtoReg_o;
output		   MemRead_o;
output		   MemWrite_o;

output         sltiu_ctrl;
output         lui_ctrl;
output         zero_extend;
output  [5-1:0] shamp_o;

//Internal Signals
reg    [4-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg		       Jump_o;
reg            zero_extend;
reg            lui_ctrl;
reg            sltiu_ctrl;
reg    [5-1:0] shamp_o;
reg		   		MemtoReg_o;
reg		   		MemRead_o;
reg		  		MemWrite_o;
reg    		    Jal_o;



always @(*) begin
	
	if(instr_op_i==6'b000000)begin   //R-types
		RegDst_o = 1'b1;
		Branch_o = 1'b0;
		Jump_o = 1'b0;
		ALUSrc_o = 1'b0;
		RegWrite_o = 1'b1;
		zero_extend = 1'b0;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 4'b0000;
		shamp_o = shamp_i;
		Jal_o = 1'b0;
		MemtoReg_o = 1'b0;
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
	end else if(instr_op_i==6'b001000)begin  //addi
		RegDst_o = 1'b0;
		Branch_o = 1'b0;
		Jump_o = 1'b0;
		ALUSrc_o = 1'b1;
		RegWrite_o = 1'b1;
		zero_extend = 1'b0;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 4'b0001;
		shamp_o = 5'b00000;
		Jal_o = 1'b0;
		MemtoReg_o = 1'b0;
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
	end else if(instr_op_i==6'b000100)begin  //beq
		RegDst_o = 1'bx;
		Branch_o = 1'b1;
		Jump_o = 1'b0;
		ALUSrc_o = 1'b0;
		RegWrite_o = 1'b0;
		zero_extend = 1'b0;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 4'b0010;
		shamp_o = 5'b00000;
		Jal_o = 1'b0;
		MemtoReg_o = 1'bx;
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
	end else if(instr_op_i==6'b000101)begin  //bne
		RegDst_o = 1'bx;
		Branch_o = 1'b1;
		Jump_o = 1'b0;
		ALUSrc_o = 1'b0;
		RegWrite_o = 1'b0;
		zero_extend = 1'b0;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 4'b0011;
		shamp_o = 5'b00000;
		Jal_o = 1'b0;
		MemtoReg_o = 1'bx;
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
	end else if(instr_op_i==6'b001111)begin  //lui
		RegDst_o = 1'b0;
		Branch_o = 1'b0;
		Jump_o = 1'b0;
		ALUSrc_o = 1'b1;
		RegWrite_o = 1'b1;
		zero_extend = 1'b0;
		lui_ctrl = 1'b1;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 4'b0100;
		shamp_o = 5'b00000;
		Jal_o = 1'b0;
		MemtoReg_o = 1'b0;
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
	end else if(instr_op_i==6'b001101)begin  //ori
		RegDst_o = 1'b0;
		Branch_o = 1'b0;
		Jump_o = 1'b0;
		ALUSrc_o = 1'b1;
		RegWrite_o = 1'b1;
		zero_extend = 1'b1;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 4'b0101;
		shamp_o = 5'b00000;
		Jal_o = 1'b0;
		MemtoReg_o = 1'b0;
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
	end else if(instr_op_i==6'b001011)begin  //sltiu
		RegDst_o = 1'b0;
		Branch_o = 1'b0;
		Jump_o = 1'b0;
		ALUSrc_o = 1'b1;
		RegWrite_o = 1'b1;
		zero_extend = 1'b1;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b1;
		ALU_op_o = 4'b0110;
		shamp_o = 5'b00000;
		Jal_o = 1'b0;
		MemtoReg_o = 1'b0;
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
	end else if(instr_op_i==6'b000010)begin  //jump
		RegDst_o = 1'b0;
		Branch_o = 1'b0;
		Jump_o = 1'b1;
		ALUSrc_o = 1'b0;
		RegWrite_o = 1'b0;
		zero_extend = 1'b0;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 4'b0111;
		shamp_o = 5'b00000;
		Jal_o = 1'b0;
		MemtoReg_o = 1'b0;
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
	end else if(instr_op_i==6'b000011)begin  //jal
		RegDst_o = 1'b0;
		Branch_o = 1'b0;
		Jump_o = 1'b1;
		ALUSrc_o = 1'b0;
		RegWrite_o = 1'b1;
		zero_extend = 1'b0;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 4'b1000;
		shamp_o = 5'b00000;
		Jal_o = 1'b1;
		MemtoReg_o = 1'b0;
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
	end else if(instr_op_i==6'b000110)begin  //blez
		RegDst_o = 1'b0;
		Branch_o = 1'b1;
		Jump_o = 1'b0;
		ALUSrc_o = 1'b0;
		RegWrite_o = 1'b0;
		zero_extend = 1'b0;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 4'b1110;
		shamp_o = 5'b00000;
		Jal_o = 1'b0;
		MemtoReg_o = 1'b0;
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
	end else if(instr_op_i==6'b000111)begin  //bgtz
		RegDst_o = 1'b0;
		Branch_o = 1'b1;
		Jump_o = 1'b0;
		ALUSrc_o = 1'b0;
		RegWrite_o = 1'b0;
		zero_extend = 1'b0;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		ALU_op_o = 4'b1111;
		shamp_o = 5'b00000;
		Jal_o = 1'b0;
		MemtoReg_o = 1'b0;
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
	end else if(instr_op_i==6'b100011)begin  //lw
		RegDst_o = 1'b0;
		ALUSrc_o = 1'b1;
		MemtoReg_o = 1'b1;
		RegWrite_o = 1'b1;
		MemRead_o = 1'b1;
		MemWrite_o = 1'b0;
		Branch_o = 1'b0;
		ALU_op_o = 4'b1010;
		Jal_o = 1'b0;
		Jump_o = 1'b0;
		zero_extend = 1'b0;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		shamp_o = 5'b00000;
	end else if(instr_op_i==6'b101011)begin  //sw
		RegDst_o = 1'bx;
		ALUSrc_o = 1'b1;
		MemtoReg_o = 1'bx;
		RegWrite_o = 1'b0;
		MemRead_o = 1'b0;
		MemWrite_o = 1'b1;
		Branch_o = 1'b0;
		ALU_op_o = 4'b1011;		
		Jal_o = 1'b0;
		Jump_o = 1'b0;
		zero_extend = 1'b0;
		lui_ctrl = 1'b0;
		sltiu_ctrl = 1'b0;
		shamp_o = 5'b00000;
	end
end




endmodule
