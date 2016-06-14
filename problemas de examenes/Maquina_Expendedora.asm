/**
SEÑALES DE ENTRADA

PUERTO B
M: SE ACTIVA CUANDO EL USUARIO METE UNA MONEDA -->BIT2
S1 Y S0: FORMAN EL SENSOR DE MONEDAS --> BIT1 Y BIT0

SEÑALES DE SALIDA

PUERTO C
P: DEVUELVE EL PRODUCTO --> BIT0
C50: DEVUELVE CAMBIO DE 50 --> BIT1
C1: DA COMO CAMBIO UN EURO --> BIT2
TODO: DEVUELVE TODAS LAS MONEDAS INTRODUCIDAS --> BIT3
FIN: SE ACTIVA TRAS FACILITAREL PRODUCTO --> BIT4

**/


.include "m328pdef.inc"

		MAIN:			CLR R16 ; CONFIGURO R16 A 0
						OUT DDRB, R16; CONFIGURO EL PUERTO B COMO ENTRADA
						SER R16 ; CONFIGURO R16 A 1
						OUT DDRC, R16 ; CONFIGURO EL PUERTO C COMO SALIDA
						CLR R17 ;PARA MONEDAS DE 50C
						CLR R18 ;PARA MONEDAS DE 1C

	ESPERO_MONEDA:		SBIS PINC, 3
						SBIS PINB, 2
						SBIC PINC, 0
						SBIC PINB, 0
						SBI PORTB, 2
						RJMP LLAMA2
						SBIC PINB, 0
						SBIS PINB, 1
						SBI PORTB, 2
						RJMP LLAMA1
						SBIS PINB, 1
						SBIC PORTB, 0
						SBI PORTB, 2
						RJMP LLAMA50
						SBIS PINB, 0
						SBIC PINB, 1
						SBI PORTB, 2
						RJMP ESPERA_MONEDA

	LLAMA50:			SBI PORTB, 1
						CBI PORTB, 0
						INC R17
						CALL COMPRUEBA_MONEDA
						RJMP ESPERA_MONEDA

	LLAMA1:				SBI PORTB, 1
						CBI PORTB, 0
						INC R18
						CALL COMPRUEBA_MONEDA
						RJMP ESPERA_MONEDA

	LLAMA2:				CBI PORTB, 0
						CBI PORTB, 1
						SBI PORTC, 1
						CALL CAMBIO50
						
	LLAMA_OTRA:			SBI PORTB, 1
						SBI PORTB, 0
						SBI PORTC, 3
						RJMP ESPERA_MONEDA

	CAMBIO50:			SBI PORTC, 1
						RJMP FIN

	CAMBIO1:			SBI PORTC, 2
						RJMP FIN

	COMPRUEBA_MONEDA:	CPI R17, 1
						BRGE 1; MAYOR O IGUAL 
						RJMP ESPERA_MONEDA
						RJMP FIN
						CPI R18, 1
						BRGE 1
						RJMP ESPERO_MONEDA
						CALL CAMBIO50
						RJMP FIN

	FIN:				SBI PORTC, 0
						SBI PORTC, 4
						RJMP ESPERA_MONEDA


