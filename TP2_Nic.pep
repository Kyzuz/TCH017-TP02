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
coefA:   .WORD 0
coefC:   .WORD 0
terme:   .WORD 0

;Registre
regs:    .EQUATE 4
regA:    .EQUATE -2
regX:    .EQUATE -4 
;--------------------------------------------------------------------            
;FONCTION : Main (prefixe 8)
;--------------------------------------------------------------------
;Paramètres de : InitGen ----
8_1prm1: .EQUATE 12          ;a
8_1prm2: .EQUATE 10          ;c
8_1prm3: .EQUATE 8           ;graine

;Paramètres de : GenVal -----


;--------------------------------------------------------
main:    STRO    m_init,d    ;printf("Message original\n")

         
         STRO    m_carGen,d  ;printf("Caractéristiques du générateur\n")
         STRO    m_coefA,d   ;récupération du coefficient a
         DECI    8_1prm1,s

         STRO    m_coefC, d
         DECI    8_1prm2,s

         STRO    m_grain,d
         DECI    8_1prm3,s

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
         LDA     1_arg1,s    ;placement sur la pile de a
         STA     coefA,d

         LDA     1_arg2,s    ;placement sur la pile de c
         STA     coefC,d

         LDA     1_arg3,s    ;placement sur la pile de terme/graine
         STA     terme,d
         ;-----------------
         ADDSP   regs,i      ;Libération registre
         LDX     regX,s
         LDA     regA,s
         RET0                ;return
;---------------------------------------------------------------------
;FONCTION : GenVal (prefix 2)
;Produit la prochaine valeur du générateur et la retourne
;Générateur LCG
;Variables locales -----
2_locs:  .EQUATE 6           ;taille des variables locales
2_loc1:  .EQUATE 0           ;compteur
2_loc2:  .EQUATE 2           ;résultat de multiplication (a*Un)
2_loc3:  .EQUATE 4           ;

;Variables de retour ---
2_rets:  .EQUATE 2
2_ret1:  .EQUATE 0

;-----------------------
GenVal:  LDA     0,i                     
         STA     2_loc1,s

         LDA     a,d         ;Mettre (a) dans le compteur
         STA     cpt,d

multi:   LDA     cpt,d       ;while cpt > 0
         CPA     0,i

         BREQ    fin_mul          ;break

         LDA     r_multi,d        ;r_multi += terme
         ADDA    terme,d
         STA     r_multi,d

         LDA     cpt,d            ;cpt--;
         SUBA    1,i
         STA     cpt,d

         BR      multi       
        
fin_mul: LDA     r_multi,d   ;r_multi += c
         ADDA    c,d          
          

         RET0         






