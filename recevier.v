module UART_Recevier(rx,s_tick,rx_dout,rx_done_tick,rst,clk);
parameter IDELE=0;
parameter START=1;
parameter DATA=2;
parameter STOP=3;
parameter DBIT=8;
parameter SB_TICK=16;
input rx,rst,clk;
input s_tick;
output [DBIT-1:0]rx_dout;
output  rx_done_tick;
(*fsm_encoding="one_hot"*)
reg [1:0]ns,cs;
reg [3:0]s,s_next;
reg [2:0]n,n_next;
reg [DBIT-1:0]b,b_next;
//state memory
always @(posedge clk or posedge rst) begin
	if (rst)begin
		cs<=IDELE;
		s<=0;
		n<=0;
		b<=0;
	end else 
		cs<=ns;
		s<=s_next;
		n<=n_next;
		b<=b_next;
		 
end
//next state logic
always@(*)begin
ns=cs;
s_next=s;
n_next=n;
b_next=b;
	case(cs)
	IDELE:begin
		if(rx)
		ns=IDELE;
		else 
		ns=START;
		s_next=0;
       
	end
	START:begin
		if(s_tick)begin
			if(s==7)begin
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
		if(s_tick)begin
			if(s==15)begin
				s_next=0;
				b_next={rx,b[DBIT-1:1]};
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
 assign rx_dout=b_next;
 assign rx_done_tick=(cs==STOP&&s_tick&&(s==SB_TICK-1))?1:0;
 endmodule
