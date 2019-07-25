set projName [lindex $argv 0]
set bitString _wrapper.bit
set projNameBit $projName$bitString

setws .

# connect to board
# connect -host remotehost.com -port 3121
connect -host localhost -port 3121
source ./hw/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*"} -index 0
rst -system
after 3000
fpga -file ./hw/$projNameBit
targets -set -nocase -filter {name =~"APU*"} -index 0
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0"} -index 0
dow ./app/Debug/app.elf

# run
targets -set -nocase -filter {name =~ "ARM*#0"} -index 0
con
