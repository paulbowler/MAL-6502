osword = &FFF1
oswrch = &FFEE

ORG &2000         ; code origin

.start
    LDX #0
.prompt
    LDA prompt_text, X
    CMP #0
    BEQ read
    JSR oswrch
    INX
    JMP prompt
.read
    LDA #ASC("]")
    JSR oswrch
    LDA #0
    LDX #readline MOD 256
    LDY #readline DIV 256
    JSR osword
    BCS exit
.eval
    LDX #0
.print
    CPY #0
    BEQ loop
    LDA buffer,X
    JSR oswrch
    INX
    DEY
    JMP print
.loop
    LDA #10:JSR oswrch
    LDA #13:JSR oswrch
    JMP read
.exit
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
.end

SAVE "mal6502", start, end 