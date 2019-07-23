CLEAN_TARGETS  = app1 \
		 bsp1 \
		 hw1 \
		 .Xil \
		 SDK.log \
		 .metadata \
		 RemoteSystemsTempFiles \
		 .sdk

NULL          := 
TAB           := $(NULL)	$(NULL)

TARGET        ?= dummy_project_name

all: clean-all build

build:
	hw_server &
	xsct ./build.tcl $(TARGET)

clean-all:
	rm -rf $(CLEAN_TARGETS)

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

.PHONY: build clean-all help
