;----------------------    TCH017 - TP02    --------------------------
;--- Cryptage et décryptage avec les générateurs pseudo-aléatoires ---
;---------------------------------------------------------------------
         BR      Main 

;Variables globales
coefA:   .WORD 0             ;Coefficient A
coefC:   .WORD 0             ;Coefficient C
terme:   .WORD 0             ;Terme

;Registre
regs:    .EQUATE 4           ;taille des registres
regA:    .EQUATE -2          ;pos. rel. du registre dans la fonction
regX:    .EQUATE -4          ;pos. rel. du registre dans la fonction

;--------------------------------------------------------------------            
;FONCTION : Main (prefixe 8)
;--------------------------------------------------------------------
;Nommage des variables du Main :
;xxxx_XY : X = appelant, Y = appelé, xxxx = type de variable

;Paramètres de : InitGen ----
args_81: .EQUATE 6           ;taille des arguments 
arg1_81: .EQUATE 12          ;a
arg2_81: .EQUATE 10          ;c
arg3_81: .EQUATE 8           ;graine

;Paramètres de : GenVal -----
rets_82: .EQUATE 10          ;valeur de retour = a*Un+c (prochain terme) 

;Paramètres de : GenCle -----
args_83: .EQUATE 4
arg1_83: .EQUATE -2000 
arg2_83: .EQUATE -2200

;Paramètres de : Xor16 ------

;Paramètres de : Chiff ------

;Paramètres de : Dechiff ----

;Paramètres de : AffMsg -----


;--------------------------------------------------------
Main:    STRO    m_init,d    ;printf("Message original\n") 
         ;-- string input --;
         
         STRO    m_carGen,d  ;printf("Caractéristiques du générateur\n")
         STRO    m_coefA,d   ;récupération du coefficient a
         DECI    arg1_81,s   

         STRO    m_coefC, d  ;récupération du coefficient c
         DECI    arg2_81,s

         STRO    m_grain,d   ;récupération de la graine/terme
         DECI    arg3_81,s

         ;-- appel de InitGen --
         STA     arg1_81,s
         STA     arg2_81,s
         STA     arg3_81,s
         SUBSP   args_81,i 
         
         CALL    InitGen,i

         ADDSP   args_81,i
         LDA     arg3_81,s
         LDA     arg2_81,s
         LDA     arg3_81,s
  
         ;------ fin appel -----


;---------------------------------------------------------------------
;FONCTION : InitGen (prefixe 1)
;Spécifie les caractéristiques du générateur et la graine à utiliser
;Récupère et place les caractéristiques du générateur sur la pile
prm1_1:  .EQUATE -2          ;a       
prm2_1:  .EQUATE -4          ;c
prm3_1:  .EQUATE -6          ;graine

InitGen: STA     regA,s      ;Allocation registre
         STX     regX,s
         SUBSP   regs,i
         ;-----------------
         LDA     prm1_1,s    ;placement sur la pile de a
         STA     coefA,d

         LDA     prm2_1,s    ;placement sur la pile de c
         STA     coefC,d

         LDA     prm3_1,s    ;placement sur la pile de la graine/terme
         STA     terme,d
         ;-----------------
         ADDSP   regs,i      ;Libération registre
         LDX     regX,s
         LDA     regA,s
         RET0                ;return
;---------------------------------------------------------------------
;FONCTION : GenVal (prefix 2)
;Produit la prochaine valeur du générateur et la retourne
;Générateur utilisé : LCG
;Variables locales -----
locs_2:  .EQUATE 4           ;taille des variables locales 
loc1_2:  .EQUATE 0           ;compteur
loc2_2:  .EQUATE 2           ;résultat de multiplication (a*Un)

;Variables de retour ---
ret1_2:  .EQUATE 0

GenVal:  STA     regA,s
         STX     regX,s
         SUBSP   regs,i
         SUBSP   locs_2,i
         ;-------------------
         LDA     0,i         ;a*Un = 0              
         STA     loc2_2,s

         LDA     coefA,d         ;compteur = a 
         STA     loc1_2,s

whi_2:   LDA     loc1_2,s    ;while cpt > 0 {
         CPA     0,i

         BREQ    eow_2            ;break 

         LDA     loc2_2,s         ;r_multi += terme
         ADDA    terme,d
         STA     loc2_2,s

         LDA     loc1_2,s         ;cpt--
         SUBA    1,i
         STA     loc1_2,s    ;}

         BR      whi_2       
        
eow_2:   LDA     loc2_2,s    ;a*Un += c
         ADDA    coefC,d 
         STA     ret1_2,s    ;valeur de retour = a*Un + c
         ;-------------------
         ADDSP   locs_2,i
         ADDSP   regs,s 
         LDX     regX,s         
         LDA     regA,s
         RET0                ;return
;---------------------------------------------------------------------
    




;---------------------------------------------------------------------
;Message à l'utilisateur (variables globales)
m_init:  .ASCII  "Message original : \x00" 
m_carGen:.ASCII  "Caractéristiques du générateur LCG : \x00"   
m_coefA: .ASCII  "Coeff. a : \x00"
m_coefC: .ASCII  "Coeff. c : \x00"
m_grain: .ASCII  "Graine : \x00"
m_tCle:  .ASCII  "Taille de la clé : \x00"
m_chi:   .ASCII  "Message chiffré : \x00"
m_dchi:  .ASCII  "Message déchiffré : \x00"

         STOP
         .END



