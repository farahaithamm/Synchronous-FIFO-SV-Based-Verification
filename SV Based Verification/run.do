vlib work
vlog +define+SIM -f files_list.list +cover -covercells
vsim -voptargs=+acc work.FIFO_top -cover
add wave *
run 0
add wave -position insertpoint  \
sim:/FIFO_top/fifo_if/FIFO_WIDTH \
sim:/FIFO_top/fifo_if/FIFO_DEPTH \
sim:/FIFO_top/fifo_if/clk \
sim:/FIFO_top/fifo_if/data_in \
sim:/FIFO_top/fifo_if/rst_n \
sim:/FIFO_top/fifo_if/wr_en \
sim:/FIFO_top/fifo_if/rd_en \
sim:/FIFO_top/fifo_if/data_out \
sim:/FIFO_top/fifo_if/wr_ack \
sim:/FIFO_top/fifo_if/overflow \
sim:/FIFO_top/fifo_if/full \
sim:/FIFO_top/fifo_if/empty \
sim:/FIFO_top/fifo_if/almostfull \
sim:/FIFO_top/fifo_if/almostempty \
sim:/FIFO_top/fifo_if/underflow 
add wave -position insertpoint  \
sim:/FIFO_top/dut/mem \
sim:/FIFO_top/dut/wr_ptr \
sim:/FIFO_top/dut/rd_ptr 
run -all
coverage save FIFO_top.ucdb -onexit