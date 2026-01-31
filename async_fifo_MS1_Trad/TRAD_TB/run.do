vlib work
vdel -all
vlib work

vlog -sv ../rtl/async_fifo.sv tb_async_fifo.sv +acc

vsim work.tb_async_fifo


add wave -r *

run -all