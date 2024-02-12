
#include "p18f25k40.inc"

; CONFIG1L
  CONFIG  FEXTOSC = OFF         ; External Oscillator mode Selection bits (EC (external clock) above 8 MHz; PFM set to high power)
  CONFIG  RSTOSC = HFINTOSC_64MHZ; Power-up default value for COSC bits (HFINTOSC with HFFRQ = 64 MHz and CDIV = 1:1)

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
  CONFIG  WDTE = OFF             ; WDT operating mode (WDT enabled regardless of sleep)

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
  CONFIG  LVP = OFF              ; Low Voltage Programming Enable bit (Low voltage programming enabled. MCLR/VPP pin function is MCLR. MCLRE configuration bit is ignored)

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




;*******************************************************************************
;
; TODO Step #3 - Variable Definitions
;
; Refer to datasheet for available data memory (RAM) organization assuming
; relocatible code organization (which is an option in project
; properties > mpasm (Global Options)).  Absolute mode generally should
; be used sparingly.
;
; Example of using GPR Uninitialized Data
;
;   GPR_VAR        UDATA
;   MYVAR1         RES        1      ; User variable linker places
;   MYVAR2         RES        1      ; User variable linker places
;   MYVAR3         RES        1      ; User variable linker places
;
;   ; Example of using Access Uninitialized Data Section (when available)
;   ; The variables for the context saving in the device datasheet may need
;   ; memory reserved here.
;   INT_VAR        UDATA_ACS
;   W_TEMP         RES        1      ; w register for context saving (ACCESS)
;   STATUS_TEMP    RES        1      ; status used for context saving
;   BSR_TEMP       RES        1      ; bank select used for ISR context saving
;
;*******************************************************************************

; TODO PLACE VARIABLE DEFINITIONS GO HERE
LED_PIN equ RB0 ; Définir la broche de la LED

INT_VAR UDATA_ACS
NB_LED RES 1
RESULTHI RES 1
RESULTLO RES 1
incre RES 1
 cpt1 RES 1 
 cpt2 RES 2 

;*******************************************************************************
; Reset Vector
;*******************************************************************************

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    BEGIN                   ; go to beginning of program

;*******************************************************************************
; TODO Step #4 - Interrupt Service Routines
;
; There are a few different ways to structure interrupt routines in the 8
; bit device families.  On PIC18's the high priority and low priority
; interrupts are located at 0x0008 and 0x0018, respectively.  On PIC16's and
; lower the interrupt is at 0x0004.  Between device families there is subtle
; variation in the both the hardware supporting the ISR (for restoring
; interrupt context) as well as the software used to restore the context
; (without corrupting the STATUS bits).
;
; General formats are shown below in relocatible format.
;
;------------------------------PIC16's and below--------------------------------
;
; ISR       CODE    0x0004           ; interrupt vector location
;
;     <Search the device datasheet for 'context' and copy interrupt
;     context saving code here.  Older devices need context saving code,
;     but newer devices like the 16F#### don't need context saving code.>
;
;     RETFIE
;
;----------------------------------PIC18's--------------------------------------
;
; ISRHV     CODE    0x0008
;     GOTO    HIGH_ISR
; ISRLV     CODE    0x0018
;     GOTO    LOW_ISR
;
; ISRH      CODE                     ; let linker place high ISR routine
; HIGH_ISR
;     <Insert High Priority ISR Here - no SW context saving>
;     RETFIE  FAST
;
; ISRL      CODE                     ; let linker place low ISR routine
; LOW_ISR
;       <Search the device datasheet for 'context' and copy interrupt
;       context saving code here>
;     RETFIE
;
;*******************************************************************************

; TODO INSERT ISR HERE

;*******************************************************************************
; MAIN PROGRAM
;*******************************************************************************
    
MAIN_PROG CODE                      ; let linker place main program
  
BEGIN
    
; Configuration de l'oscillateur
MOVLB 0x0E ; Sélection de la banque d'adresse
MOVLW b'01110000'
MOVWF OSCCON1 ; Configurer l'oscillateur pour utiliser l'oscillateur externe (EXTOSC)
MOVWF OSCCON2 ; Configurer l'oscillateur pour utiliser l'oscillateur externe (EXTOSC)
MOVLW b'00001000'
MOVWF OSCFRQ ; Configurer la fréquence de l'oscillateur à 64 MHz
 
 BANKSEL ANSELB
 MOVLW 0x0
 MOVWF ANSELB
 ;------------------------------------------------------------------------------
    ;                       Configuration de l'ADC                                |
    ;------------------------------------------------------------------------------
 ; début de la configuration de l'ADC
    MOVLB 0x0F; ;sélection de la banque d?adresse, data sheet ADPCH : F5Fh, donc F adresse de la bank
    MOVLW b'00000101' ; schéma ADC : ANA5 => data sheet ANA 5 = 000101 (p447)
    MOVWF ADPCH, 1 ; sélection du channel ADC
    MOVLW b'00000000' 
    MOVWF ADREF, 1 ; configuration des références analogiques
    MOVLW b'00100000' ; bit 7-6 Unimplemented: Read as ?0? bit 5-0 000001 = FOSC/4
    MOVWF ADCLK, 1 ; configuration de l?horloge de l?ADC : 1µs ? TAD ? 6µs
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
   ; fin de la configuration
