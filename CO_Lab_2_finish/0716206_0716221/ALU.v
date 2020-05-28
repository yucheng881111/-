// Author: 0716206 陳昱丞, 0716221 余忠旻

module ALU(
    src1_i,
    src2_i,
    ctrl_i,
    lui_ctrl,
    sltiu_ctrl,
    shamp,
    result_o,
    zero_o
    );

//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

input            lui_ctrl;
input            sltiu_ctrl;
input  [5-1:0]   shamp;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
reg             zero_o;

wire [31:0]     r;
wire            c;
wire 	        lt;
wire [31:0]     equal; 	
wire			s;   
wire 			a; 
wire 	        sign_check;
wire 	        over;
wire 	        set;
wire 	        equall;
wire [2:0]      ctrl;
wire  signed [32-1:0]  src1_shift;
wire  signed [32-1:0]  src2_shift;
   
alu32bits a1(
	.src1(src1_i),
	.src2(src2_i),
	.less(set),
	.A_invert(ctrl_i[3]),
	.B_invert(ctrl_i[2]),
	.cin(ctrl_i[2]),
	.operation(ctrl_i[1:0]),
	.result(r),
	.cout(c),
	.equal(equal),
	.V(over),
	.Sign(s)
);
   


assign sign_check = equal[31];
assign a = ctrl_i[1] & ~ctrl_i[0];
assign equall = &equal;
assign lt = sign_check ? s : src1_i[31];
assign set =  lt;
assign src1_shift = src1_i;
assign src2_shift = src2_i;

	


always @ ( *  ) begin
	zero_o <= ~|r;
	result_o <= r;
	
	if (sltiu_ctrl==1'b1 && src1_i[31]==1'b1) begin
		result_o <= 0;
	end  
	if (ctrl_i==4'b1111 && lui_ctrl==1'b1) begin
		result_o <= (src2_i << 16);
	end else if (ctrl_i==4'b1111 && shamp!=5'b00000) begin
		result_o <= (src2_shift >>> shamp);
	end else if (ctrl_i==4'b1111 && shamp==5'b00000) begin
		result_o <= (src2_shift >>> src1_i);
	end

end
   
endmodule
