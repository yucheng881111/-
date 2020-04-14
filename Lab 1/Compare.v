// 陳昱丞 0716206

module Compare( 
	ctrl,
	bonusctrl
);

output [2:0] ctrl;
input  [2:0] bonusctrl;

assign ctrl[2] = bonusctrl[0] | (~bonusctrl[1] & bonusctrl[2]);
assign ctrl[1] = ~bonusctrl[2];
assign ctrl[0] = (bonusctrl[1] ^ bonusctrl[0]) | bonusctrl[2];

endmodule
