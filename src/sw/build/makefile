CLEAN_TARGETS=app1 \
	      bsp1 \
	      hw1 \
	      .Xil \
	      SDK.log \
	      .metadata \
	      RemoteSystemsTempFiles \
	      .sdk

all: clean-all build

TARGET ?= dummy_project_name

build:
	hw_server &
	xsct ./build.tcl $(TARGET)

clean-all:
	rm -rf $(CLEAN_TARGETS)

help:
	$(info make)
	$(info automatically cleans, builds, and loads hardware)
	$(info )
	$(info make build)
	$(info builds the application and loads a locally connected zedboard via jtag)
	$(info )
	$(info make clean-all)
	$(info cleans all auto-gen files)
	$(info )

.PHONY: build clean-all help
