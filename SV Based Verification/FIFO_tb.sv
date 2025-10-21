import FIFO_transaction_pkg::*;
import shared_pkg::*;

module FIFO_tb (FIFO_if.TEST fifo_if);

FIFO_transaction obj = new();

initial begin
    assert_reset();
    -> input_driven;

    repeat(10000) begin
        assert(obj.randomize());
        fifo_if.rst_n = obj.rst_n;
        fifo_if.data_in = obj.data_in;
        fifo_if.wr_en = obj.wr_en;
        fifo_if.rd_en = obj.rd_en;
        @(negedge fifo_if.clk);
        -> input_driven;
    end
    test_finished = 1;
end

task assert_reset();
    fifo_if.rst_n = 0;
    fifo_if.data_in = 0;
    fifo_if.wr_en = 0;
    fifo_if.rd_en = 0;
    @(negedge fifo_if.clk);
    fifo_if.rst_n = 1;
endtask

endmodule