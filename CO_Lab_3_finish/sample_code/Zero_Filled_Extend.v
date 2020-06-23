// Author: 0716206 陳昱丞, 0716221 余忠旻

module Zero_Filled_Extend(
    data_i,
    data_o
    );

//I/O ports
input   [16-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;

//Sign extended
always @(*) begin
	data_o={{16{1'b0}},data_i};
end

endmodule
