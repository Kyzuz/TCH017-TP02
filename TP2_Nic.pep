;----------------------    TCH017 - TP02    --------------------------
;--- Cryptage et décryptage avec les générateurs pseudo-aléatoires ---
;---------------------------------------------------------------------
         BR      main

;Message à l'utilisateur (variables globales)
m_init:  "Message original : \x00"
m_carGen:"Caractéristiques du générateur LCG : \x00"   
m_coefA: "Coeff. a : \x00"
m_coefC: "Coeff. c : \x00"
m_grain: "Graine : \x00"
m_tCle:  "Taille de la clé : \x00"
m_chi:   "Message chiffré : \x00"
m_dchi:  "Message déchiffré : \x00"
coefA:   .EQUATE 0
coefC:   .EQUATE 0

;Registre
regs:    .EQUATE 4
regA:    .EQUATE -2
regX:    .EQUATE -4             
;---------------------------------------------------------------------
;FONCTION : Main (prefixe 8)
;Paramètres de : InitGen ----
8_1prm1: .EQUATE 12          ;a
8_1prm2: .EQUATE 10          ;c
8_1prm3: .EQUATE 8           ;graine

;Paramètres de : GenVal -----



;---------------------------------------------------------------------
;FONCTION : InitGen (prefixe 1)
;Spécifie les caractéristiques du générateur et la graine à utiliser
1_prms:  .EQUATE 6
1_arg1:  .EQUATE -2          ;a       
1_arg2:  .EQUATE -4          ;c
1_arg3:  .EQUATE -6          ;graine

InitGen: STA     regA,s      ;Allocation registre
         STX     regX,s
         SUBSP   regs,i
         ;-----------------
         STRO    m_init,d    ;printf("Message original\n")
         
         STRO    m_carGen,d  ;printf("Caractéristiques du générateur\n")
         STRO    m_coefA,d   ;récupération du coefficient a
         DECI    coefA,d
         STRO    m_coefC,d   ;récupération du coefficient c
         DECI    coefC,d

         LDA     coefA,d     ;placement de a sur la pile
         STA     1_arg1,s
         LDA     coefC,d     ;placement de c sur la pile
         STA     1_arg2,s   

         STRO    m_grain,d   ;placement de la graine sur la pile
         DECI    1_arg3,s         
         ;-----------------
         ADDSP   regs,i      ;Libération registre
         LDX     regX,s
         LDA     regA,s
         RET0                ;return
;---------------------------------------------------------------------
GenVal:  






