osword = &FFF1
oswrch = &FFEE
osbyte = &FFF4

ORG &2000

.start
    LDA #0      ; Clear buffer from any previous run
    STA buffer
    LDX #0      ; Initialise counter
.prompt
    LDA prompt_text, X
    CMP #0
    BEQ loop
    JSR oswrch
    INX
    JMP prompt
.loop
    JSR read
    BCS exit    ; Exit if escape pressed
    CPY #0      ; If no input do nothing
    BEQ loop

    JSR eval
    JSR print
    JSR print_str
    JMP loop
.read
    LDA #ASC("]")
    JSR oswrch
    LDA #0
    LDX #readline MOD 256
    LDY #readline DIV 256
    JSR osword
    RTS
.eval
    LDX #0
    RTS
.print
    CPY #0
    BEQ done
    LDA buffer,X
    JSR oswrch
    INX
    DEY
    JMP print
    RTS
.done
    LDA #10:JSR oswrch
    LDA #13:JSR oswrch
    RTS
.exit
    LDA #126            ; Acknowledge escape key pressed (*FX 126)
    JSR osbyte
    LDA #10:JSR oswrch  ; Print new line to
    LDA #13:JSR oswrch  ; exit gracefully
    RTS

.readline
    EQUW buffer
    EQUB &FF
    EQUB 32
    EQUB 127
.prompt_text
    EQUS "MAL v1.0"
    EQUB 10:EQUB 13
.buffer
    EQUB 0
    SKIP &FF

.libraries
    INCLUDE "src/common/string_utils.asm"

.end



SAVE "mal6502", start, end 