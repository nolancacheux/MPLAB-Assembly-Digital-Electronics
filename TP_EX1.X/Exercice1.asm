   include "p18F23K20.inc"
   
   RES_VECT  CODE    0x0000            ; processor reset vector
    goto Main
 groupl UDATA 0x100 
compteur RES 10   ; Réserve 10 emplacements mémoire pour 'password'

MAIN_PROG CODE                      ; let linker place main program
    
NLESS:
    MOVLW 0x01
    MOVWF compteur,1

Boucle:
    MOVLW 0x01
    ADDWF compteur,1

    MOVLW 0x09
    CPFSLT compteur,1
    goto NLESS
    goto Boucle

Main:
    MOVLB 0x01
    MOVLW 0x01
    goto Boucle
    END