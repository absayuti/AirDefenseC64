*=$C000                         ; ORG at 49152

; Registers where sprite (screen) position is specified
vic   = 53248
sp0x  = vic
sp0y  = vic+1
sp1x  = vic+2
sp1y  = vic+3
sp2x  = vic+4
sp2y  = vic+5

; We use an unused block at 820-827 to store sprite location on screen
; so that we can poke and peek from BASIC
param   = 820
x_xhair = param
y_xhair = param+1
x_bomb  = param+2
y_bomb  = param+3
x_missl = param+4
y_missl = param+5
flags   = param+6               ; Bomb(1).Explode(2).MisslV(4).MisslH(8).
                                ; Hit(16).Missed(32)

; Min & max allowable values for the bomb and crosshair positions
xmin_xhair =  16
xmax_xhair = 252
ymin_xhair =  40
ymax_xhair = 220
xmin_bomb  =   0
xmax_bomb  = 252
ymin_bomb  =  24
ymax_bomb  = 235
x0_missl   =  24                ; Origin of missile position (x>255)
y0_missl   = 220

; Location where key code is stored when key is pressed
inkey  = 197
; Key codes when specific key is pressed
keyA   = 10
keyZ   = 12
keyLT  = 47
keyGT  = 44
keySP  = 60

; Start of program ------------------------------------------------------------

        LDA flags               ; Check flags
        AND #1                  ; If no bomb dropped, 
        BEQ readinkey           ; skip to read inkey
        
movebomb                        ; Move bomb down
        LDA y_bomb
        ADC #1
        CMP #ymax_bomb
        BCC @placeit
        LDA #2                  ; flag = explode
        STA flags
@placeit
        STA y_bomb
        STA sp1y

        LDA flags               ; Check if missile is launched
        AND #12
        BEQ readinkey           ; If NOT, skip to read inkey

; Missile motion routine ------------------------------------------------------

movemissile
        LDA flags               ; Check if vertical / horizontal motion
        AND #4                  ; If not vertical,
        BEQ misslhoriz          ;     move horizontally
misslvert
        LDA x_missl
        STA sp2x
        LDA y_missl
        SBC #4
        CMP y_xhair
        BCS changemotion
        STA sp2y
        RTS
changemotion
        LDA flags
        AND #251                ; off bit 2 (misslV)
        ORA #8                  ; ON bit 4 (misslH)
        STA flags
misslhoriz
        LDA y_missl
        STA sp2y
        LDA x_missl
        SBC #4
        CMP #4
        BCS missloff
        STA sp2x
                                ; check collision with the bomb
                                ;
        RTS
missloff
        LDA flags
        AND #247                ; off bit 4 (misslH)
        ORA #32                 ; ON bit 5 (Missed)
        STA flags        
        RTS

; Read inkey and move crosshair -----------------------------------------------                        

readinkey
        LDA inkey               ; Check key @ 197

moveup                          ; if 'A' move crosshair up
        CMP #keyA       
        BNE movedown
        LDA y_xhair
        SBC #2
        CMP #ymin_xhair         ; Greater than Y.min?
        BCS @placeit
        LDA #ymin_xhair
@placeit
        STA y_xhair
        STA sp0y 
        RTS
 
movedown                        ; if 'Z' move crosshair down
        CMP #keyZ       
        BNE moveleft
        LDA y_xhair
        ADC #2
        CMP #ymax_xhair         ; Less than Y.max?
        BCC @placeit
        LDA #ymax_xhair
@placeit
        STA y_xhair
        STA sp0y 
        RTS
 
moveleft                        ; if '<' move crosshair left
        CMP #keyLT       
        BNE moveright
        LDA x_xhair
        SBC #2
        CMP #xmin_xhair         ; Less than Y.max?
        BCS @placeit
        LDA #xmin_xhair
@placeit
        STA x_xhair
        STA sp0x 
        RTS
 
moveright                       ; if '>' move crosshair right
        CMP #keyGT       
        BNE fire
        LDA x_xhair
        ADC #2
        CMP #xmax_xhair         ; Less than Y.max?
        BCC @placeit
        LDA #xmax_xhair
@placeit
        STA x_xhair
        STA sp0x 
        RTS

fire                            ; if {space} fire missile
        CMP #keySP       
        BNE done
        LDA #4                  ; flag = launch missile, vertical motion
        STA flags
done
        RTS

; ------------------------------ end ------------------------------------------