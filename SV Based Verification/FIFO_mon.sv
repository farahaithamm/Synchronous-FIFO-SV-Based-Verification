import shared_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;

module FIFO_monitor (FIFO_if.MONITOR fifo_if);
FIFO_coverage fc = new();
FIFO_transaction ft = new();
FIFO_scoreboard fs = new();

initial begin
    forever begin
        @(input_driven);
        @(negedge fifo_if.clk);
        ft.data_in = fifo_if.data_in;
        ft.rst_n = fifo_if.rst_n;
        ft.wr_en = fifo_if.wr_en;
        ft.rd_en = fifo_if.rd_en;
        ft.data_out = fifo_if.data_out;
        ft.wr_ack = fifo_if.wr_ack;
        ft.overflow = fifo_if.overflow;
        ft.full = fifo_if.full;
        ft.empty = fifo_if.empty;
        ft.almostfull = fifo_if.almostfull;
        ft.almostempty = fifo_if.almostempty;
        ft.underflow = fifo_if.underflow;

        fork
            begin
                fc.sample_data(ft);
            end

            begin
                fs.check_data(ft);
            end
        join

        if (test_finished) begin
            $display(" TEST FINISHED: correct_count = %d, error_count = %d", correct_count, error_count);
            $display(" TEST FINISHED: all_correct_count = %d, all_error_count = %d", all_correct_count, all_error_count);
            $stop;
        end
    end
end

endmodule