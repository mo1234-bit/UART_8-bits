module UART_Transmitter(s_tick,tx,tx_din,tx_din_done,tx_start,rst,clk);
parameter IDELE=0;
parameter START=1;
parameter DATA=2;
parameter STOP=3;
parameter DBIT=8;
parameter SB_TICK=16;
input rst,clk;
input s_tick,tx_start;
input [DBIT-1:0]tx_din;
output  tx_din_done;
output tx;
(*fsm_encoding="one_hot"*)
reg [1:0]ns,cs;
reg [3:0]s,s_next;
reg [2:0]n,n_next;
reg [DBIT-1:0]b,b_next;
reg tx,tx_next;
//state memory
always @(posedge clk or posedge rst) begin
	if (rst)begin
		cs<=IDELE;
		s<=0;
		n<=0;
		b<=0;
		tx<=1;
	end else 
		cs<=ns;
		s<=s_next;
		n<=n_next;
		b<=b_next;
		tx<=tx_next;
end
//next state logic
always@(*)begin
ns=cs;
s_next=s;
n_next=n;
b_next=b;
	case(cs)
	IDELE:begin
	    tx_next=1;
		if(tx_start)begin
		s_next=0;
        b_next=tx_din;
        ns=START;end
		else 
		ns=IDELE;
       
	end
	START:begin
	tx_next=0;
		if(s_tick)begin
			if(s==15)begin
				s_next=0;
				n_next=0;
				ns=DATA;
			end
			else begin
				s_next=s+1;
				ns=START;
			end
		end
		else begin
			ns=START;
		end

	end
	DATA:begin
	tx_next=b[0];
		if(s_tick)begin
			if(s==15)begin
				s_next=0;
				b_next={1'b0,b[DBIT-1:1]};
			  if(n==(DBIT-1))
			  ns=STOP;
			  else begin
			  	n_next=n+1;
			  	ns=DATA;
			  end
			end
			else begin
				s_next=s+1;
				ns=DATA;
			end
		end
		else begin
			ns=DATA;
		end

	end
	
	STOP:begin
	tx_next=1;
		if(s_tick)begin
			if(s==SB_TICK-1)begin
				ns=IDELE;
			end
			else begin
				s_next=s+1;
				ns=STOP;
			end
		end
		else begin
			ns=STOP;
		end

	end
default: ns=IDELE;
endcase
end
 
 //output logic
 assign tx_din_done=(cs==STOP&&s_tick&&(s==SB_TICK-1))?1:0;
 endmodule
