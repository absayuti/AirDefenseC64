# AirDefenseC64 (UNFINISHED)
A silly game about shooting down bombs dropped from the sky. Based on a type-in program published in COMPUTE! magazine (Month/Year, issue ????) for various 8-bit home computers. This version was sort of ported from the VIC-20 version but things changed a lt during the programming/porting.

Written in BASIC and 6502 Assembly (or ML or machine language) using a fantastic development tool called CBM Program Studio IDE (link, author ???). The IDE has almost everything: editor, renumbering, multiple files, sprite editor, assembler, online reference etc.

The ML portion was added because BASIC was/is too slow. Main portion kept in BASIC for ease of design/debugging. The main routine, screen setup, poking ML into memory etc are done in BASIC. The ML mainly moves the sprites around and set flags (control block) accordingly. Data/parameters are passed between BASIC and ML via this control block (address ????) 

The game, at time of this writing, still has an obvious bug: the missile (yes! it has a missile... yayyy) sometimes hit the bomb even when they are not actually hitting each other... hahaha.

Had more fun developing the game rather than playing it ... hahaha.

Sayuti 11 sept 2018
