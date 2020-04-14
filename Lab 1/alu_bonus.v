// 陳昱丞 0716206

`timescale 1ns/1ps

module alu(
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
		   bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;
//Origin above

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
wire [2:0]      ctrl, bonusctrl;
   
alu32bits a1(
	.src1(src1),
	.src2(src2),
	.less(set),
	.A_invert(ALU_control[3]),
	.B_invert(ALU_control[2]),
	.cin(ALU_control[2]),
	.operation(ALU_control[1:0]),
	.result(r),
	.cout(c),
	.equal(equal),
	.V(over),
	.Sign(s)
);
   
Compare Com1(
	.ctrl(ctrl),
	.bonusctrl(bonusctrl)
);

assign sign_check = equal[31];
assign bonusctrl = bonus_control;
assign a = ALU_control[1] & ~ALU_control[0];
assign equall = &equal;
assign lt = sign_check ? s : src1[31];
assign set = ctrl[2] ^ ( ctrl[1] & lt | ctrl[0] & equall );

   
always @ ( *  ) begin
	if (rst_n) begin
		zero <= ~|r;
		overflow <= over; 
		cout <= c & a;
		result <= r;      
	end 
end
   
endmodule
