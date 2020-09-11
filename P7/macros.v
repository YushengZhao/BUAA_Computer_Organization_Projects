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

`define isLb (instr[`op]===6'h20)
`define isLbu (instr[`op]===6'h24)
`define isLh (instr[`op]===6'h21)
`define isLhu (instr[`op]===6'h25)
`define isSb (instr[`op]===6'h28)
`define isSh (instr[`op]===6'h29)
`define isAddi (instr[`op]===6'h8)
`define isAddiu (instr[`op]===6'h9)
`define isAndi (instr[`op]===6'hc)
`define isXori (instr[`op]===6'he)
`define isSlti (instr[`op]===6'ha)
`define isSltiu (instr[`op]===6'hb)
`define isBne (instr[`op]===6'h5)
`define isBlez (instr[`op]===6'h6)
`define isBgtz (instr[`op]===6'h7)

`define isAdd (instr[`op]===`opR&instr[`funct]===6'h20)
`define isSub (instr[`op]===`opR&instr[`funct]===6'h22)
`define isMult (instr[`op]===`opR&instr[`funct]===6'h18)
`define isMultu (instr[`op]===`opR&instr[`funct]===6'h19)
`define isDiv (instr[`op]===`opR&instr[`funct]===6'h1a)
`define isDivu (instr[`op]===`opR&instr[`funct]===6'h1b)
`define isSlt (instr[`op]===`opR&instr[`funct]===6'h2a)
`define isSltu (instr[`op]===`opR&instr[`funct]===6'h2b)
`define isSll (instr[`op]===`opR&instr[`funct]===6'h0)
`define isSrl (instr[`op]===`opR&instr[`funct]===6'h2)
`define isSra (instr[`op]===`opR&instr[`funct]===6'h3)
`define isSllv (instr[`op]===`opR&instr[`funct]===6'h4)
`define isSrlv (instr[`op]===`opR&instr[`funct]===6'h6)
`define isSrav (instr[`op]===`opR&instr[`funct]===6'h7)
`define isAnd (instr[`op]===`opR&instr[`funct]===6'h24)
`define isOr (instr[`op]===`opR&instr[`funct]===6'h25)
`define isXor (instr[`op]===`opR&instr[`funct]===6'h26)
`define isNor (instr[`op]===`opR&instr[`funct]===6'h27)
`define isJalr (instr[`op]===`opR&instr[`funct]===6'h9)
`define isMfhi (instr[`op]===`opR&instr[`funct]===6'h10)
`define isMflo (instr[`op]===`opR&instr[`funct]===6'h12)
`define isMthi (instr[`op]===`opR&instr[`funct]===6'h11)
`define isMtlo (instr[`op]===`opR&instr[`funct]===6'h13)

`define isBltz (instr[`op]===6'h1&instr[`rt]===6'h0)
`define isBgez (instr[`op]===6'h1&instr[`rt]===6'h1)

`define isEret (instr===32'h42000018)
`define isMfc0 (instr[31:21]===11'b010_0000_0000 & instr[10:0]===11'b0)
`define isMtc0 (instr[31:21]===11'b010_0000_0100 & instr[10:0]===11'b0)
//struct INFO
`define INFOMAX 500
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
`define busy 316
`define usingXALU 317
`define excCode 322:318
`define usingEPC 323
//exception
`define _INT 5'd0
`define AdEL 5'd4
`define AdES 5'd5
`define RI 5'd10
`define Ov 5'd12
//boolean
`define true 1'b1
`define false 1'b0