set projName [lindex $argv 0]
set bitString _system_top.bit
set projNameBit $projName$bitString

# create workspace
setws .

# import the hdf
createhw -name hw -hwspec ../../outputFiles/$projName.hdf

# create bsp
createbsp -name bsp -hwproject hw -proc ps7_cortexa9_0

# create fsbl
createapp -name fsbl -app {Zynq FSBL} -hwproject hw -proc ps7_cortexa9_0

# create empty app
createapp -name app -app {Empty Application} -bsp bsp -hwproject hw -proc ps7_cortexa9_0
importsources -name app -path ../src -linker-script   

# add compiler symbols
# configapp -app app define-compiler-symbols CUSTOM_SYMBOL
configapp -app app linker-script ../src/lscript.ld
configapp -app app include-path ../src/some-folder

# build the project
projects -build

