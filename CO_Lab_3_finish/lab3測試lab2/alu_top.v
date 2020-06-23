// Author: 0716206 陳昱丞, 0716221 余忠旻

`timescale 1ns/1ps

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               p,
               g,
               equal,
);

input         src1;
input         src2;
input         less;
input 	     A_invert;
input         B_invert;
input         cin;
input [1:0]   operation;

output        result;

reg 		     result;
//Origin above

output        p;
output        g;
output        equal;

wire          input1,input2;
wire 	        And, Or, Add;
 
assign input1 = A_invert ^ src1;
assign input2 = B_invert ^ src2;
assign equal = input1 ^ input2;
assign And = input1 & input2;      //G
assign Or  = input1 | input2;      //P
assign Add = equal ^ cin;
assign p = Or;
assign g = And;

always@( * ) begin
   case (operation)
      2'b00 : result = And;
      2'b01 : result = Or;
      2'b10 : result = Add;
      2'b11 : result = less;
   endcase
end

endmodule
