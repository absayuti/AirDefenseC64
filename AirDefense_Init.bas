!------------------------------------------------------------------------------
!- Air Defense
!- Inspired by a type-in and article in COMPUTE! Apr 1983
!- AB Sayuti HM Saman
!- Started on 30th July 2018
!-
!- 
!- Initialisation calls to setup subroutines
!-
!------------------------------------------------------------------------------
10 rem *********************************
12 rem * General initialisation 
15 rem *********************************
20 x=rnd(-TI)
30 gosub 3000      :rem SETUP SID
40 gosub 3200      :rem RELOCATE & SETUP SCREEN
50 gosub 3400      :rem COPY CHARACTER ROM TO RAM
60 gosub 4000      :rem POKE ML "FOR CHK KEY & MOVE SPRITES"
70 gosub 5000      :rem SETUP SPRITE SHAPE DATA
80 rem
90 rem 
!-  SPRITE SHAPE
!-  base = $C000 = 49152
!-  TXTSCR = $C800 = 51200
!-  SSPTR offset = $C800 - $C000 + $0400 = 2048 + 1024 = 3072
!-  ---> 3072/64 = 48
!-----------------------------------------------------------
