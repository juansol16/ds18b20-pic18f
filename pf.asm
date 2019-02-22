 LIST P=18F4550
 RADIX HEX
#include <C:\Program Files\Microchip\MPLABX\v3.20\mpasmx\p18f4550.inc>

;------------------------------------------------
;palabras de configuracion

 
  CONFIG  PLLDIV = 5            ; PLL Prescaler Selection bits (Divide by 5 (20 MHz oscillator input))
  CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
  CONFIG  USBDIV = 1            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes directly from the primary oscillator block with no postscale)

; CONFIG1H
  CONFIG  FOSC = HS             ; Oscillator Selection bits (HS oscillator (HS))
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  BORV = 0              ; Brown-out Reset Voltage bits (Maximum setting)
  CONFIG  VREGEN = OFF          ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 1             ; Watchdog Timer Postscale Select bits (1:1)

; CONFIG3H
  CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = OFF           ; MCLR Pin Enable bit (RE3 input pin enabled; MCLR pin disabled)

; CONFIG4L
  CONFIG  STVREN = OFF          ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will not cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port (ICPORT) Enable bit (ICPORT disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) is not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) is not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) is not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) is not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) is not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM is not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) is not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) is not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) is not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) is not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) are not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) is not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM is not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) is not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) is not protected from table reads executed in other blocks)


Cont EQU 0X00 ;registro que sirve para verificar si ya pasaron los 30 segundos
  
;-----------------
  ORG 0x00	; inicia el codigo
  goto inicio	    
  ORG 0x08	    ;se dirige a la direccion 8 para los desbordes de baja interrupcion 
  goto int_time1
  
inicio:
    
 clrf Cont, 0    ;limpia y pone en 0 rodo el registro Cont
 movlw 0xC0; Configuración "11000000" del registro TRISC (Habilita los pines RC6 y RC7)
 movwf TRISC; mueve la configuración anterior a TRISC
  
;CONFIGURACIÓN DE LA VELOCIDAD
 movlw 0x08; Configuración para BAUDCON "00001000"
 movwf BAUDCON; Se especifica en el bit 3 que la velocidad es de 16 bits
 
   
 movlw 0x02; Configuración para SPBRGH "00000010"
 movwf SPBRGH; Se mueve la configuración "00000010" a SPBRGH
 movlw 0x08; Configuración para SPBRG "00001000"
 movwf SPBRG; Se mueve la configuración "00001000" a SPBRG

 
;CONFIGURACIÓN DEL TRANSMISOR
 movlw 0x2C; Configuración de TXSTA "00101100" (Habilita la transmisión y la alta velocidad)
 movwf TXSTA; mueve la configuración "00101100" al registro TXSTA, en el bit 2 se especifica la activación alta velocidad
    
;CONFIGURACIÓN DEL RECEPTOR
 movlw 0x90; Configuración para RCSTA "10010000" (Habilita el receptor)
 movwf RCSTA; mueve la configuración "10010000" al registro RCSTA  
 
 ;ANALOGO DIITAL
 movlw 0x0E 
 movwf ADCON1, 0
;00 BIT 7 Y 6 SIN IMPLEMENTAR
;0 BIT 5 VCFG1, PONE EN REFERENCIA COMO VREF+ A VDD
;0 BIT 4 VCFG0, PONE EN REFERENCIA COMO VREF- A VSS
;1110 BIT 3-0 SELECCIONA EL PIN RAD COMO ANALOGO

 movlw 0x01
 movwf ADCON0, 0
;00 BIT 7 Y 6 SIN IMPLEMENTAR
;0000 BIT 5-2 SELLECIONA EL PIN ANO
;0 BIT 1 LA CONVERSION no ESTA EN CURSO
;1 BIT 0 ACTIVA EL CONVERTIDOR A/D

 movlw 0x35
 movwf ADCON2, 0
;0 establece a la izquierda para usar solo 8 bits
;0 bit 6 sin implementar
;010 bit 5-3 para seleccionar el tiempo de adquisicion 4 TAD
;101 bit 3-0 para seleccionar el tiempo de conversion Fosc/8
 
 
    bsf PIE1,TMR1IE, 0  ;activa las interrupciones
    bcf RCON, IPEN, 0   ;descativa prioridad
    bcf PIR1, TMR1IF, 0 ;pone en cero la nadera 
    bsf INTCON, GIE, 0  ;
    bsf INTCON, PEIE, 0
    
;----------------configurar el timer1----------------------
    movlw b'10001010'
    movwf T1CON, 0
    movlw b'00000000'
    movwf TMR1H, 0
    movlw b'00000000'
    movwf TMR1L, 0
;----------Configuro puerto D como salida-------------------
  movlw b'11111100'
  movwf TRISD, 0       ;configuro pines 0, 1 
  
  bsf T1CON,TMR1ON,0 ;inicio el timer
  
Tiempo:
       bra Tiempo ; espera el desborde por tiempo
       
int_time1:
       movlw b'00000001'  ;numero 15 en binario, 
       CPFSEQ Cont, 0
       bra aumenta
       clrf Cont, 0  ;regresa ne ceros el regusro para volver a contar
       bsf ADCON0, GO  ;se le indica que comienze la conversion, 
       goto conv_AD
       
aumenta:
    movlw b'00000001'
    addwf Cont,1,0
    movlw b'00000000'
    movwf TMR1H,0
    movlw b'00000000'
    movwf TMR1L,0   
    bcf PIR1,TMR1IF,0 
    retfie 
  
conv_AD: 
    btfsc   ADCON0,GO   ;verifica si esta en ya se termino de convertir el valor A-D
    bra conv_AD		;si aun no, regresa a conv_AD
    movf ADRESH,0,0	;Si ya termino, manda el valor a w
    
envia:
    btfss PIR1,TXIF	;verifica si el registro TXREG esta ocupado
    bra envia		;si esta ocupado, regresa a esperar que se desocupe
    movwf TXREG		;si no manda el valor 
    bsf   ADCON0,ADON	;activa otra vez el convertidor analogo_Digital
    bcf PIR1,TMR1IF,0 
    
Recepcion:            ;apartado para la recepcion del dato 
    btfss PIR1,RCIF	;espera a que lleguen los datos
    bra Recepcion	;itera hasta que llegue un dato
    btfss RCSTA,FERR	;verifica si no hubo error de formato 
    bra noFERR		; sino hubo salta
    movf RCREG,W	; si hubo mueve el dato recibido de a w
    bra Recepcion	;regresa esperando oto dato
    
noFERR:
    btfss RCSTA,OERR	;verifica si hubo algun error de sobreescritura
    bra noOERR		;sino hubo, salta  
    bcf RCSTA,CREN,0	; si hubo, deshabilita la recepcion
    nop			;espera una accion
    bsf RCSTA,CREN,0	;y se vuelve a activar
    bra Recepcion	;regresa esperando otro dato no erroneo
    
noOERR:
    movf RCREG, 0, 0	;mueve el valor obtenido a w
    movwf LATD, 0	;mueve el valor de w a LATD para prender el led
    movlw b'00000000'	
    movwf TMR1H,0    
    movlw b'00000000'
    movwf TMR1L,0   
    bcf PIR1,TMR1IF,0	;pone en cero la bandera de interrupciones
    retfie  
       END
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  