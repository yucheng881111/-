// Author: 0716206 陳昱丞, 0716221 余忠旻

module ALU_Ctrl(
        funct_i,
        ALUOp_i,
        ALUCtrl_o
        );

//I/O ports
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;

//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Select exact operation
always @(*) begin
	if(ALUOp_i==3'b001)begin           //addi
			ALUCtrl_o=4'b0010;
	end else if(ALUOp_i==3'b010)begin  //beq
			ALUCtrl_o=4'b0110;
	end else if(ALUOp_i==3'b011)begin  //bne
			ALUCtrl_o=4'b0110;
	end else if(ALUOp_i==3'b100)begin  //lui
			ALUCtrl_o=4'b1111;
	end else if(ALUOp_i==3'b101)begin  //ori
			ALUCtrl_o=4'b0001;
	end else if(ALUOp_i==3'b110)begin  //sltiu
			ALUCtrl_o=4'b0111;
	end else if(ALUOp_i==3'b000 && funct_i==6'b100001)begin  //addu
			ALUCtrl_o=4'b0010;
	end else if(ALUOp_i==3'b000 && funct_i==6'b100100)begin  //and
			ALUCtrl_o=4'b0000;
	end else if(ALUOp_i==3'b000 && funct_i==6'b000111)begin  //srav
			ALUCtrl_o=4'b1111;
	end else if(ALUOp_i==3'b000 && funct_i==6'b100101)begin  //or
			ALUCtrl_o=4'b0001;
	end else if(ALUOp_i==3'b000 && funct_i==6'b101010)begin  //slt
			ALUCtrl_o=4'b0111;
	end else if(ALUOp_i==3'b000 && funct_i==6'b000011)begin  //sra
			ALUCtrl_o=4'b1111;
	end else if(ALUOp_i==3'b000 && funct_i==6'b100011)begin  //subu
			ALUCtrl_o=4'b0110;
	end
end


endmodule
