==============================================
Xilinx Vivado Project Version Control Skeleton
==============================================

Reference tree structure for source controlling Xilinx Vivado projects.

Tested in Vivado Versions ::

        2017.1
        2018.1

Includes,

- Makefile : to handle checking proper versions and automating build runs
- argument driven tcl scripts to generate bd from a tcl, create bitstream,
  and generate output run logs

TODO For all New Projects
=========================

1. Update ./src/tcl/proj_gen.tcl with correct ``board_part`` or ``part``
        as described in tcl section

2. Update Makefile with correct Vivado Version Number
        as described in Makefile Section

3. Update Makefile with project names
        as described in Makefile Section

Makefile
========

The Makefile needs to be modified for every new project to set a few project specific parameters

Vivado Version
--------------
This value prevents someone from using a different version of Vivado to generate the
project leading to potential errors ::

        VIVADO_REQ_VERSION ?= 2017.1

Valid Targets
-------------

These are the names given to each project in the directory. They must be
explicitly set in the Makefile ::

        VALID_TARGETS = dummy_project_1 \
                        dummy_project_2

These correspond with identical names in the bd and xdc directories

Generate Project
----------------

To generate a project and build the bitstream run ::

        make build TARGET=dummy_project_1

Tree Structure
==============

files and directories ::

        .
        ├── Makefile
        ├── README.rst
        └── src
            ├── bd
            ├── hdl
            ├── ip_catalog
            ├── outputFiles
            ├── sw
            │   ├── build
            │   │   ├── build.tcl
            │   │   └── makefile
            │   └── src
            ├── tcl
            │   ├── build_bitstream.tcl
            │   └── proj_gen.tcl
            └── xdc

        10 directories, 6 files


bd
--

This folder should contain the tcl file used to generate the block diagram
For example::

        dummy_project_1.tcl
        dummy_project_2.tcl

After creating the block diagram tcl script from Vivado
it may be necessary to update the origin variable inside ::

         set origin_dir .

hdl
---

This folder is used for standalone .vhd file that need to be brought into the
project. They will be imported into the top level of all projects automatically
through the proj_gen.tcl script.

ip_catalog
----------

This folder should contain all IP that is used in the design; svn externals
should be placed here.

output_files
------------

This folder is where the bitstream, hdf, and various reports are placed after
the design is finished running.

sw
--

This folder is where baremetal applications are generated and build. 
The complete source code for the baremetal application (include linker and
main) should be placed in ./sw/src

The top level makefile supports the ``make sw TARGET=projName`` option to then
create the application using the target hdf located in outputFiles, create a
BSP, and load a local zynq target with the application.

Per project changes such as C/C++ build settings should be modified in the
./sw/build/build.tcl script.

tcl
---

This folder contains two tcl scripts to generate the projects

``build_bitstream.tcl`` used to go through synthesis, implementation, place and
route, and finally generate the bitstream. This will populate the output_files
folder when complete.

``proj_gen.tcl`` used to generate the Vivado project. The ``board_part`` property
MUST match the intended hardware ... OR be replaced by a ``part`` specifically

Example using a ZedBoard (default) ::

        set_property -name "board_part" -value "digilentinc.com:zedboard:part0:1.0" -objects $obj

Example using a zynq 7035 part with no specific board ::

        set_property -name "part" -value "xc7z035fbg676-2" -objects $obj

xdc
---

This contains the constraints for the project. Currently proj_gen.tcl will only
pull in the constraints that have the same project name prefix.

For example, if the following files are present ::

        dummy_project_1.xdc
        dummy_project_1_timing.xdc
        dummy_project_1_io.xdc
        dummy_project_2.xdc

and ``make build TARGET=dummy_project_1`` is ran then the project will be generated
with ::

        dummy_project_1.xdc
        dummy_project_1_timing.xdc
        dummy_project_1_io.xdc

automatically added to the constr_1 set.

