package FIFO_scoreboard_pkg;
import FIFO_transaction_pkg::*;
import shared_pkg::*;

class FIFO_scoreboard;
    parameter FIFO_WIDTH = 16;
    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic wr_ack_ref, overflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
    logic[FIFO_WIDTH-1:0] qmem [$];

    function void check_data(FIFO_transaction ftr);
        reference_model(ftr);

        if (ftr.data_out != data_out_ref) begin
            $display("ERROR!! - data_out_expected = %h , data_out = %h", data_out_ref, ftr.data_out);
            error_count++;
            all_error_count++;
        end
        else begin 
            correct_count++;
            all_correct_count++;
        end

        if (ftr.wr_ack != wr_ack_ref) begin
            $display("ERROR!! - wr_ack_expected = %h , wr_ack = %h", wr_ack_ref, ftr.wr_ack);
            all_error_count++;
        end
        else all_correct_count++;

        if (ftr.overflow != overflow_ref) begin
            $display("ERROR!! - overflow_expected = %h , overflow = %h", overflow_ref, ftr.overflow);
            all_error_count++;
        end
        else all_correct_count++;

        if (ftr.full != full_ref) begin
            $display("ERROR!! - full_expected = %h , full = %h", full_ref, ftr.full);
            all_error_count++;
        end
        else all_correct_count++;

        if (ftr.empty != empty_ref) begin
            $display("ERROR!! - empty_expected = %h , empty = %h", empty_ref, ftr.empty);
            all_error_count++;
        end
        else all_correct_count++;

        if (ftr.almostfull != almostfull_ref) begin
            $display("ERROR!! - almostfull_expected = %h , almostfull = %h", almostfull_ref, ftr.almostfull);
            all_error_count++;
        end
        else all_correct_count++;

        if (ftr.almostempty != almostempty_ref) begin
            $display("ERROR!! - almostempty_expected = %h , almostempty = %h", almostempty_ref, ftr.almostempty);
            all_error_count++;
        end
        else all_correct_count++;

        if (ftr.underflow != underflow_ref) begin
            $display("ERROR!! - underflow_expected = %h , underflow = %h", underflow_ref, ftr.underflow);
            all_error_count++;
        end
        else all_correct_count++;

    endfunction

    function void reference_model(FIFO_transaction ftr);
        if (!ftr.rst_n) begin
            wr_ack_ref = 0;
            overflow_ref = 0;
            full_ref = 0;
            empty_ref = 1;
            almostfull_ref = 0;
            almostempty_ref = 0;
            underflow_ref = 0;
            qmem.delete();
        end
        else begin
            wr_ack_ref = (ftr.wr_en && qmem.size() < ftr.FIFO_DEPTH);
            overflow_ref = (ftr.wr_en && qmem.size() == ftr.FIFO_DEPTH);
            underflow_ref = (ftr.rd_en && qmem.size() == 0);

            if (ftr.rd_en && !empty_ref) data_out_ref = qmem.pop_front();
            if (ftr.wr_en && !full_ref) qmem.push_back(ftr.data_in); 

            full_ref = (qmem.size() == ftr.FIFO_DEPTH);
            empty_ref = (qmem.size() == 0);
            almostfull_ref = (qmem.size() == ftr.FIFO_DEPTH - 1);
            almostempty_ref = (qmem.size() == 1);     

        end
    endfunction

endclass

endpackage