;------------------------------------------------------------------------------
    ;                       Configuration de l'PWM                                |
    ;------------------------------------------------------------------------------

    ; début de la configuration
     MOVLW b'00000100'
     MOVWF CCPTMRS ; associe le module CCP2 avec le timer 2
     MOVLB 0x0E ;data sheet bank d'adresse E 
     MOVLW 0x06 ;data sheet p213 CCP2
     MOVWF RC1PPS, 1 ; associe le pin RC1 avec le module CCP2 (voir p.213)
     BSF TRISC, 1 ; désactivation de la sortie PWM pour configuration
     MOVLW d'200'
     MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
     MOVLW b'10001100'
     MOVWF CCP2CON ; configuration du module CCP2 et format des données
     MOVLW b'00000001'
     MOVWF CCPR2H
     MOVLW b'10000000'
     MOVWF CCPR2L ; fixe le rapport cyclique du signal (voir formule p.272)
     MOVLW b'00000001' 
     MOVWF T2CLKCON ; configuration de l?horloge du timer 2 = Fosc/4
     MOVLW b'10110000'
     MOVWF T2CON ; choix des options du timer 2 (voir p.256)
     BCF TRISC, 1 ; activation de la sortie PWM
    ; fin de la configuration
    
; Configuration des ports en sortie
    CLRF TRISC, 1
    
    CLRF TRISB
    CLRF TRISA

    
    
MOVLB 0x0E	
BCF TRISC, 3
; Configuration des bits de configuration du microcontrôleur
LED_PIN equ LATC0 ; Définir la broche de la LED sur LATC0
 BCF TRISC, 2 ;Mettre le port en sortie
 BSF LATC, 2 ;faire tourner le moteur
     
BOUCLE
    CALL degrade_red_1
    
    goto BOUCLE
  
; **********************     LEDS RGB	  **********************    
send0
    BSF LATC, 3
    NOP
    NOP
    NOP
    NOP
    BCF LATC, 3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RETURN 
    ;// 2 coup d'horloge
send1
    BSF LATC, 3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BCF LATC, 3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RETURN
    
; Fonctions RGB
    
degrade_red_1:
    CALL color_red_1
    CALL color_red_2
    CALL color_red_3
    CALL color_red_4
    CALL color_red_5
    RETURN

all_green_1:
    CALL color_green_1
    CALL color_green_1
    CALL color_green_1
    CALL color_green_1
    CALL color_green_1
    RETURN

all_green_2:
    CALL color_green_2
    CALL color_green_2
    CALL color_green_2
    CALL color_green_2
    CALL color_green_2
    RETURN

; Fonction pour allumer toutes les LEDs en vert avec une intensité de niveau 3
all_green_3:
    CALL color_green_3
    CALL color_green_3
    CALL color_green_3
    CALL color_green_3
    CALL color_green_3
    RETURN

all_green_4:
    CALL color_green_4
    CALL color_green_4
    CALL color_green_4
    CALL color_green_4
    CALL color_green_4
    RETURN

; Fonction pour allumer toutes les LEDs en vert avec une intensité de niveau 3
all_green_5:
    CALL color_green_5
    CALL color_green_5
    CALL color_green_5
    CALL color_green_5
    CALL color_green_5
    RETURN

all_green_6:
    CALL color_green_6
    CALL color_green_6
    CALL color_green_6
    CALL color_green_6
    CALL color_green_6
    RETURN

all_green_7:
    CALL color_green_7
    CALL color_green_7
    CALL color_green_7
    CALL color_green_7
    CALL color_green_7
    RETURN

all_green_8:
    CALL color_green_8
    CALL color_green_8
    CALL color_green_8
    CALL color_green_8
    CALL color_green_8
    RETURN

    
    ; Fonctions RGB
    
all_blue_1:
    CALL color_blue_1
    CALL color_blue_1
    CALL color_blue_1
    CALL color_blue_1
    CALL color_blue_1
    RETURN

all_blue_2:
    CALL color_blue_2
    CALL color_blue_2
    CALL color_blue_2
    CALL color_blue_2
    CALL color_blue_2
    RETURN

; Fonction pour allumer toutes les LEDs en bleu avec une intensité de niveau 3
all_blue_3:
    CALL color_blue_3
    CALL color_blue_3
    CALL color_blue_3
    CALL color_blue_3
    CALL color_blue_3
    RETURN

all_blue_4:
    CALL color_blue_4
    CALL color_blue_4
    CALL color_blue_4
    CALL color_blue_4
    CALL color_blue_4
    RETURN

