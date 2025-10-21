////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT fifo_if);
 
localparam max_fifo_addr = $clog2(fifo_if.FIFO_DEPTH);

reg [fifo_if.FIFO_WIDTH-1:0] mem [fifo_if.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		wr_ptr <= 0;
		fifo_if.overflow <= 0;
		fifo_if.wr_ack <= 0;
	end
	else if (fifo_if.wr_en && count < fifo_if.FIFO_DEPTH) begin
		mem[wr_ptr] <= fifo_if.data_in;
		fifo_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		fifo_if.overflow <= 0;
	end
	else begin 
		fifo_if.wr_ack <= 0; 
		if (fifo_if.full & fifo_if.wr_en)
			fifo_if.overflow <= 1;
		else
			fifo_if.overflow <= 0;
	end
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		rd_ptr <= 0;
		fifo_if.underflow <= 0;
	end
	else if (fifo_if.rd_en && count != 0) begin
		fifo_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		fifo_if.underflow <= 0;
	end
	else begin
		if (fifo_if.empty && fifo_if.rd_en)
			fifo_if.underflow <= 1;
		else
			fifo_if.underflow <= 0;
	end
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b10) && !fifo_if.full) 
			count <= count + 1;
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b01) && !fifo_if.empty)
			count <= count - 1;
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.full) 
			count <= count - 1;
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.empty) 
			count <= count + 1;
	end
end

assign fifo_if.full = (count == fifo_if.FIFO_DEPTH)? 1 : 0;
assign fifo_if.empty = (count == 0)? 1 : 0;
assign fifo_if.almostfull = (count == fifo_if.FIFO_DEPTH-1)? 1 : 0; 
assign fifo_if.almostempty = (count == 1)? 1 : 0;

`ifdef SIM

always_comb begin
	if(!fifo_if.rst_n) begin
		count_a: assert final(count == {(max_fifo_addr+1){1'b0}});
		wr_ptr_a: assert final(wr_ptr == {max_fifo_addr{1'b0}});
		rd_ptr_a: assert final(rd_ptr == {max_fifo_addr{1'b0}});
		overflow_a: assert final(fifo_if.overflow == 1'b0);
		wr_ack_a: assert final(fifo_if.wr_ack == 1'b0);
		underflow_a: assert final(fifo_if.underflow == 1'b0);
		full_a: assert final(fifo_if.full == 1'b0);
		empty_a: assert final(fifo_if.empty == 1'b1);
		almostfull_a: assert final(fifo_if.almostfull == 1'b0);
		almostempty_a: assert final(fifo_if.almostempty == 1'b0);
	end

	if(count == fifo_if.FIFO_DEPTH)
		full_aa: assert final(fifo_if.full == 1'b1);

	if(count == fifo_if.FIFO_DEPTH-1)
		almostfull_aa: assert final(fifo_if.almostfull == 1'b1);

	if(count == 1'b0)
		empty_aa: assert final(fifo_if.empty == 1'b1);
	
	if(count == 1'b1)
		almostempty_aa: assert final(fifo_if.almostempty == 1'b1);
end

property wr_ack_p;
	@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
	(!fifo_if.full && fifo_if.wr_en) |=> fifo_if.wr_ack;
endproperty

property overflow_p;
	@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
	(fifo_if.full && fifo_if.wr_en) |=> fifo_if.overflow;
endproperty

property underflow_p;
	@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
	(fifo_if.empty && fifo_if.rd_en) |=> fifo_if.underflow;
endproperty

property count_rw_empty_p;
	@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
	(fifo_if.empty && fifo_if.rd_en && fifo_if.wr_en) |=> (count == $past(count) + 1'b1);
endproperty

property count_rw_full_p;
	@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
	(fifo_if.full && fifo_if.rd_en && fifo_if.wr_en) |=> (count == $past(count) - 1'b1);
endproperty

property count_w_p;
	@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
	(!fifo_if.full && !fifo_if.rd_en && fifo_if.wr_en) |=> (count == $past(count) + 1'b1);
endproperty

property count_r_p;
	@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
	(!fifo_if.empty && fifo_if.rd_en && !fifo_if.wr_en) |=> (count == $past(count) - 1'b1);
endproperty

property wr_ptr_p;
	@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
	(!fifo_if.full && fifo_if.wr_en) |=> (wr_ptr == $past(wr_ptr) + 1'b1);
endproperty

property rd_ptr_p;
	@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
	(!fifo_if.empty && fifo_if.rd_en) |=> (rd_ptr == $past(rd_ptr) + 1'b1);
endproperty

wr_ack_pa: assert property(wr_ack_p);
overflow_pa: assert property(overflow_p);
underflow_pa: assert property(underflow_p);
count_rw_empty_pa: assert property(count_rw_empty_p);
count_rw_full_pa: assert property(count_rw_full_p);
count_w_pa: assert property(count_w_p);
count_r_pa: assert property(count_r_p);
wr_ptr_pa: assert property(wr_ptr_p);
rd_ptr_pa: assert property(rd_ptr_p);

wr_ack_pc: cover property(wr_ack_p);
overflow_pc: cover property(overflow_p);
underflow_pc: cover property(underflow_p);
count_rw_empty_pc: cover property(count_rw_empty_p);
count_rw_full_pc: cover property(count_rw_full_p);
count_w_pc: cover property(count_w_p);
count_r_pc: cover property(count_r_p);
wr_ptr_pc: cover property(wr_ptr_p);
rd_ptr_pc: cover property(rd_ptr_p);

`endif

endmodule