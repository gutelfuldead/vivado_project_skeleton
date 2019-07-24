# create workspace
setws .

deleteproject -name app
createapp -name app -app {Empty Application} -bsp bsp -hwproject hw -proc ps7_cortexa9_0
importsources -name app -path ../src   

# add compiler symbols
source cSettings.tcl

# build the project
projects -build -type app -name app

