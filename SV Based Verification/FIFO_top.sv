module FIFO_top();
bit clk;
initial begin
    forever #1 clk = ~clk;
end

FIFO_if fifo_if(clk);

FIFO dut(fifo_if);
FIFO_tb tb(fifo_if);
FIFO_monitor mon(fifo_if);

endmodule