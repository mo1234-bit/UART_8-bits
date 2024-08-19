module Bauud_rating(clk,rst,enable,FINAL_VALUE,DONE);
parameter BITS=4;
input clk,rst,enable;
input [BITS-1:0]FINAL_VALUE;
output DONE;
reg[BITS-1:0]q_reg,q_next;

always @(posedge clk or posedge rst) begin
	if (rst) 
		q_reg<=0;
	else if (enable) 
	q_reg<=q_next;

	else 
		q_reg<=q_reg;
end
assign DONE=(q_reg==FINAL_VALUE)?1:0;
always@(*)
q_next=(DONE)?0:q_reg+1;
endmodule