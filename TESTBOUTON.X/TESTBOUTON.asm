
#include "p18f25k40.inc"

; CONFIG1L
  CONFIG  FEXTOSC = OFF         ; External Oscillator mode Selection bits (Oscillator not enabled)
  CONFIG  RSTOSC = EXTOSC       ; Power-up default value for COSC bits (EXTOSC operating per FEXTOSC bits (device manufacturing default))

; CONFIG1H
  CONFIG  CLKOUTEN = OFF        ; Clock Out Enable bit (CLKOUT function is disabled)
  CONFIG  CSWEN = ON            ; Clock Switch Enable bit (Writing to NOSC and NDIV is allowed)
  CONFIG  FCMEN = ON            ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor enabled)

; CONFIG2L
  CONFIG  MCLRE = EXTMCLR       ; Master Clear Enable bit (If LVP = 0, MCLR pin is MCLR; If LVP = 1, RE3 pin function is MCLR )
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (Power up timer disabled)
  CONFIG  LPBOREN = OFF         ; Low-power BOR enable bit (ULPBOR disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled , SBOREN bit is ignored)

; CONFIG2H
  CONFIG  BORV = VBOR_2P45      ; Brown Out Reset Voltage selection bits (Brown-out Reset Voltage (VBOR) set to 2.45V)
  CONFIG  ZCD = OFF             ; ZCD Disable bit (ZCD disabled. ZCD can be enabled by setting the ZCDSEN bit of ZCDCON)
  CONFIG  PPS1WAY = ON          ; PPSLOCK bit One-Way Set Enable bit (PPSLOCK bit can be cleared and set only once; PPS registers remain locked after one clear/set cycle)
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  DEBUG = OFF           ; Debugger Enable bit (Background debugger disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Extended Instruction Set and Indexed Addressing Mode disabled)

; CONFIG3L
  CONFIG  WDTCPS = WDTCPS_31    ; WDT Period Select bits (Divider ratio 1:65536; software control of WDTPS)
  CONFIG  WDTE = OFF            ; WDT operating mode (WDT Disabled)

; CONFIG3H
  CONFIG  WDTCWS = WDTCWS_7     ; WDT Window Select bits (window always open (100%); software control; keyed access not required)
  CONFIG  WDTCCS = SC           ; WDT input clock selector (Software Control)

