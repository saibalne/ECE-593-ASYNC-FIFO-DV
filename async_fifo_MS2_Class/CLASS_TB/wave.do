onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/wclk
add wave -noupdate /top/rclk
add wave -noupdate /top/vif/wrst_n
add wave -noupdate /top/vif/wen
add wave -noupdate /top/vif/wdata_in
add wave -noupdate /top/vif/full
add wave -noupdate /top/vif/full_3_4th
add wave -noupdate /top/vif/w_m_n_full
add wave -noupdate /top/vif/rrst_n
add wave -noupdate /top/vif/ren
add wave -noupdate /top/vif/rdata_out
add wave -noupdate /top/vif/empty
add wave -noupdate /top/vif/empty_1_4th
add wave -noupdate /top/vif/wcb/wen
add wave -noupdate /top/vif/wcb/wdata_in
add wave -noupdate /top/dut/ctrl_inst/receiver_ctrl_inst/rptr
add wave -noupdate /top/dut/ctrl_inst/receiver_ctrl_inst/bin_ptr
add wave -noupdate /top/dut/ctrl_inst/receiver_ctrl_inst/gray_ptr
add wave -noupdate /top/dut/ctrl_inst/receiver_ctrl_inst/next_bin_ptr
add wave -noupdate /top/dut/ctrl_inst/receiver_ctrl_inst/next_gray_ptr
add wave -noupdate /top/dut/ctrl_inst/receiver_ctrl_inst/rempty_val
add wave -noupdate /top/dut/ctrl_inst/receiver_ctrl_inst/wptr_bin
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 146
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1003 ns}
