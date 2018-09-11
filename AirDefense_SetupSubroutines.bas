!------------------------------------------------------------------------------
!- Air Defense
!- Inspired by a type-in and article in COMPUTE! Apr 1983
!- AB Sayuti HM Saman
!- Started on 30th July 2018
!-
!-
!- Setup subroutines
!-
!------------------------------------------------------------------------------
!-   SID SETUP
!------------------------------------------------------------------------------
3000 so=54272 : for i=so to so+24 : poke i,0 : next
3010 rem poke so+24,0: poke so+4,65: poke so+6,240
3020 return
!-30 pokeso+14,5
!-40 pokeso+18,16
!-50 pokeso+3,1
!-60 pokeso+24,143
!-70 pokeso+6,240
!-80 pokeso+4,65
!-90 fr=3000
!-100 for t=1 to 2
!-105   for i=1 to 20
!-110     fq=fr+i*50
!-120     hf=int(fq/256) : lf=fq-hf*256
!-130     poke so+0,lf : poke so+1,hf
!-135   next
!-140 next
!-150 pokeso+24,0
!------------------------------------------------------------------------------
!-   RELOCATE AND SETUP SCREEN + relocate charset
!-
!-   poke VIC+24, A+B
!-
!-   A = TXTSCR location = base + offset*1024
!-                            (offset = bits 4-7 of 53272 (VIC+24))
!-
!-   0000xxxx  0  base               poke VIC+24, 0+B
!-   0001xxxx  0  base+1024  $0400   poke VIC+24, 16+B
!-   0010xxxx  0  base+2048  $0800   poke VIC+24, 32+B   <=== $C800
!-   0011xxxx  0  base+3072  $0C00   poke VIC+24, 48+B
!-   0100xxxx  0  base+4096  $1000   poke VIC+24, 64+B
!-   0101xxxx  0  base+5120  $1400   poke VIC+24, 80+B
!-   0110xxxx  0  base+6144  $1800   poke VIC+24, 96+B
!-   0111xxxx  0  base+7168  $1C00   poke VIC+24, 112+B
!-   1000xxxx  0  base+8192  $2000   poke VIC+24, 128+B
!-   1001xxxx  0  base+8192  $2000   poke VIC+24, 144+B
!-   1010xxxx  0  base+8192  $2000   poke VIC+24, 160+B
!-   1011xxxx  0  base+8192  $2000   poke VIC+24, 176+B
!-   1100xxxx  0  base+8192  $2000   poke VIC+24, 192+B
!-   1101xxxx  0  base+8192  $2000   poke VIC+24, 208+B
!-   1110xxxx  0  base+8192  $2000   poke VIC+24, 234+B
!-   1111xxxx  0  base+8192  $2000   poke VIC+24, 240+B
!-
!-   B = CHARSET location = base + offset*2048
!-                            (offset = bits 1-3 of 53272 (VIC+24)
!-
!-   xxxx000x  0  base              poke VIC+24, A
!-   xxxx001x  2  base+2048 $0800   poke VIC+24, A+2
!-   xxxx010x  4  base+4096 $1000   poke VIC+24, A+4   <=== $D000
!-   xxxx011x  6  base+6144 $1800   poke VIC+24, A+6
!-   xxxx100x  8  base+8192  $2000  poke VIC+24, A+8
!-   xxxx101x 10  base+10240 $2800  poke VIC+24, A+10
!-   xxxx110x 12  base+12288 $3000  poke VIC+24, A+12
!-   xxxx111x 14  base+14336 $3800  poke VIC+24, A+14
!-
!-
!-   KERNEL's TXTSCR pointer = poke 648, P*256
!-
!-   e.g. TXTSCR @ $C800 = 51200
!-
!-                       --> 51200/256 = 200
!-                       --> poke 648,200
!-
!------------------------------------------------------------------------------
3200 poke 56576,peek(56576)and252  :rem MOVE VIC BANK TO $C000–$FFFF
3210 vic=53248
3220 poke vic+24,32+4              :rem TXTSCR AT $C800, CHARSET AT $D000
3230 poke 648,200                  :rem TELL KERNEL SCREEN AT $C800
3240 txt=51200: co=55296           :rem TXTSCR RAM & colour RAM
3250 poke vic+32,14: poke vic+33,14  :rem Blue screen & border
3260 return
!------------------------------------------------------------------------------
!-   COPY CHARACTER ROM TO RAM UNDERNEATH
!------------------------------------------------------------------------------
3400 print"{yellow}{clear}{down*10}{right*12}please wait..."
3410 sa=828
3420 for n=0 to 36
3430 read a% : poke sa+n,a%: next n
3440 sys sa
3450 return
3460 rem - ML - COPY CHAR ROM
3470 data 120,162,8,165,1,41,251,133
3480 data 1,169,208,133,252,160,0,132
3490 data 251,177,251,145,251,200,208,249
3500 data 230,252,202,208,244,165,1,9
3510 data 4,133,1,88,96
!-1170 poke 56334,peek(56334)and254:  rem disable interrupt
!-1180 poke 1,peek(1)and251:          rem show CHARSET ROM
!-1190 for a=53248 to 57342: poke a,peek(a): next
!-1200 poke 1,peek(1)or4:             rem show DEVICE registers
!-1210 poke 56334,peek(56334)or1:     rem Enable interrupt
!-1220 return