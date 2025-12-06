  ;----------------------    TCH017 - TP02    --------------------------
;--- Cryptage et decryptage avec les generateurs pseudo-aleatoires ---
;---------------------------------------------------------------------

         BR      AffMsg,i




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
         
         
         STRO    msgCla,sf




;-----------------------------------------------------------
;----------------------fonction AffMsg----------------------
;-----------------------------------------------------------

AffMsg:  
         

.END
         