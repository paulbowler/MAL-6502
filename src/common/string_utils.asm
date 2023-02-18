.print_str
	PHA     		; save A
	TYA			    ; copy Y
	PHA  			; save Y
	TXA			    ; copy X
	PHA  			; save X
	TSX			    ; get stack pointer
	LDA $0104,X		; get return address low byte (+4 to correct pointer)
	STA $BC			; save in page zero
	LDA $0105,X		; get return address high byte (+5 to correct pointer)
	STA $BD			; save in page zero
	LDY #$01		; set index (+1 to allow for return address offset)
.prim2
	LDA ($BC),Y		; get byte from string
	BEQ prim3		; exit if null (end of text)
	JSR oswrch		; else display character
	INY			    ; increment index
	BNE prim2		; loop (exit if 256th character)
.prim3
	TYA			    ; copy index
	CLC			    ; clear carry
	ADC $BC			; add string pointer low byte to index
	STA $0104,X		; put on stack as return address low byte (+4 to correct pointer, X is unchanged)
	LDA #$00		; clear A
	ADC $BD		    ; add string pointer high byte
	STA $0105,X		; put on stack as return address high byte (+5 to correct pointer, X is unchanged)
	PLA			    ; pull value
	TAX  			; restore X
	PLA			    ; pull value
	TAY  			; restore Y
	PLA  			; restore A
	RTS

.read_str
    LDA #0
    LDX #os_read_line MOD 256
    LDY #os_read_line DIV 256
    JSR osword
    RTS

.os_read_line
    EQUW string_buffer
    EQUB &FF
    EQUB 32
    EQUB 127

.string_buffer
    EQUB 0
    SKIP &FF