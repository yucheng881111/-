// Author: 0716206 陳昱丞, 0716221 余忠旻

module alu8bits(
  src1,
  src2,
  less,
  A_invert,
  B_invert,
  cin,
  operation,
  result,
  cout,
  P,
  G,
  equal,
);

   
input [7:0] src1, src2;
input       cin, less, A_invert, B_invert;
input [1:0] operation;


wire   [7:0] p,g;
wire   [7:0] c;


output  P, G;
output [7:0] equal;
output [7:0] result;
output [7:0] cout;


CLA8bits cl(
  .G(g),
  .P(p),
  .P_out(P),
  .G_out(G),
  .cin(cin),
  .cout(c)
);



alu_top a1(
  .src1(src1[0]),
  .src2(src2[0]),
  .less(less),
  .A_invert(A_invert),
  .B_invert(B_invert),
  .cin(cin),
  .operation(operation),
  .result(result[0]),
  .p(p[0]),
  .g(g[0]),
  .equal(equal[0])
);


alu_top a2(
  .src1(src1[1]),
  .src2(src2[1]),
  .less(1'b0),
  .A_invert(A_invert),
  .B_invert(B_invert),
  .cin(c[0]),
  .operation(operation),
  .result(result[1]),
  .p(p[1]),
  .g(g[1]),
  .equal(equal[1])
);


alu_top a3(
  .src1(src1[2]),
  .src2(src2[2]),
  .less(1'b0),
  .A_invert(A_invert),
  .B_invert(B_invert),
  .cin(c[1]),
  .operation(operation),
  .result(result[2]),
  .p(p[2]),
  .g(g[2]),
  .equal(equal[2])	      
);


alu_top a4(
  .src1(src1[3]),
  .src2(src2[3]),
  .less(1'b0),
  .A_invert(A_invert),
  .B_invert(B_invert),
  .cin(c[2]),
  .operation(operation),
  .result(result[3]),
  .p(p[3]),
  .g(g[3]),
  .equal(equal[3])
);


alu_top a5(
  .src1(src1[4]),
  .src2(src2[4]),
  .less(1'b0),
  .A_invert(A_invert),
  .B_invert(B_invert),
  .cin(c[3]),
  .operation(operation),
  .result(result[4]),
  .p(p[4]),
  .g(g[4]),
  .equal(equal[4])
);


alu_top a6(
  .src1(src1[5]),
  .src2(src2[5]),
  .less(1'b0),
  .A_invert(A_invert),
  .B_invert(B_invert),
  .cin(c[4]),
  .operation(operation),
  .result(result[5]),
  .p(p[5]),
  .g(g[5]),
  .equal(equal[5])
);


alu_top a7(
  .src1(src1[6]),
  .src2(src2[6]),
  .less(1'b0),
  .A_invert(A_invert),
  .B_invert(B_invert),
  .cin(c[5]),
  .operation(operation),
  .result(result[6]),
  .p(p[6]),
  .g(g[6]),
  .equal(equal[6])	      
);


alu_top a8(
  .src1(src1[7]),
  .src2(src2[7]),
  .less(1'b0),
  .A_invert(A_invert),
  .B_invert(B_invert),
  .cin(c[6]),
  .operation(operation),
  .result(result[7]),
  .p(p[7]),
  .g(g[7]),
  .equal(equal[7])	      
);



assign cout = c;

endmodule
