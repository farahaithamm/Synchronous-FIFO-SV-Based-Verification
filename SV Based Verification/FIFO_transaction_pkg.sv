package FIFO_transaction_pkg;

class FIFO_transaction;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    rand logic [FIFO_WIDTH-1:0] data_in;
    rand logic rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow, full, empty, almostfull, almostempty, underflow;
    int RD_EN_ON_DIST;
    int WR_EN_ON_DIST;

    function new(int rd_dist = 30, wr_dist = 70);
        RD_EN_ON_DIST = rd_dist;
        WR_EN_ON_DIST = wr_dist;
    endfunction

    // FIFO_1
    constraint rst_n_const{
        rst_n dist {1 :/ 95, 0 :/ 5};
    }

    // FIFO_2
    constraint wr_en_const{
        wr_en dist {1 :/ WR_EN_ON_DIST, 0:/ (100 - WR_EN_ON_DIST)};
    }

    // FIFO_3
    constraint rd_en_const{
        rd_en dist {1 :/ RD_EN_ON_DIST, 0:/ (100 - RD_EN_ON_DIST)};
    }

endclass
    
endpackage