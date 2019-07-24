CLEAN_TARGETS  = app \
		 bsp \
		 fsbl \
		 fsbl_bsp \
		 hw \
		 .Xil \
		 SDK.log \
		 .metadata \
		 RemoteSystemsTempFiles \
		 *.bin \
		 .sdk

NULL          := 
TAB           := $(NULL)	$(NULL)

TARGET        ?= zed_xcvr

all: help

build: clean-all
	xsct ./build.tcl $(TARGET)

rebuild:
	xsct ./rebuild.tcl $(TARGET)

clean-all:
	rm -rf $(CLEAN_TARGETS)

load:
	hw_server &
	xsct ./load.tcl $(TARGET)

bin-gen:
	if [ ! -f ./hw/system.bit ]; then \
		cp ./hw/*.bit ./hw/system.bit; \
	fi
	bootgen -image app.bif -o OUTPUT.bin -w

flash-zed: bin-gen
	program_flash -f ./OUTPUT.bin -offset 0 -flash_type qspi_single -cable type xilinx_tcf url TCP:127.0.0.1:3121
	# blank check and verify image
	# program_flash -f ./loadScripts/OUTPUT.bin -offset 0 -flash_type qspi_single -blank_check -verify -cable type xilinx_tcf url TCP:127.0.0.1:3121

	# specific digilent hw id
	# program_flash -f /home/labuser/svn/spawar_htcp_13140/sw/trunk/hwLoader/src/zed0.nocsp.bin -offset 0 -flash_type qspi_single -blank_check -verify -cable type xilinx_tcf url TCP:127.0.0.1:3121 esn Digilent/210299A1FC0D/ -debugdevice deviceNr 2  

help:
	$(info make build)
	$(info $(TAB)builds the application, bsp, and fsbl)
	$(info )
	$(info make rebuild)
	$(info $(TAB)rebuilds just the application)
	$(info )
	$(info make bin-gen)
	$(info $(TAB)generates a binary file of the application)
	$(info )
	$(info make flash-zed)
	$(info $(TAB)writes the application to a zedboard flash memory)
	$(info )
	$(info make clean-all)
	$(info $(TAB)cleans all auto-gen files)
	$(info )
	$(info make help)
	$(info $(TAB)display this menu)
	$(info )

.PHONY: build clean-all help load bin-gen flash-zed build rebuild
