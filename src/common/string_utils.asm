.print_str
    LDA #0
    RTS

.read_str
    LDA #0
    LDX #os_read_line MOD 256
    LDY #os_read_line DIV 256
    JSR osword
    RTS

.os_read_line
    EQUW buffer
    EQUB &FF
    EQUB 32
    EQUB 127

.buffer
    EQUB 0
    SKIP &FF