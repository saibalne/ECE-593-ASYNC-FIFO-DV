
vlib work
vdel -all
vlib work
vmap work work

vlog -sv +acc \
    +incdir+C:/questasim64_2025.2_1/verilog_src/uvm-1.2/src \
    C:/questasim64_2025.2_1/verilog_src/uvm-1.2/src/uvm_pkg.sv \
    ./rtl/design.sv \
    top.sv

# THe below command  is not supporting
#vlog -sv design.sv testbench.sv 
vsim -voptargs=+acc -c -sv_lib C:/questasim64_2025.2_1/uvm-1.2/win64/uvm_dpi work.top +UVM_TESTNAME=test  +UVM_NO_RELNOTES 

#vsim -voptargs=+acc work.top +UVM_TESTNAME=test_sa1_da1 +UVM_CONFIG_DB_TRACE +UVM_NO_RELNOTES +UVM_PHASE_TRACE

add wave -r /*

run -all