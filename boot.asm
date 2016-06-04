global start

section .text
bits 32
start:
;     size place      thing
;     |    |          |
;     V    V          V
  mov word [0xb8000], 0xDB48 ; H
  mov word [0xb8002], 0xDB65 ; e
  mov word [0xb8004], 0xDB6c ; l
  mov word [0xb8006], 0xDB6c ; l
  mov word [0xb8008], 0xDB6f ; o
  mov word [0xb800a], 0xDB2c ; ,
  mov word [0xb800c], 0xDB20 ;
  mov word [0xb800e], 0xDB77 ; w
  mov word [0xb8010], 0xDB6f ; o
  mov word [0xb8012], 0xDB72 ; r
  mov word [0xb8014], 0xDB6c ; l
  mov word [0xb8016], 0xDB64 ; d
  mov word [0xb8018], 0xDB21 ; !
  hlt
