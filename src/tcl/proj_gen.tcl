#*****************************************************************************************
# proj_gen.tcl : creates a vivado project from ./ip_library, ./bd/$(design_name).tcl
# and ./xdc/$(design_name)*.xdc
# Requires argument for the design_name
#*****************************************************************************************

if { $::argc <= 0 } {
	puts "ERROR: usage proj_gen.tcl -tclargs design_name"
	return 1
}
set design_name [lindex $argv 0]

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."
set zynqPart "xc7z020clg484-1"

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/$design_name"]"

# Create project
create_project $design_name $origin_dir/$design_name -part $zynqPart

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [get_projects $design_name]
set_property -name "part" -value $zynqPart -objects $obj
# set_property -name "board_part" -value "digilentinc.com:zedboard:part0:1.0" -objects $obj
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/$design_name.cache/ip" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "VHDL" -objects $obj
set_property -name "target_language" -value "VHDL" -objects $obj 

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set IP repository paths
set obj [get_filesets sources_1]
set_property "ip_repo_paths" "[file normalize "$origin_dir/src/ip_catalog"]" $obj

# add custom vhd files to the project
set pattern $origin_dir/src/hdl/*.vhd
set vhd_files [glob -nocomplain -- $pattern]
switch -exact [llength $vhd_files]] {
	0 {error "no files found matching $pattern"}
	default {
		for {set i 0} {$i < [llength $vhd_files]} {incr i} {
			set tmp [lindex $vhd_files $i]
			puts $tmp
			set file "[file normalize $tmp]"
			set file_added [add_files -norecurse -fileset $obj $file]
		}
	}
}

# Rebuild user ip_repo's index before adding any source files
update_ip_catalog -rebuild

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property "top" "${design_name}_wrapper" $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set pattern $origin_dir/src/xdc/$design_name*.xdc
set xdc_files [glob -nocomplain -- $pattern]
switch -exact [llength $xdc_files]] {
	0 {error "no files found matching $pattern"}
	default {
		for {set i 0} {$i < [llength $xdc_files]} {incr i} {
			set tmp [lindex $xdc_files $i]
			puts $tmp
			set file "[file normalize $tmp]"
			set file_added [add_files -norecurse -fileset $obj $file]
			set file $tmp
			set file [file normalize $file]
			set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
			set_property -name "file_type" -value "XDC" -objects $file_obj
		}
	}
}

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property "top" "${design_name}_wrapper" $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
  create_run -name synth_1 -part $zynqPart -flow {Vivado Synthesis 2017} -strategy "Vivado Synthesis Defaults" -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2017" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property -name "steps.synth_design.args.retiming" -value "1" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
  create_run -name impl_1 -part $zynqPart -flow {Vivado Implementation 2017} -strategy "Vivado Implementation Defaults" -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2017" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property -name "steps.write_bitstream.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.verbose" -value "0" -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:${design_name}"

# Create block design
source $origin_dir/src/bd/$design_name.tcl

# Generate the wrapper
make_wrapper -files [get_files *${design_name}.bd] -top
add_files -norecurse ${design_name}/${design_name}.srcs/sources_1/bd/${design_name}/hdl/${design_name}_wrapper.vhd

# Update the compile order
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Ensure parameter propagation has been performed
close_bd_design [current_bd_design]
open_bd_design [get_files ${design_name}.bd]
validate_bd_design -force
save_bd_design

