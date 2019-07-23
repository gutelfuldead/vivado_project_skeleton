# quickie mode
program_flash -f ./OUTPUT.bin -offset 0 -flash_type qspi_single -cable type xilinx_tcf url TCP:127.0.0.1:3121

# blank check and verify image
# program_flash -f ./loadScripts/OUTPUT.bin -offset 0 -flash_type qspi_single -blank_check -verify -cable type xilinx_tcf url TCP:127.0.0.1:3121

# specific digilent hw id
# program_flash -f /home/labuser/svn/spawar_htcp_13140/sw/trunk/hwLoader/src/zed0.nocsp.bin -offset 0 -flash_type qspi_single -blank_check -verify -cable type xilinx_tcf url TCP:127.0.0.1:3121 esn Digilent/210299A1FC0D/ -debugdevice deviceNr 2  
