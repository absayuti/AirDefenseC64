!------------------------------------------------------------------------------
!- Air Defense
!- Inspired by a type-in and article in COMPUTE! Apr 1983
!- AB Sayuti HM Saman
!- Started on 30th July 2018
!-
!- V 1.06 - 25th Aug 2018 - Adding scoring system
!-                            - Level 1
!-                              Destroy a bomb --> 10 pts
!-                              Destroy 5 bombs --> up a level
!-                              5 damages --> game over
!-                            - Level 2
!-                              Destroy a bomb --> 20 pts
!-                              Destroy 5 bombs --> up a level
!-                              5 damages --> game over
!-                            - Level 3
!-                              Destroy a bomb --> 30 pts
!-                              Destroy 5 bombs --> up a level
!-                              5 damages --> game over
!-                            - Level 4
!-                              Destroy a bomb --> 40 pts
!-                              Destroy 5 bombs --> up a level
!-                              5 damages --> game over
!-                            - Level 5
!-                              Destroy a bomb --> 50 pts
!-                              5 damages --> game over!-
!-                        - Add explosion graphics/sprite
!-                        - Remove building when it get bomb
!-                          (may need to place bomb.Y @ *8.pixels)
!-        - To do: - Fix the "bomb destroyed" bug, in the ML routine
!-
!------------------------------------------------------------------------------
!-   Main routine + game subroutines
!------------------------------------------------------------------------------
100 rem *********************************
110 rem         Setup game data
120 rem ---------------------------------
130 sp=txt+1016     :rem SPRITE SHAPE POINTER
140 poke sp,48      :rem sp0 -> (base)+3072+64*0
150 poke sp+1,49    :rem sp1 -> (base)+3072+64*1
160 poke sp+2,53    :rem sp2 -> (base)+3072+64*5
170 poke vic+21,7   :rem SWITCH ON SPRITE 0,1,2
180 poke vic+39,1   :rem sp0 colour
190 poke vic+40,2   :rem sp1 colour
200 poke vic+41,7   :rem sp2 colour
210 rem *** Control block at 820-827 ***
220 x0=820  : y0=x0+1  :rem for X&Y of sprite 0 (crosshair)
230 x1=x0+2 : y1=x1+1  :rem for X&Y of sprite 1 (bomb)
240 x2=x0+4 : y2=x2+1  :rem for X&Y of the missile
250 flg = x0+6         :rem Flags for games' "state machine"
260 rem * Flags: N/A MIS HIT MH2 MH1 MV  EXP BOM
270 rem * Bit# :  7   6   5   4   3   2   1   0
280 rem * Value: 128 64  32  16   8   4   2   1
290 dim bld(15) : dim bs(38)
300 gosub 1470         :rem GAME INTRO
310 rem ********************************
320 rem        INIT/RESET Game
330 rem --------------------------------
340 lvl=1              :rem Game level
350 sc=0               :rem Score, Hi-Score
360 dm=0 : ht=0 : ms=0 :rem Damages, hits, misses
370 gosub 1730         :rem 'DRAW' game screen
380 gosub 2130         :rem Print scores
390 tm = 200           :rem Timer for start of bomb drop
400 poke flg,0         :rem Reset all flags/parameters
410 cx=152 : cy=152    :rem Crosshair initial position
420 poke x0,cx : poke y0,cy
430 gosub 2050         :rem Missile initial position
440 rem ********************************
450 rem          MAIN ROUTINE
460 rem --------------------------------
470 sys 49152
480   rem print"{home}             {left*15}F"peek(flg)"x2"peek(x2)"C"peek(vic+30)
490   rem if peek(flg)=8 then for ii=0 to 200 : next
500   if peek(flg)and 2 then 580   :rem if bomb damages building
510   if peek(flg)and 32 then 670  :rem if missile hit bomb
520   if peek(flg)and 64 then 820  :rem if missile missed it
530   tm=tm-1
540   if tm=0 then 930
550   goto 470
560 rem --------------------------------
570 rem Bomb damages building
580   poke vic+3,240      :rem show sprite 
582   gosub 1010          :rem Explosion
585   gosub 1130          :rem Building collapsing
588   poke vic+3,0        :rem hide bomb sprite
590   poke flg,0          :rem Bom drop paused
600   tm = (5-lvl)*50     :rem Reset bomb drop timer
610   dm = dm+1           :rem Damages ++
620   gosub 2130
630   if dm>4 then 1590
640   goto 470
650 rem --------------------------------
660 rem Bomb is intercepted
670   print"{home}{down}BOMB DESTROYED"
680   gosub 1010
690   poke flg,0          :rem Pause bomb drop
700   poke vic+3,0        :rem Hide bomb
710   tm = (5-lvl)*40+10  :rem Reset timer
720   gosub 2050          :rem Reset missile position
730   print"{home}{down}              "
740   ht=ht+1 : sc=sc+10*lvl    :rem Hit & score +
750   if sc>hi then hi=sc
760   gosub 2130
770   if ht<5 then 470
780   lvl=lvl+1 : dm=0 : gosub 1730 :rem up a level, redraw screen
790   goto 470
800 rem --------------------------------
810 rem Missile missed the bomb
820   print"{home}{down}MISSED"
830   for ii=0 to 500 : next
840   poke flg,peek(flg)and 191 :rem OFF the flag
850   gosub 2050          :rem Reset missile position
860   print"{home}{down}       "
870   ms = ms+1
880   gosub 2130
890   if ms>4 then 1590
900   goto 470
910 rem --------------------------------
920 rem Timer==0 -> drop a bomb
930   b=int(rnd(1)*15)+1 : bx = b*16+4 : by = 0
935   poke sp+1,49
940   poke x1,bx : poke vic+2,bx : poke y1,by
950   poke flg,peek(flg)or1
960   gosub 1400           :rem warning sound
970   goto 470
980 rem ********************************
990 rem         BOMB EXPLOSION!!
1000 rem --------------------------------
1010 gosub 1250      :rem Explosion sound
1020 for i=1 to 3
1025   poke sp+1,49+i
1030   poke vic+32,2 : poke vic+33,2
1040   for j=1 to 30: next j
1050   poke vic+32,14 : poke vic+33,14
1060   for j=1 to 30: next j
1070 next
1090 return
1100 rem ********************************
1110 rem       Building collapsing
1120 rem --------------------------------
1130 xx=txt+14*40-2 : cc=co+14*40-2
1150 r = 1
1160   if (peek(cc+r*40+b*2)and15)<>0 then 1190
1170   poke xx+r*40+b*2,160 : poke xx+r*40+b*2+1,160
1180   poke cc+r*40+b*2,6 : poke cc+r*40+b*2+1,6
1190   r=r+1 : if r<10 then 1160
1200   poke xx+r*40+b*2,102 : poke xx+r*40+b*2+1,102
1210 return
1220 rem ********************************
1230 rem        Explosion Sound
1240 rem --------------------------------
1250 so=54272
1260 poke so+24,0        :rem off sound first
1270 poke so+5,16*0+0    :rem Set Attack/decay for voice I
1280 poke so+6,16*15+13  :rem Set Sustain/Release for voice I
1290 poke so+4,128+1     :rem noise + gate on
1300 poke so+24,15       :rem Set volume 15
1310 fq=1000             :rem frequency
1320 hf=int(fq/256) : lf=fq-hf*256
1330 poke so+0,lf : poke so+1,hf :rem high.and low frequencies for voice 1
1340 for i=0 to 100 : next
1350 poke so+4,128       :rem noise + gate off
1360 return
1370 rem ********************************
1380 rem         Warning Sound
1390 rem --------------------------------
1400 so=54272
1410 for i=0to24 : poke so+i,0:next
1420 rem
1430 poke so+24,15       :rem Set volume 15
1440 poke so+5,16*0+0    :rem Set Attack/decay for voice I
1450 poke so+6,16*15+11  :rem Set Sustain/Release for voice I
1460 fq=8000             :rem frequency
1470 hf=int(fq/256) : lf=fq-hf*256
1480 poke so+0,lf : poke so+1,hf :rem high.and low frequencies for voice 1
1490 for j=1 to 2
1500   poke so+4,32+1      :rem sawtooth + gate on
1510   for i=1 to 100 : next
1520   poke so+4,32       :rem sawtooth + gate off
1530   for i=1 to 300 : next
1540 next
1550 return
1560 rem ********************************
1570 rem             GAME OVER
1580 rem --------------------------------
1590 print"{clear}{down}    g a m e  o v e r"
1600 print"{down*3}destroyed";ht
1610 print"{down*2}missed";ms
1620 print"{down*2}total score";sc
1630 for i=1 to 30: get d$: next
1640 print"{down*4}press {reverse on}p{reverse off} to play again"
1650 get d$: if d$="" then 1650
1660 if d$="p" then 340
1670 end
1680 return
1690 rem ********************************
1700 rem DRAW GAME SCREEN Place buildings
1710 rem --------------------------------
1720 rem ******* the background ******
1730 for i=1 to 38
1740   bs(i)=3+int(6*rnd(1))
1750 next
1760 bs(1+30*rnd(1))=10
1770 bs(1+30*rnd(1))=11
1780 bs(1+30*rnd(1))=12
1790 print"{clear}{down*10}{blue}"
1800 for r=12 to 1 step -1
1810   print
1820   for i=1 to 38
1830     if bs(i)<r then print" "; : goto 1850
1840     print "{reverse on} {reverse off}";
1850   next
1860 next
1870 rem ******** the buildings *********
1880 for i=1 to 15
1890   bld(i)=1+int(6*rnd(1))
1900 next
1910 print"{home}{down*15}{black}"
1920 for r=7 to 1 step -1
1930   print
1940   for i=1 to 15
1950     if bld(i)<r then print"{right}{right}"; : goto 1980
1960     if rnd(1)>0.5 then print "{reverse on}  {reverse off}"; : goto 1980
1970     print "{reverse on}{cm d} {reverse off}";
1980   next
1990 next
2000 print : print"{reverse on}{space*39}{left} {reverse off}";
2010 return
2020 rem ********************************
2030 rem    INIT/RESET MISILE LOCATION
2040 rem --------------------------------
2050   mx=40  : my=222    :rem Reset missile position
2060   poke sp+2,53       :rem Reset its shape
2070   poke vic+16,4 : poke x2,mx : poke y2,my :rem Place missile again
2080   poke vic+4,mx : poke vic+5,my
2090   return
2100 rem ********************************
2110 rem    Print Scores & Status
2120 rem --------------------------------
2130   print"{home}{right*31}{blue}{176}{096}{096}{096}{096}{096}{096}{174}"
2140   print"{right*31}{125}SCORE {125}"
2150   print"{right*31}{125}      {125}{left*7}"sc
2160   print"{right*31}{171}{096}{096}{096}{096}{096}{096}{179}"
2170   print"{right*31}{125}HIGH  {125}"
2180   print"{right*31}{125}      {125}{left*7}"hi
2190   print"{right*31}{171}{096}{096}{096}{096}{096}{096}{179}"
2200   print"{right*31}{125}DAMAGE{125}"
2210   print"{right*31}{125}      {125}{left*4}"dm
2220   print"{right*31}{171}{096}{096}{096}{096}{096}{096}{179}"
2230   print"{right*31}{125}LEVEL {125}"
2240   print"{right*31}{125}      {125}{left*4}"lvl
2250   print"{right*31}{173}{096}{096}{096}{096}{096}{096}{189}"
2260   return
2270 rem ********************************
2280 rem            GAME INTRO
2290 rem --------------------------------
2300 print"{clear}{down*7}           air defense"
2310 print"{down*7}        do you need instructions?"
2320 print"{down}              type 'y' or 'n'"
2330 for h=1 to 1000
2340   get d$
2350   if d$="n" then return
2360   if d$="y" then 2410
2370 next
2380 print"{clear}{down}     you did not press 'y' or 'n'"
2390 for k=1 to 5000: next
2400 goto 2300
2410 print"{clear} you must stop the falling bomb by"
2420 print" exploding it in mid-air."
2430 print
2440 print"{down} move the crosshair"
2450 print"{down}* {reverse on}left{reverse off}:cursor u/d key"
2460 print"{down}* {reverse on}right{reverse off}:cursor l/r key"
2470 print"{down}* {reverse on}up{reverse off}: with the 's' key"
2480 print"{down}* {reverse on}down{reverse off}:with the 'x' key"
2490 print"{down}  when the bomb and the crosshair are"
2500 print"  lined up, fire by pressing"
2510 print"  the space bar."
2520 print"{down}press any key to start"
2530 get d$: if d$="" then 2530
2540 print"{clear}{down*10} good luck"
2550 for i=1 to 2500: next
2560 return