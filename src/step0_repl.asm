osword = &FFF1
oswrch = &FFEE
osbyte = &FFF4

ORG &2000

.start
    LDA #0      ; Clear input buffer from any previous run
    STA string_buffer
    LDX #0      ; Initialise counter
.prompt
    JSR print_str
    EQUS "MAL v0.1"
    EQUB 10
    EQUB 13
    EQUB 10
    EQUB 13
    EQUB 0
.rep
    JSR read
    BCS exit    ; Exit if escape pressed
    CPY #0      ; If no input do nothing
    BEQ rep
    JSR eval
    JSR print
    JMP rep
.read
    JSR print_str
    EQUS "user>"
    EQUB 0
    JSR read_str
    RTS
.eval
    LDX #0
    JSR lexer
    JSR parse
    RTS
.print
    CPY #0
    BEQ done
    LDA string_buffer,X
    JSR oswrch
    INX
    DEY
    JMP print
    RTS
.done
    LDA #10:JSR oswrch
    LDA #13:JSR oswrch
    RTS
.lexer
    RTS
.parse
    RTS
.exit
    LDA #126            ; Acknowledge escape key pressed (*FX 126)
    JSR osbyte
    LDA #10:JSR oswrch  ; Print new line to
    LDA #13:JSR oswrch  ; exit gracefully
    RTS

.libraries
    INCLUDE "src/common/string_utils.asm"

.end

SAVE "mal6502", start, end 