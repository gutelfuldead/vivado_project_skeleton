PTOP                     = $(shell pwd)
VALID_TARGETS            = dummy_project_name \
			csp_ae_1024MB
VIVADO_REQI_VERSION      ?= 2017.1

CLEAN_TARGETS            = $(VALID_TARGETS) \
			.Xil \
			*.layout \
			*.debug \
			*.mif \
			*.btree \
			*.log \
			*.jou \
			*.zip \
			*.str \
			*.txt
CLEAN_BDS                = $(VALID_TARGETS)
TCL_PATH                 = $(PTOP)/src/tcl
OUTPUT_PATH              = $(PTOP)/src/outputFiles
VIVADO_CMD               = vivado -mode batch -source
VIVADO_REQI_VERSION      = 2017.1
VIVADO_REQI_VERSION_STR  = v$(VIVADO_REQI_VERSION)
VIVADO_HOST_VERSION_STR  = $(shell vivado -version | awk '{print $$2}' | head -n 1)
VIVADO_DEF_BASE_PATH     = /opt/Xilinx/Vivado/$(VIVADO_REQI_VERSION)
VIVADO_BASE_PATH        ?= $(VIVADO_DEF_BASE_PATH)
BITSTREAM_TCL            = $(TCL_PATH)/build_bitstream.tcl

NULL :=
TAB  := $(NULL)		$(NULL)

all: help

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
	$(VIVADO_CMD) $(TCL_PATH)/proj_gen.tcl -tclargs $(TARGET) #>> $(TARGET).log
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

clean-targets:
	rm -rf $(CLEAN_TARGETS)

clean-all: clean-targets

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

.PHONY: clean-all help
