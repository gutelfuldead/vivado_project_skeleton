set design_name [lindex $argv 0]
set output_dir [lindex $argv 1]
puts "$design_name chosen"

open_project ./$design_name/$design_name.xpr

launch_runs synth_1
wait_on_run synth_1
open_run synth_1
report_timing_summary -file $output_dir/$design_name.timing_synth.log
report_utilization -file $output_dir/$design_name.utilization_synth.log

launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
open_run impl_1
report_timing_summary -file $output_dir/$design_name.timing_impl.log
report_utilization -file $output_dir/$design_name.utilization_impl.log

