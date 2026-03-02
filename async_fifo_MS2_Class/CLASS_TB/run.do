vlib work
vdel -all
vlib work

vlog -sv ../rtl/async_fifo.sv top.sv +acc 

vsim -coverage top -l Transcript -voptargs="+cover=bcesfx"
#vsim work.top -log Transcript

add wave -r *
#do wave.do
run -all

coverage report -code bcesft -output CoverageReport
coverage report -codeAll
coverage report -assert -binrhs -details -cvg