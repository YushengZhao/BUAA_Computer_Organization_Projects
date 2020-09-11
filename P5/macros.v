`timescale 1ns / 1ps
//instruction infomation:
`define opJ 6'h2
`define opJal 6'h3
`define opR 6'h0
`define functJr 6'h8
`define opLw 6'h23
`define opSw 6'h2b
`define functAddu 6'h21
`define functSubu 6'h23
`define opOri 6'hd
`define opLui 6'hf
`define opBeq 6'h4
//instruction judging:using name instr
`define isJ (instr[`op]===`opJ)
`define isJal (instr[`op]===`opJal)
`define isJr (instr[`op]===`opR & instr[`funct]===`functJr)
`define isLw (instr[`op]===`opLw)
`define isSw (instr[`op]===`opSw)
`define isOri (instr[`op]===`opOri)
`define isLui (instr[`op]===`opLui)
`define isBeq (instr[`op]===`opBeq)
`define isAddu (instr[`op]===`opR & instr[`funct]===`functAddu)
`define isSubu (instr[`op]===`opR & instr[`funct]===`functSubu)
`define isNop (instr===32'h0)
//struct INFO
`define INFOMAX 350
//about instrction 31:0
`define instr 31:0
`define rs 25:21
`define base 25:21
`define rt 20:16
`define rd 15:11
`define i16 15:0
`define i26 25:0
`define op 31:26
`define funct 5:0
`define shamt 10:6
//about stall 
`define rtuse 35:32
`define rsuse 39:36
`define tnew 43:40
//about forwarding
`define A3 52:48
`define WD 84:53
//others
`define RS 116:85
`define RT 148:117
`define PC 180:149
`define nPC 212:181
`define valid 213
`define EXT 245:214
`define AO 277:246
`define DMD 309:278
`define GRFWE 310
`define tarReg 315:311
