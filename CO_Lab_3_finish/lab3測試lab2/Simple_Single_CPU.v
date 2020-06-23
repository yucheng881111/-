// Author: 0716206 陳昱丞, 0716221 余忠旻

module Simple_Single_CPU(
    clk_i,
    rst_i
    );

// Input port
input clk_i;
input rst_i;


wire  [32-1:0] data_o_PC;
wire  [32-1:0] data_o_PC1;
wire  [32-1:0] data_o_PCSrc;
wire [32-1:0] pc_out_o;
wire [32-1:0]  sum_o_adder1;
wire [32-1:0]  sum_o_adder2;
wire [32-1:0]  instr_o;

wire           RegWrite_i;
wire  [5-1:0]  RSaddr_i;
wire  [5-1:0]  RTaddr_i;
wire  [5-1:0]  RDaddr_i;
wire  [32-1:0] RDdata_i;

wire [32-1:0] RSdata_o;
wire [32-1:0] RTdata_o;

wire         RegWrite_o;
wire         RegWrite1;
wire [4-1:0] ALU_op_o;
wire         ALUSrc_o;
wire         RegDst_o;
wire         Branch_o;
wire         Jump_o;
wire         MemtoReg_o;
wire         MemRead_o;
wire         MemWrite_o;         

wire         lui_ctrl;
wire         sltiu_ctrl;
wire         zero_extend;
wire  [5-1:0] shamp_o;

wire  [5-1:0] data_o_Mux_Write;
wire  [5-1:0] data_o_Mux_Write2;
wire  [32-1:0] data_o_Sign_Extend;
wire  [32-1:0] data_o_Zero_Filled_Extend;
wire  [32-1:0] data_o_Extend;
wire  [32-1:0] data_o_Mux_ALUSrc;
wire [32-1:0] data_o_Shift1;
wire [32-1:0] data_o_Shift2;
wire [32-1:0] data_jump;
wire [32-1:0] data_o_jump;

wire [32-1:0] memory_output;

wire [32-1:0] memory_mux_output;
wire [32-1:0] memory_mux2_output;

wire [4-1:0]   ALUCtrl_o;
wire [32-1:0]  result_o;
wire [32-1:0]  mul_o;
wire [32-1:0]  m_or_a;

wire           zero_o;
wire           Shift_o;
wire           Jr_o;
wire           Jal_o;
wire           mul_s;
wire           RS_zero;

wire PC_select1;
wire PC_select2;
wire PC_select3;
wire PC_select4;
wire PC_select;




ProgramCounter PC(
    .clk_i(clk_i),
    .rst_i (rst_i),
    .pc_in_i(data_o_PC),
    .pc_out_o(pc_out_o)
    );

