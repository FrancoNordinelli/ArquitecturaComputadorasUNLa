#include <p16f628a.inc>

#DEFINE PULSADOR PORTB,0		;se define al pulsador como pin 0 del puertob
#DEFINE	LED1	 PORTB,1		;idem, pin1
#DEFINE	LED2	 PORTB,2		;idem, pin2

		org 	0x00			;comienzo del programa en dir. 0
		goto	INICIO			
;------------subrturina de Interrupcion-------------------
		org		0x04 
		bcf		INTCON,GIE		;desactiva interrupciones globales
		btfss	INTCON,INTF
		GOTO	SALE
		btfss	LED1
		goto	LED1_APAGADO
		goto	LED1_PRENDIDO

LED1_APAGADO
		btfsc	LED2
		goto 	APAGAR_LED2
		goto	ENCENDER_LED1 ;00;prender led 1		
LED1_PRENDIDO
		btfsc	LED2
		goto	APAGAR_LED1
		goto	ENCENDER_LED2	

ENCENDER_LED1
		bsf		LED1			;se enciende el led1
		goto	SALE

APAGAR_LED1
		bcf		LED1			;se apaga led1
		goto	SALE

ENCENDER_LED2
		bsf		LED2		
		goto	SALE

APAGAR_LED2
		bcf		LED2
		goto	SALE
SALE	
		bsf		INTCON,GIE
		BCF		INTCON,INTF

		RETFIE
				;fin interrupción

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
		movlw	b'10010000'
		movwf	INTCON		;habilita las interrupciones GIE(global) Y INT(RP0)
		goto 	$
		end