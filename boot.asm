global start

section .text
bits 32
start:
  ; Point the first entry of the level 4 page table to the first entry in the
  ; p3 table
  mov eax, p3_table
  or eax, 0b11
  mov dword [p4_table + 0], eax

  ; Point the first entry of the level 3 page table to the first entry in the
  ; p2 table
  mov eax, p2_table
  or eax, 0b11
  mov dword [p3_table + 0], eax

  ; point each page table level two entry to a page
  mov ecx, 0         ; counter variable
.map_p2_table:
  mov eax, 0x200000  ; 2MiB
  mul ecx ; multiply ecx by eax
  or eax, 0b10000011 ; set 'huge page' bit
  mov [p2_table + ecx * 8], eax
  inc ecx ; increment counter
  cmp ecx, 512 ; compare counter and 512
  jne .map_p2_table ; jump to beginning of loop if not equal

  ; move page table address to cr3
  mov eax, p4_table
  mov cr3, eax

  ; enable PAE
  mov eax, cr4
  or eax, 1 << 5
  mov cr4, eax

  ; set the long mode bit
  mov ecx, 0xC0000080
  rdmsr
  or eax, 1 << 8
  wrmsr

  ; enable paging
  mov eax, cr0
  or eax, 1 << 31
  or eax, 1 << 16
  mov cr0, eax

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

section .bss

align 4096

p4_table:
  resb 4096
p3_table:
  resb 4096
p2_table:
  resb 4096
