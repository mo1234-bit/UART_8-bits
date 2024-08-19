module UART(clk,rst,rx,rd_uart,r_data,rx_empty,w_data,wr_uart,tx_full,tx,FINAL_VALUE);
parameter DBIT=8;
parameter SB_TICK=16;
input clk,rst,rx,rd_uart,wr_uart;
input [DBIT-1:0]w_data;
input [10:0]FINAL_VALUE;
output [DBIT-1:0]r_data;
output rx_empty;
output tx_full;
output tx;
wire tick;
 Bauud_rating #(.BITS(11)) baud(.clk(clk),.rst(rst),.enable(1'b1),.FINAL_VALUE(FINAL_VALUE),.DONE(tick));

 wire rx_done_tick;
 wire [DBIT-1:0]rx_dout;
 UART_Recevier #(.DBIT(DBIT),.SB_TICK(SB_TICK)) recevier(.rx(rx),.s_tick(tick),.rx_dout(rx_dout),.rx_done_tick(rx_done_tick),.rst(rst),.clk(clk));

fifo_generator_0 rx_fifo (
  .clk(clk),      // input wire clk
  .srst(rst),    // input wire srst
  .din(rx_dout),      // input wire [7 : 0] din
  .wr_en(rx_done_tick),  // input wire wr_en
  .rd_en(rd_uart),  // input wire rd_en
  .dout(r_data),    // output wire [7 : 0] dout
  .full(),    // output wire full
  .empty(rx_empty)  // output wire empty
);

 wire tx_fifo_empty,tx_done_tick;
 wire [DBIT-1:0]tx_din;
 UART_Transmitter #(.DBIT(DBIT),.SB_TICK(SB_TICK)) transmitter(.s_tick(tick),.tx(tx),.tx_din(tx_din),.tx_din_done(tx_done_tick),.tx_start(~tx_fifo_empty),.rst(rst),.clk(clk));
 
fifo_generator_1 tx_fifo(
  .clk(clk),      // input wire clk
  .srst(rst),    // input wire srst
  .din(w_data),      // input wire [7 : 0] din
  .wr_en(wr_uart),  // input wire wr_en
  .rd_en(tx_done_tick),  // input wire rd_en
  .dout(tx_din),    // output wire [7 : 0] dout
  .full(tx_full),    // output wire full
  .empty(tx_fifo_empty)  // output wire empty
);


 endmodule