; CONFIG4L
  CONFIG  WRT0 = OFF            ; Write Protection Block 0 (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection Block 1 (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection Block 2 (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection Block 3 (Block 3 (006000-007FFFh) not write-protected)

; CONFIG4H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-30000Bh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot Block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)
  CONFIG  SCANE = ON            ; Scanner Enable bit (Scanner module is available for use, SCANMD bit can control the module)
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (HV on MCLR/VPP must be used for programming)

; CONFIG5L
  CONFIG  CP = OFF              ; UserNVM Program Memory Code Protection bit (UserNVM code protection disabled)
  CONFIG  CPD = OFF             ; DataNVM Memory Code Protection bit (DataNVM code protection disabled)

; CONFIG5H

; CONFIG6L
  CONFIG  EBTR0 = OFF           ; Table Read Protection Block 0 (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection Block 1 (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection Block 2 (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection Block 3 (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG6H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot Block (000000-0007FFh) not protected from table reads executed in other blocks)



; VARIABLE DEFINITIONS
GPR_VAR UDATA_ACS   0x00
prog RES 1
isbtn1pressed RES 1
isbtn0pressed RES 1
un RES 1
deux RES 1
trois RES 1
quatre RES 1
cinq RES 1
six RES 1
sept RES 1
huit RES 1
 
 
; RESET VECTOR
RES_VECT CODE 0x0000
    GOTO START0

; MAIN PROGRAM
MAIN_PROG CODE

START0
 
MOVLB 0x0E ; sélection de la banque d?adresse
MOVLW b'00000101'
MOVWF ADPCH, 1 ; sélection du channel ADC
MOVLW b'00000000'
MOVWF ADREF, 1 ; configuration des références analogiques
MOVLW b'00000001'
MOVWF ADCLK, 1 ; configuration de l?horloge de l?ADC : 1?s ? TAD ? 6?s
MOVLW b'11111111'
MOVWF ADPRE, 1 ; configuration du temps de précharge (max. par défaut)
MOVWF ADACQ, 1 ; configuration du temps d?acquisition (max. par défaut)
CLRF ADCAP, 1 ; pas de capacité additionnelle
MOVLW b'00000000'
MOVWF ADACT, 1 ; pas d?activation auto. de l?ADC sur événement
MOVLW b'00000000'
MOVWF ADCON3, 1 ; pas d?interruption sur l?ADC
MOVLW b'00000000'
MOVWF ADCON2, 1 ; configuration de l?ADC en mode basique
MOVLW b'00000000'
MOVWF ADCON1, 1 ; configuration des options de précharge
MOVLW b'10000000'
MOVWF ADCON0 ; configuration générale et format du résultat
 
 movlw 0x07
 movwf TRISB
 movlw 0x30
 movwf TRISA
 BANKSEL ANSELB
 BCF ANSELB,2
 BCF ANSELB,1
 movlw 0x01
 movwf prog
 CLRF isbtn1pressed
 CLRF isbtn0pressed 
 
 movlw b'00000001'
 movwf un
 movlw b'00000010'
 movwf deux
 movlw b'00000100'
 movwf trois
 movlw b'00001000'
 movwf quatre
 movlw b'00010000'
 movwf cinq
 movlw b'00100000'
 movwf six
 movlw b'01000000'
 movwf sept
 movlw b'10000000'
 movwf huit
 
loop 
    BTFSC PORTB,2
    CALL BP1_released
    BTFSS PORTB,2
    goto ife2
    goto suite
ife2
    BTFSS isbtn1pressed,0
    CALL BP1_PRESSED
suite
    BTFSC PORTB,1
    CALL BP0_released
    BTFSS PORTB,1
    goto ife3
    goto suite2
ife3
    BTFSS isbtn0pressed,0
    CALL BP0_PRESSED
    
suite2
    call eteindre_led
    
    movlw 0x01
    CPFSEQ prog
    goto lab1
    CALL prog1
lab1
    movlw 0x02
    CPFSEQ prog
    goto lab2
    CALL prog2
lab2
    movlw 0x03
    CPFSEQ prog
    goto lab3
    CALL prog3
lab3
    movlw 0x04
    CPFSEQ prog
    goto lab4
    CALL prog4
lab4
    movlw 0x05
    CPFSEQ prog
    goto lab5
    CALL prog5
lab5
    movlw 0x06
    CPFSEQ prog
    goto lab6
    CALL prog6
lab6
    movlw 0x07
    CPFSEQ prog
    goto lab7
    CALL prog7
lab7
    movlw 0x08
    CPFSEQ prog
    goto lab8
    CALL prog8
lab8
    
    

    

    goto loop
    
eteindre_led
    movlw 0x00
    movwf LATB
    movlw 0x00
    movwf LATA
    return

    
BP1_PRESSED
    movlw 0X01
    movwf isbtn1pressed
    INCF prog
    movlw 0x09
    CPFSEQ prog
    goto skip
    goto resett
    
resett
    movlw 0x01
    movwf prog
skip
    
    return
BP0_PRESSED
    movlw 0X01
    movwf isbtn0pressed
    DECF prog
    movlw 0x00
    CPFSEQ prog
    goto skip2
    goto resete
resete
    movlw 0x08
    movwf prog
    
skip2
    return

BP1_released
    movlw 0X00
    movwf isbtn1pressed
    return
BP0_released
    movlw 0X00
    movwf isbtn0pressed
    return
    
prog1
    movf un,0
    movwf LATA
    return
prog2
    movf deux,0
    movwf LATA
    return
prog3
    movf trois,0
    movwf LATA
    return
prog4
    movf quatre,0
    movwf LATA
    return
    
prog5
    movf cinq,0
    movwf LATB
    return
prog6
    movf six,0
    movwf LATB
    return
prog7
    movf sept,0
    movwf LATB
    return
prog8
    movf huit,0
    movwf LATB
    return
    end