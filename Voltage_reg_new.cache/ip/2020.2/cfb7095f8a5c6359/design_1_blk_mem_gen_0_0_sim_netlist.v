// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Mon Jun 23 21:13:20 2025
// Host        : Azat running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_blk_mem_gen_0_0_sim_netlist.v
// Design      : design_1_blk_mem_gen_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_1_blk_mem_gen_0_0,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    rsta,
    ena,
    wea,
    addra,
    dina,
    douta,
    rsta_busy);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE BRAM_CTRL, READ_WRITE_MODE READ_WRITE, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA RST" *) input rsta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [3:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [31:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  output rsta_busy;

  wire [31:0]addra;
  wire clka;
  wire [31:0]dina;
  wire [31:0]douta;
  wire ena;
  wire rsta;
  wire rsta_busy;
  wire [3:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_doutb_UNCONNECTED;
  wire [31:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "32" *) 
  (* C_ADDRB_WIDTH = "32" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "8" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "1" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "1" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     5.3746 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "1" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "NONE" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "2048" *) 
  (* C_READ_DEPTH_B = "2048" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "1" *) 
  (* C_USE_BYTE_WEA = "1" *) 
  (* C_USE_BYTE_WEB = "1" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "4" *) 
  (* C_WEB_WIDTH = "4" *) 
  (* C_WRITE_DEPTH_A = "2048" *) 
  (* C_WRITE_DEPTH_B = "2048" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4 U0
       (.addra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,addra[12:2],1'b0,1'b0}),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[31:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[31:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(rsta),
        .rsta_busy(rsta_busy),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[31:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web({1'b0,1'b0,1'b0,1'b0}));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.2"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
QGLtnqZzRetDH6gCWT4Js6wuLlZfrNx/VJp3sfR2NF+cxypO5AxN0oDKLJJtmdrtE/ueNDg+Qf7Z
TqBNRojORA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
B6Ger3hRvfjHkaJ+W8639Kl3TzC9TogLuklOXEiMNdc4Im+DjEUzxb3DKlzu0VW3zxZqjJ3+wsW/
LnRmPCESi5Y9eRJaLFXg79EMfoj4X+nTdHAP6yCfltBADKegZ12gpnB/8ey5yn2KA74LUtPC7jna
iyjqSfsWLGnz6UdXzwk=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BX+DxgMPRyZbYojCUR9Sk8Lq+3ZigBz4yMFHQkmurfdfDzyTPJCE827eGiPyTenK1QPVhEtf9g06
0BFXq/0COPuU1BWJwdkz1c4dE6/exDwhvEh+hPx3vRY6z8fDEf6aGVIXrHDvrmddehe7yMSIpo+k
aXHR06EEdfHCFY4TggYwhcJVXjkE+ApsVuyfmEfPmYjo8hCWyQyBsUWIOY03q1+MvUjjsmTwgs9g
fh5MY9ToaLfoJxPKdCpsqrBX4LJ+VDGFlAqIcqHTE2jCmPiToZAFXB7fzf1wDjFCBlJyFVDBGi0i
m+CouLSb7X1mvVhdDZgNrZDJMV688Bu3o54vew==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
DaIU/Ddc8USbZ2mURzujJDWDH1JbHl5tFVOOQ2aVaUPIA71yyE38OXVLEtF8rNmujYH30nEeQ+FV
LVJ16aaHw+iiuaqorTM3K5KLohVlN+WlcEtSXHuPNHjw8ddqtzpaX7pH1zqZH+YmfCL5oaNLqDH4
rkBnUl0/Gm/hzSwKjYhXGQFYQ+gGP99OjXakzrAqZzp/Iq4gt+Z5902/JV9thd/isHQImJ0QyK8M
EKM579iPAfXGes2mbiNYHcvDmSPYmW1zlhOE++N1EKeea7j/msnKeyhlC+hGE4Xfn4TVvqgQexCT
rp/wS/MosY6WH1aKFQlFH2hEppA7KXUaQlvG+w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
XmWoAt4X8hrCJ5yTyug4ajJW5UhfkLNibzjihWzZ4Cr9hQSvWZoTc8rjGsLPbz6Le+/9iI5KxecS
eR0wiAO+G2IkwhZgVBeZdKoFnlnTVAyLjk9wMAFXNyJZM6b1NDbfXlPcUsC6JePvPlwwdWknkSsC
r3KvgkWAS+O3xvRmaNw=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Hw3Y+rShKrXiUViyNU1/O2qv6TgheLHBnFMj1i9MUGrHYqh9pLfLYUgWR7S2vj4jv4S+Ks0BpP4p
dKEqVAFmTCfQNEUHaVcFPkOHgig6L4mhLY6HUUKJoRgiQepgLi/W3V+ZZPQSQFkB3CU4MsJzhXvR
yLcpDriZy8cnAHD87Zi5DrNGBzj3kigJeM0du6lCQbxtF5aEdoaNP+YTnIFtcqYhoYnswQlYt0sV
HKgFA8VzqzL5WYnpH7+1IKmFkJBHkyqHCa9wPK0qCKnxkuDj70YzPVqQ+cocdKU+/gNdpCOdZlci
F2HTxrgfrXndJru3TiDqu4UavqAe0MNuFp3t0w==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XPVggoWL6aXz+MpODTOZhEUQDa0vfEnUDaYeEHXm2vGyqKJujN2c/FFAFBeBYdJATLsIsQ+BqoPc
pBbcFYXDBfOtFIW2dH6Y1OoD65KyJ/hAq8coa21kFgq4hFat5vzZ2iIfkCpTUr4vDZO7Xne8cZO9
WsHffoTCt5rS59wWm2b8I5R8Eh2TUbQg3RCyrcnD66cvcEnlXe1CNMQ4/loVJpA4IBinBf820Wjc
vw2fZbGI0jXC+ACSHOviH63Xwmn+aRV5Ppkup7IYoon/ieKapRQeASu3TTY37xSBXiInSdtMTzJ6
+4GfO4eSHVriCk/sWbuTBzfRzoSShrnHjzz5LA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2020_08", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
L78XuiswVcgO2gtebzL7SA9BC/jJGAM0v6S9pzmyqL+QYzRneiYeGyDmsW33jEVVSTuNjTXkBLY7
yTOKQruatwe4V0OLi6174saSAmPgerSV1GyLP7KhmusLV/N61avC9TPam+tekhKeE0tds4EnJ3et
4JdLh+SE4Z4pcuqCjB5MFneIYKKWDx7siU6oesAQtoSJOesfMchX63MhOjOHFP/ch+1gHv3T45hg
IGF7V7TrdREVE4f9631tlVJ1o2Dypsmo/76Itz5WCGlTMjAnWXN8IXxKN+PZ3dyt1wjrZm2P/td+
xiGszFnSLrRvw/HferwtSmRx8q0fiHZ88roGTw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kDX5kq2QEe25429T6vQqBCFvV1McKTJRYfK99ymVNK2GGvGLXSzgwJHwB2fj9rM0wme3zYYY0vQR
x+9F4L7KLlOVY6qY3LB59uDzyXBI3mMZaS905HXHJkdZHWtQWpfHhl27LqL+8FSluaD6F+KFfYOV
CwIOVuCIp/XjxFXpNBik7YiPt4kHOlDA97IXNLnYUn/g1csGqeNWce4UTne50ggWvLYGbTFGmTjT
N67TpUiGRVRCSv8Tax72GWFIMFZk3Tlp68ZUSQEybZMWX1U9XdMdtxfvNGhf8mi5jQJ2SupSzKu4
T/+53IN9T8aLePAiGBKKG1ZBj4y1ZyYA7XYvjw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 52768)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
