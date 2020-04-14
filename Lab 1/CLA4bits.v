// 陳昱丞 0716206

module CLA4bits(
             G,
             P,
             cin,
             cout
 ) ;
   input  [4-1:0] G, P;
   input  cin;
   output [4-1:0] cout;

   assign cout[0] = G[0] | (P[0] & cin);
   assign cout[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & cin);
   assign cout[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & cin);
   assign cout[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & cin);
   
endmodule