; Fonction pour allumer toutes les LEDs en bleu avec une intensité de niveau 3
all_blue_5:
    CALL color_blue_5
    CALL color_blue_5
    CALL color_blue_5
    CALL color_blue_5
    CALL color_blue_5
    RETURN
    

all_blue_6:
    CALL color_blue_6
    CALL color_blue_6
    CALL color_blue_6
    CALL color_blue_6
    CALL color_blue_6
    RETURN

all_blue_7:
    CALL color_blue_7
    CALL color_blue_7
    CALL color_blue_7
    CALL color_blue_7
    CALL color_blue_7
    RETURN

all_blue_8:
    CALL color_blue_8
    CALL color_blue_8
    CALL color_blue_8
    CALL color_blue_8
    CALL color_blue_8
    RETURN

    
; Fonctions RGB
    
all_red_1:
    CALL color_red_1
    CALL color_red_1
    CALL color_red_1
    CALL color_red_1
    CALL color_red_1
    RETURN

all_red_2:
    CALL color_red_2
    CALL color_red_2
    CALL color_red_2
    CALL color_red_2
    CALL color_red_2
    RETURN

; Fonction pour allumer toutes les LEDs en rouge avec une intensité de niveau 3
all_red_3:
    CALL color_red_3
    CALL color_red_3
    CALL color_red_3
    CALL color_red_3
    CALL color_red_3
    RETURN

all_red_4:
    CALL color_red_4
    CALL color_red_4
    CALL color_red_4
    CALL color_red_4
    CALL color_red_4
    RETURN

; Fonction pour allumer toutes les LEDs en rouge avec une intensité de niveau 3
all_red_5:
    CALL color_red_5
    CALL color_red_5
    CALL color_red_5
    CALL color_red_5
    CALL color_red_5
    RETURN
    

all_red_6:
    CALL color_red_6
    CALL color_red_6
    CALL color_red_6
    CALL color_red_6
    CALL color_red_6
    RETURN

all_red_7:
    CALL color_red_7
    CALL color_red_7
    CALL color_red_7
    CALL color_red_7
    CALL color_red_7
    RETURN

all_red_8:
    CALL color_red_8
    CALL color_red_8
    CALL color_red_8
    CALL color_red_8
    CALL color_red_8
    RETURN   

    
color_off:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN
    

color_green_1:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    CALL send1
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN
    

color_green_2:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    CALL send0
    CALL send1
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN
    
color_green_3:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    CALL send0
    CALL send0
    CALL send1
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN
 
color_green_4:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    CALL send0
    CALL send0
    CALL send0
    CALL send1
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN   
    
color_green_5:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send1
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN    
    
color_green_6:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send1
    CALL send1
    CALL send1
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN    
    
color_green_7:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send1
    CALL send0
    CALL send1
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN   
    
color_green_8:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send1
    CALL send1
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN 
    
    
   
    
color_red_1:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send1
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN
    

color_red_2:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send1
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN
    
color_red_3:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send1
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN
 
color_red_4:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send1
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN   
    
color_red_5:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send1
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN    
    
color_red_6:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send1
    CALL send1
    CALL send1
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN    
    
color_red_7:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send1
    CALL send0
    CALL send1
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN   
    
color_red_8:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send1
    CALL send1
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN 
    
    
    
       
    
    
color_blue_1:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send1
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN
    

color_blue_2:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send1
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN
    
color_blue_3:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send1
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    RETURN
 
color_blue_4:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send1
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    RETURN   
    
color_blue_5:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
   
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send1
    CALL send0
    CALL send0
    CALL send0
    
    RETURN    
    
color_blue_6:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    

    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send1
    CALL send1
    CALL send1
    
    RETURN    
    
color_blue_7:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send1
    CALL send0
    CALL send1
    
    RETURN   
    
color_blue_8:
    ; 8 bits à 1 pour le rouge (intensité faible), suivi de 16 bits à 0 pour le vert et le bleu
    
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
   
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send0
    CALL send1
    CALL send1
    
    RETURN 
    
; ********************** FONCTIONS **********************
    
LED_0
    MOVLW b'00000001'
    MOVWF LATA
    MOVLW d'61' 
    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_1
    MOVLW b'00000011'
    MOVWF LATA
;    MOVLW d'71' 
;    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_2
    MOVLW b'00000111'
    MOVWF LATA
;    MOVLW d'81' 
;    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_3
    MOVLW b'00001111'
    MOVWF LATA
;    MOVLW d'91' 
;    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_4
    MOVLW b'00010000'
    MOVWF LATB
;    MOVLW d'101' 
;    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_5
    MOVLW b'00110000'
    MOVWF LATB
    MOVLW d'111' 
    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_6
    MOVLW b'01110000'
    MOVWF LATB
;    MOVLW d'121' 
;    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_7
    MOVLW b'11110000'
    MOVWF LATB
;    MOVLW d'131' 
;    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_RESET
    CLRF LATA
    CLRF LATB
;    MOVLW d'61' 
;    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    

    
    END