# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BITS_PER_ELEMENT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXI_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MATRIX_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAX_MATRICES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_ROWS" -parent ${Page_0}


}

proc update_PARAM_VALUE.BITS_PER_ELEMENT { PARAM_VALUE.BITS_PER_ELEMENT } {
	# Procedure called to update BITS_PER_ELEMENT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BITS_PER_ELEMENT { PARAM_VALUE.BITS_PER_ELEMENT } {
	# Procedure called to validate BITS_PER_ELEMENT
	return true
}

proc update_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to update C_S_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.MATRIX_SIZE { PARAM_VALUE.MATRIX_SIZE } {
	# Procedure called to update MATRIX_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MATRIX_SIZE { PARAM_VALUE.MATRIX_SIZE } {
	# Procedure called to validate MATRIX_SIZE
	return true
}

proc update_PARAM_VALUE.MAX_MATRICES { PARAM_VALUE.MAX_MATRICES } {
	# Procedure called to update MAX_MATRICES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_MATRICES { PARAM_VALUE.MAX_MATRICES } {
	# Procedure called to validate MAX_MATRICES
	return true
}

proc update_PARAM_VALUE.NUM_ROWS { PARAM_VALUE.NUM_ROWS } {
	# Procedure called to update NUM_ROWS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_ROWS { PARAM_VALUE.NUM_ROWS } {
	# Procedure called to validate NUM_ROWS
	return true
}


proc update_MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.MATRIX_SIZE { MODELPARAM_VALUE.MATRIX_SIZE PARAM_VALUE.MATRIX_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MATRIX_SIZE}] ${MODELPARAM_VALUE.MATRIX_SIZE}
}

proc update_MODELPARAM_VALUE.NUM_ROWS { MODELPARAM_VALUE.NUM_ROWS PARAM_VALUE.NUM_ROWS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_ROWS}] ${MODELPARAM_VALUE.NUM_ROWS}
}

proc update_MODELPARAM_VALUE.MAX_MATRICES { MODELPARAM_VALUE.MAX_MATRICES PARAM_VALUE.MAX_MATRICES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_MATRICES}] ${MODELPARAM_VALUE.MAX_MATRICES}
}

proc update_MODELPARAM_VALUE.BITS_PER_ELEMENT { MODELPARAM_VALUE.BITS_PER_ELEMENT PARAM_VALUE.BITS_PER_ELEMENT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BITS_PER_ELEMENT}] ${MODELPARAM_VALUE.BITS_PER_ELEMENT}
}

