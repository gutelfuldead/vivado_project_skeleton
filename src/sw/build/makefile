CLEAN_TARGETS  = app \
		 bsp \
		 fsbl \
		 fsbl_bsp \
		 hw \
		 .Xil \
		 SDK.log \
		 .metadata \
		 RemoteSystemsTempFiles \
		 .sdk

NULL          := 
TAB           := $(NULL)	$(NULL)

TARGET        ?= dummy_project_name

all: clean-all build load

build:
	hw_server &
	xsct ./build.tcl $(TARGET)

clean-all:
	rm -rf $(CLEAN_TARGETS)

load:
	xsct ./load.tcl $(TARGET)

bin-gen:
	cp ./hw/*.bit ./hw/system.bit
	cp ./app/Debug/*.elf ./app/Debug/app.elf
	bootgen -image app.bif -o $(TARGET).bin -w

flash-zed:
	./program_zed.tcl

help:
	$(info make)
	$(info $(TAB)automatically cleans, builds, and loads hardware)
	$(info )
	$(info make build)
	$(info $(TAB)builds the application and loads a locally connected zedboard via jtag)
	$(info )
	$(info make clean-all)
	$(info $(TAB)cleans all auto-gen files)
	$(info )

.PHONY: build clean-all help load bin-gen flash-zed
