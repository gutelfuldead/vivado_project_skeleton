PTOP                    =  $(shell pwd)
VALID_TARGETS           =  dummy_project_name
VIVADO_REQI_VERSION     ?= 2017.1

CLEAN_TARGETS           =  $(VALID_TARGETS) \
			.Xil \
			ip_repo \
			NA \
			*.layout \
			*.debug \
			*.mif \
			*.btree \
			*.log \
			*.jou \
			*.zip \
			*.str \
			*.txt
CLEAN_BDS               =  $(VALID_TARGETS)
TCL_PATH                =  $(PTOP)/src/tcl
OUTPUT_PATH             =  $(PTOP)/src/outputFiles
VIVADO_CMD              =  vivado -mode batch -source
VIVADO_REQI_VERSION_STR =  v$(VIVADO_REQI_VERSION)
VIVADO_HOST_VERSION_STR =  $(shell vivado -version | awk '{print $$2}' | head -n 1)
VIVADO_DEF_BASE_PATH    =  /opt/Xilinx/Vivado/$(VIVADO_REQI_VERSION)
VIVADO_BASE_PATH        ?= $(VIVADO_DEF_BASE_PATH)
VIVADO_CABLE_DRIVR_PATH = $(VIVADO_BASE_PATH)/data/xicom/cable_drivers/lin64/install_script/install_drivers
VIVADO_BOARD_PATH       = $(VIVADO_BASE_PATH)/data/boards/board_parts
BITSTREAM_TCL           =  $(TCL_PATH)/build_bitstream.tcl

NULL                    := 
TAB                     := $(NULL)	$(NULL)

# default target is the first in the VALID_TARGETS array
TARGET                  ?= $(word 1,$(VALID_TARGETS))

export TARGET

all: help

initEnv: checkVivadoPath
	$(info Copying custom board files to Vivado...)
	$(shell sudo cp -r ./src/customBoardFiles $(VIVADO_BOARD_PATH))
	$(info $(TAB)Sourcing Vivado Xilinx Environment...)
	- $(shell cd $(VIVADO_BASE_PATH) && sudo ./settings64.sh && cd $(PTOP))
	$(info $(TAB)Running script to install Digilent Cable Drivers...)
	- $(shell cd $(VIVADO_CABLE_DRIVR_PATH) && sudo ./install_drivers && cd $(PTOP))
	$(info)
	$(info Error is normal; restart machine)
	$(info)

checkVersion:
ifneq ($(VIVADO_HOST_VERSION_STR),$(VIVADO_REQI_VERSION_STR))
	$(error Vivado version $(VIVADO_HOST_VERSION_STR) detected...Requires $(VIVADO_REQI_VERSION)...)
endif

checkVivadoPath:
ifeq ($(wildcard $(VIVADO_BASE_PATH)/bin/vivado),)
	$(error Vivado binary not found in $(VIVADO_BASE_PATH); check path...)
endif

checkValidProjName:
ifeq ($(filter $(TARGET),$(VALID_TARGETS)),)
	$(error $(TARGET) does not exist...)
endif

build: checkValidProjName checkVersion
	$(VIVADO_CMD) $(TCL_PATH)/proj_gen.tcl -tclargs $(TARGET) >> $(TARGET).log
	$(info )
	$(info )
	$(info vivado ./$(TARGET)/$(TARGET).xpr)
	$(info )
	$(info )
	$(info !!! GENERATING BITSTREAM !!!)
	$(info )
	$(info )
	$(MAKE) bitstream

bitstream: checkValidProjName checkVersion
	$(VIVADO_CMD) $(BITSTREAM_TCL) -tclargs $(TARGET) $(OUTPUT_PATH)
	cp $(TARGET)/$(TARGET).runs/impl_1/*.sysdef $(OUTPUT_PATH)/$(TARGET).hdf
	cp $(TARGET)/$(TARGET).runs/impl_1/*.bit $(OUTPUT_PATH)/$(TARGET).bit
	if [ -f $(TARGET)/$(TARGET).runs/impl_1/$(TARGET)_wrapper.ltx ]; then \
		cp $(TARGET)/$(TARGET).runs/impl_1/$(TARGET)_wrapper.ltx $(OUTPUT_PATH)/$(TARGET).ltx; \
	fi

clean-targets:
	rm -rf $(CLEAN_TARGETS)

clean-all: clean-targets
	$(MAKE) -C ./src/sw/build clean-all

sw-build: checkValidProjName checkVersion
	$(MAKE) -C ./src/sw/build build TARGET=$(TARGET)

sw-rebuild: checkValidProjName checkVersion
	$(MAKE) -C ./src/sw/build rebuild TARGET=$(TARGET)

sw-load: checkValidProjName checkVersion
	$(MAKE) -C ./src/sw/build load TARGET=$(TARGET)

sw-flash-zed: checkValidProjName checkVersion
	$(MAKE) -C ./src/sw/build flash-zed TARGET=$(TARGET)

help:
	$(info ====)
	$(info Help)
	$(info ====)
	$(info Xilinx Vivado $(VIVADO_REQI_VERSION_STR) Required... $(VIVADO_HOST_VERSION_STR) found)
	$(info )
	$(info make build TARGET=projName)
	$(info $(TAB)Builds vivado project, valid targets : $(VALID_TARGETS))
	$(info )
	$(info make clean-all)
	$(info $(TAB)To remove all auto-generated files -- including the project)
	$(info )
	$(info make sw-build)
	$(info $(TAB)Generates a baremetal sw app for the local ./src/outputFiles/[TARGET].hdf)
	$(info )
	$(info make sw-rebuild)
	$(info $(TAB)rebuilds only the source code for the software application)
	$(info )
	$(info make sw-load)
	$(info $(TAB)loads the software on a zynq platform)
	$(info )
	$(info make sw-flash-zed)
	$(info $(TAB)flashes the software on a zedboard)
	$(info )
	$(info make initEnv VIVADO_BASE_PATH=/opt/Xilinx/Vivado/2017.1)
	$(info $(TAB)sources digilent cable drivers)
	$(info )

.PHONY: clean-all help checkVersion checkVivadoPath checkValidProjName build bitstream \
	clean-targets initEnv sw-build sw-rebuild sw-load sw-flash-zed