Adder Adder1(
    .src1_i(pc_out_o),
    .src2_i(32'b00000000000000000000000000000100),  //+4
    .sum_o(sum_o_adder1)
    );

Instr_Memory IM(
    .pc_addr_i(pc_out_o),
    .instr_o(instr_o)
    );

assign data_jump={{6{1'b0}},instr_o[25:0]};

Shift_Left_Two_32 Shifter1(
    .data_i(data_jump),
    .data_o(data_o_Shift1)
    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
    .data0_i(instr_o[20:16]),
    .data1_i(instr_o[15:11]),
    .select_i(RegDst_o),
    .data_o(data_o_Mux_Write)
    );

MUX_2to1 #(.size(5)) Mux_Write_Reg2(
    .data0_i(data_o_Mux_Write),
    .data1_i(5'b11111),
    .select_i(Jal_o),
    .data_o(data_o_Mux_Write2)
    );

assign RegWrite_o = (~Jr_o) & RegWrite1;

Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(instr_o[25:21]) ,
    .RTaddr_i(instr_o[20:16]) ,
    .RDaddr_i(data_o_Mux_Write2) ,
    .RDdata_i(memory_mux2_output) ,
    .RegWrite_i(RegWrite_o),
    .RSdata_o(RSdata_o) ,
    .RTdata_o(RTdata_o)
    );

Decoder Decoder(
    .instr_op_i(instr_o[31:26]),
    .RegWrite_o(RegWrite1),
    .ALU_op_o(ALU_op_o),
    .ALUSrc_o(ALUSrc_o),
    .RegDst_o(RegDst_o),
    .Branch_o(Branch_o),
    .Jump_o(Jump_o),
    .Jal_o(Jal_o),
    .zero_extend(zero_extend),
    .lui_ctrl(lui_ctrl),
    .sltiu_ctrl(sltiu_ctrl),
    .shamp_i(instr_o[10:6]),
    .shamp_o(shamp_o),
    .MemtoReg_o(MemtoReg_o),
    .MemRead_o(MemRead_o),
    .MemWrite_o(MemWrite_o)
    );

ALU_Ctrl AC(
    .funct_i(instr_o[5:0]),
    .ALUOp_i(ALU_op_o),
    .ALUCtrl_o(ALUCtrl_o),
    .Shift_o(Shift_o),
    .Jr_o(Jr_o),
    .mul_s(mul_s)
    );

Sign_Extend SE(
    .data_i(instr_o[15:0]),
    .data_o(data_o_Sign_Extend)
    );

Zero_Filled_Extend ZFE(
    .data_i(instr_o[15:0]),
    .data_o(data_o_Zero_Filled_Extend)
    );

MUX_2to1 #(.size(32)) Mux_Signed_or_Unsigned(
    .data0_i(data_o_Sign_Extend),
    .data1_i(data_o_Zero_Filled_Extend),
    .select_i(zero_extend),
    .data_o(data_o_Extend)
    );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
    .data0_i(RTdata_o),
    .data1_i(data_o_Extend),
    .select_i(ALUSrc_o),
    .data_o(data_o_Mux_ALUSrc)
    );

ALU ALU(
    .src1_i(RSdata_o),
    .src2_i(data_o_Mux_ALUSrc),
    .ctrl_i(ALUCtrl_o),
    .sltiu_ctrl(sltiu_ctrl),
    .lui_ctrl(lui_ctrl),
    .shamp(shamp_o),
    .shift(Shift_o),
    .result_o(result_o),
    .zero_o(zero_o)
    );

Multiply Mul(
    .src1_i(RSdata_o),
    .src2_i(RTdata_o),
    .sum_o(mul_o)
    );

MUX_2to1 #(.size(32)) Mul_or_ALU(
    .data0_i(result_o),
    .data1_i(mul_o),
    .select_i(mul_s),
    .data_o(m_or_a)
    );


Adder Adder2(
    .src1_i(sum_o_adder1),
    .src2_i(data_o_Shift2),
    .sum_o(sum_o_adder2)
    );

Shift_Left_Two_32 Shifter2(
    .data_i(data_o_Sign_Extend),
    .data_o(data_o_Shift2)
    );

assign PC_select1 = Branch_o && zero_o;
assign PC_select2 = Branch_o && (~zero_o);
assign RS_zero = ~|RSdata_o;
assign PC_select3 = Branch_o && (RSdata_o[31]||RS_zero);
assign PC_select4 = Branch_o && (~RSdata_o[31]&&~RS_zero);


MUX_4to1 #(.size(1)) Mux_Branch(
    .data0_i(PC_select1),
    .data1_i(PC_select2),
    .data2_i(PC_select3),
    .data3_i(PC_select4),
    .select_i(instr_o[27:26]),
    .data_o(PC_select)
    );

MUX_2to1 #(.size(32)) Mux_PC_Source1(
    .data0_i(sum_o_adder1),
    .data1_i(sum_o_adder2),    
    .select_i(PC_select),
    .data_o(data_o_PCSrc)
    );

assign data_o_jump={sum_o_adder1[31:28],data_o_Shift1[27:0]};

MUX_2to1 #(.size(32)) Mux_PC_Source2(
    .data0_i(data_o_PCSrc),
    .data1_i(data_o_jump),   
    .select_i(Jump_o),
    .data_o(data_o_PC1)
    );

MUX_2to1 #(.size(32)) Mux_PC_Source3(
    .data0_i(data_o_PC1),
    .data1_i(RSdata_o),    
    .select_i(Jr_o),
    .data_o(data_o_PC)
    );


Data_Memory Data_Memory(
    .clk_i(clk_i),
    .addr_i(result_o),
    .data_i(RTdata_o),
    .MemRead_i(MemRead_o),
    .MemWrite_i(MemWrite_o),
    .data_o(memory_output)
    );

MUX_2to1 #(.size(32)) Mux_Memory(
    .data0_i(m_or_a),
    .data1_i(memory_output),
    .select_i(MemtoReg_o),
    .data_o(memory_mux_output)
    );

MUX_2to1 #(.size(32)) Mux_Memory2(
    .data0_i(memory_mux_output),
    .data1_i(data_o_PCSrc),
    .select_i(Jal_o),
    .data_o(memory_mux2_output)
    );






endmodule



