package FIFO_coverage_pkg;
import FIFO_transaction_pkg::*;

class FIFO_coverage;
    FIFO_transaction F_cvg_txn;

    covergroup Cov;
        wr_en_cp: coverpoint F_cvg_txn.wr_en;
        rd_en_cp: coverpoint F_cvg_txn.rd_en;
        wr_ack_cp: coverpoint F_cvg_txn.wr_ack;
        overflow_cp: coverpoint F_cvg_txn.overflow;
        full_cp: coverpoint F_cvg_txn.full;
        empty_cp: coverpoint F_cvg_txn.empty;
        almostfull_cp: coverpoint F_cvg_txn.almostfull;
        almostempty_cp: coverpoint F_cvg_txn.almostempty;
        underflow_cp: coverpoint F_cvg_txn.underflow;
        
        wr_ack_cr: cross wr_en_cp, rd_en_cp, wr_ack_cp{
            illegal_bins wr_ack_illegal = binsof(wr_en_cp) intersect {0} && binsof(wr_ack_cp) intersect {1};
        }
        overflow_cr: cross wr_en_cp, rd_en_cp, overflow_cp{
            illegal_bins overflow_illegal = binsof(wr_en_cp) intersect {0} && binsof(overflow_cp) intersect {1};
        }
        full_cr: cross wr_en_cp, rd_en_cp, full_cp{
            illegal_bins full_illegal = binsof(rd_en_cp) intersect {1} && binsof(full_cp) intersect {1};
        }
        empty_cr: cross wr_en_cp, rd_en_cp, empty_cp;
        almostfull_cr: cross wr_en_cp, rd_en_cp, almostfull_cp;
        almostempty_cr: cross wr_en_cp, rd_en_cp, almostempty_cp;
        underflow_cr: cross wr_en_cp, rd_en_cp, underflow_cp{
            illegal_bins underflow_illegal = binsof(rd_en_cp) intersect {0} && binsof(underflow_cp) intersect {1};
        }

    endgroup

    function new();
        Cov = new();
    endfunction

    function void sample_data(FIFO_transaction F_txn);
        F_cvg_txn = F_txn;
        Cov.sample();
    endfunction
endclass

endpackage