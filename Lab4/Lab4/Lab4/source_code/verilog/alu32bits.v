// Author: 0716206 陳昱丞, 0716221 余忠旻

module alu32bits(
  src1,
  src2,
  less,
  A_invert,
  B_invert,
  cin,
  operation,
  result,
  cout,
  equal,
  V,
  Sign
);


input  [31:0]  src1, src2;
input 	       cin, less, A_invert, B_invert;
input  [1:0]   operation;


wire   [3:0]   p,g;
wire   [3:0]   c;
wire   [7:0]   v;


output [31:0]  equal;
output 	       V;
output         Sign;
output         cout;
output [31:0]  result;



CLA4bits cl(
  .G(g),
  .P(p),
  .cin(cin),
  .cout(c)
);



alu8bits e1(
  .src1(src1[7:0]),
  .src2(src2[7:0]),
  .less(less),
  .A_invert(A_invert),
  .B_invert(B_invert),
  .cin(cin),
  .operation(operation),
  .result(result[7:0]),
  .P(p[0]),
  .G(g[0]),
  .equal(equal[7:0])
);


alu8bits e2(
  .src1(src1[15:8]),
  .src2(src2[15:8]),
  .less(1'b0),
  .A_invert(A_invert),
  .B_invert(B_invert),
  .cin(c[0]),
  .operation(operation),
  .result(result[15:8]),
  .P(p[1]),
  .G(g[1]),
  .equal(equal[15:8])           
);


alu8bits e3(
  .src1(src1[23:16]),
  .src2(src2[23:16]),
  .less(1'b0),
  .A_invert(A_invert),
  .B_invert(B_invert),
  .cin(c[1]),
  .operation(operation),
  .result(result[23:16]),
  .P(p[2]),
  .G(g[2]),
  .equal(equal[23:16])
);


alu8bits e4(
  .src1(src1[31:24]),
  .src2(src2[31:24]),
  .less(1'b0),
  .A_invert(A_invert),
  .B_invert(B_invert),
  .cin(c[2]),
  .operation(operation),
  .result(result[31:24]),
  .P(p[3]),
  .G(g[3]),
  .equal(equal[31:24]),
  .cout(v)
);


assign cout = c[3];
assign V = c[3] ^ v[6];
assign Sign = equal[31] ^ v[6];
   
endmodule
