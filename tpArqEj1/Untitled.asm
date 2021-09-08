#include <p16f628a.inc>
list p=16f628a

#DEFINE PULSADOR PORTB,0		;se define al pulsador como pin 0 del puertob
#DEFINE	LED1	 PORTB,1		;idem, pin1
#DEFINE	LED2	 PORTB,2		;idem, pin2

CONT	equ		.250

		org 	0x00			;comienzo del programa en dir. 0
		goto	INICIO			

;------------subrturina de Interrupcion------------------- 
ENCENDIDO
		org		0x04			;dir. comienzo de rutina 
		bcf		STATUS,RP0		;selección banco 0 de mem.
		bcf		INTCON,GIE		;se inhabilitan interrupciones globales
		bcf		INTCON,INTE		;idem, para RB0		
		bsf		PULSADOR		;se pone en 1 el bit 0 del PORTB	 
		bsf		LED1			;se enciende led1
		bsf		LED2			;idem led2
		bsf		INTCON,GIE		;se habilitan interrupciones globales
		btfsc	PULSADOR		;¿se presiono el pulsador?
		goto	0X04			;no, vuelve a ENCENDIDO
		goto 	INICIO			;sí, va a inicio
		return
;------------programa principal--------------
INICIO
		bsf     STATUS,RP0		;selección banco 1 mem.
		bcf 	OPTION_REG,NOT_RBPU;se activan pull-ups del pic
		movlw	b'00000001'
		movwf	TRISB			;se pone como entrada el bit0 
		bcf		STATUS,RP0		;selección banco 0 mem.
		bcf		PULSADOR		;se pone en 0 bit 0 PORTB
		bcf		LED1			;se apaga el led1
		bcf		LED2			;idem led2
		btfss	PULSADOR		;¿el pulsador fue presionado?
		goto	INICIO			;no, regreso a INICIO
		call	ENCENDIDO		;sí,llamada a sub-rutina
		movlw	b'10010000'
		movwf	INTCON		;habilita las interrupciones GIE(global) Y INT(RP0)
		goto 	$

DELAY_1ms	
		movlw	CONT
LOOP	nop
		decfsz	CONT,w
		goto 	LOOP
		return	

DELAY_250ms
		movlw	CONT	
LOOP2	call 	DELAY_1ms
		decfsz	CONT,w
		goto 	LOOP2
		return

		end	