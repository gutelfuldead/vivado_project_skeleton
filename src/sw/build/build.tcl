set projName [lindex $argv 0]
set bitString _system_top.bit
set projNameBit $projName$bitString

# create workspace
setws .

# import the hdf
createhw -name hw1 -hwspec ../../outputFiles/$projName.hdf

# create bsp
createbsp -name bsp1 -hwproject hw1 -proc ps7_cortexa9_0

# create empty app
createapp -name app1 -app {Empty Application} -bsp bsp1 -hwproject hw1 -proc ps7_cortexa9_0
importsources -name app1 -path ../src -linker-script   

# add compiler symbols
# configapp -app app1 define-compiler-symbols CUSTOM_SYMBOL
configapp -app app1 linker-script ../src/lscript.ld
configapp -app app1 include-path ../src/some-folder

# build the project
projects -build

# connect to board
# connect -host remotehost.com -port 3121
connect -host localhost -port 3121
source ./hw1/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*"} -index 0
rst -system
after 3000
fpga -file ./hw1/$projNameBit
targets -set -nocase -filter {name =~"APU*"} -index 0
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0"} -index 0
dow ./app1/Debug/app1.elf

# run
targets -set -nocase -filter {name =~ "ARM*#0"} -index 0
con
