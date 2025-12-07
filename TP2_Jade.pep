  ;----------------------    TCH017 - TP02    --------------------------
;--- Cryptage et decryptage avec les generateurs pseudo-aleatoires ---
;---------------------------------------------------------------------

         BR      deb_msg,i




;----------string input------------------

msgCla:  .EQUATE 200
m_deb:   .ASCII  "Veuillez saisir votre message: \x00"

         
deb_msg: LDX     0,i
         STRO    m_deb,d

msg_in:  CHARI   -1,s
         LDBYTEA -1,s
         
         ANDA    0x00FF,i
         CPA     10,i
         BREQ    end

         CPX     25,i
         BREQ    end

         STBYTEA msgCla,sxf 
         ADDX    1,i
         BR      msg_in
 

end:     LDA     0,i
         ADDX    1,i
         STBYTEA msgCla,sxf
         CHARO   '-',i
         CHARO   '\n',i
         
         
         ;STRO    msgCla,sf




;-----------------------------------------------------------
;----------------------fonction AffMsg----------------------
;-----------------------------------------------------------
;zone parametres
prms_7:  .EQUATE 6
;ZONE variable locale
locs_7:  .EQUATE 2

;parametres/variables
prm1_7:  .EQUATE 6           ; addresse du tab
prm2_7:  .EQUATE 4           ; taille du tab
prm3_7:  .EQUATE 2           ; affichage ASCII ou caracteres(-1)
loc1_7:  .EQUATE 0           ; compteur

         LDA     msgCla,s
         STA     prm1_7,s
         LDA     16,i
         STA     prm2_7,s
         LDA     2,i
         STA     prm3_7,s

AffMsg:  LDA     prm3_7,s
         CPA     -1,i
         BREQ    aff_car,i
         LDA     0,i
         STA     loc1_7,s

affASCII:LDX     loc1_7,s
         CPX     prm2_7,s
         BREQ    f_AffMsg,i

         LDBYTEA prm1_7,sxf
         ANDA    0x00FF,i
         STA     -2,s
         DECO    -2,s
         CHARO   ' ',i

         ADDX    1,i
         STX     loc1_7,s
         BR      affASCII,i
                    

aff_car: STRO     prm1_7,sf 

f_AffMsg:STOP
 
         

.END
         