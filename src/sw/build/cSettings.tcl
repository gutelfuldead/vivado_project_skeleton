# used to set the c build environment variables
# this should be modified on a project per project basis

configapp -app app linker-script ../src/lscript.ld

# $ xsct
# ****** Xilinx Software Commandline Tool (XSCT) v2017.1
#   **** Build date : Apr 14 2017-19:01:58
#     ** Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
# xsct% help configapp
# NAME
#     configapp - Configure settings for application projects

# SYNOPSIS
#     configapp
#         List name and description for available configuration
#         parameters for the application projects. Following configuration
#         parameters can be configured for applications:
#           assembler-flags         : Miscellaneous flags for assembler 
#           build-config            : Get/set build configuration
#           compiler-misc           : Compiler miscellaneous flags
#           compiler-optimization   : Optimization level
#           define-compiler-symbols : Define symbols. Ex. MYSYMBOL
#           include-path            : Include path for header files
#           libraries               : Libraries to be added while linking
#           library-search-path     : Search path for the libraries added
#           linker-misc             : Linker miscellaneous flags
#           linker-script           : Linker script for linking
#           undef-compiler-symbols  : Undefine symbols. Ex. MYSYMBOL
#
#     configapp [OPTIONS] -app <app-name> <param-name>
#         Get the value of configuration parameter <param-name> for the
#         application specified by <app-name>.
#
#     configapp [OPTIONS] -app <app-name>
#     <param-name> <value>
#         Set/modify/remove the value of configuration parameter <param-name>
#         for the application specified by <app-name>.
#
# OPTIONS
#     -set
#         Set the configuration paramter value to new <value>
#
#     -add
#         Append the new <value> to configuration parameter value
#
#     -remove
#         Remove <value> from the configuration parameter value
#
#     -info
#         Displays more information like possible values and possible
#         operations about the configuration parameter. A parameter name
#         must be specified when this option is used
#
# EXAMPLE
#     configapp
#        Return the list of all the configurable options for the application.
#
#     configapp -app test build-config
#        Return the current build configuration.
#
#     configapp -app test build-config release
#        Set the current build configuration to release.
#
#     configapp -app test define-compiler-symbols FSBL_DEBUG_INFO
#        Add the define symbol FSBL_DEBUG_INFO to be passed to the compiler.
#
#     configapp -app test -remove define-compiler-symbols FSBL_DEBUG_INFO
#        Remove the define symbol FSBL_DEBUG_INFO to be passed to the compiler.
#
#     configapp -app test compiler-misc {-pg}
#        Append the -pg flag to compiler misc flags.
#
#     configapp -app test -set compiler-misc {-c -fmessage-length=0 -MT"$@"}
#        Set flags specified to compiler misc
#
#     configapp -app test -info compiler-optimization
#        Display more information about possible values/operation and default
#        operation for compiler-optimization.
#
# RETURNS
#     Depends on the arguments specified.
#     <none>
#         List of paramters and description of each parameter
#
#     <parameter name>
#         Parameter value or error, if unsupported paramter is specified
#
#     <parameter name> <paramater value>
#         Nothing if the value is set, or error, if unsupported paramter is
#         specified

