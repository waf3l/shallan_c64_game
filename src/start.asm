BasicUpstart2(Entry)

// common, libs
#import "common/zeropage.asm"
#import "../libs/vic.asm"
#import "../libs/tables.asm"


// game logic
#import "maps/maploader.asm"
#import "player/player.asm"


* = * "Entry"
Entry:
        // setting the color of background and border
        lda #$00
        sta VIC.BORDER_COLOR
        sta VIC.BACKGROUND_COLOR


        // disable CIA IRQ's
        lda #$7f
        sta $dc0d
        sta $dd0d

        // bank out rom's [basic, kernel, leave IO]
        lda $01 // load actual settings
        and %11111000 // clear first 3 bits
        ora %00000101 // set up first 3 bits
        sta $01 // save new settings

        // set VIC memory bank 3
        lda $dd00 // get values
        and %11111100 // clear and set proper VIC memory bank [3]
        sta $dd00 // store new settings

        lda #%00001100 // set proper bits [screen memory $0000-$03FF] [character memory $3000-$37FF]
        sta VIC.MEMORY_SETUP_REGISTER // store new settings

        /* 
            Draw / Initialize routine
        */

        // Draw map routine
        jsr MAPLOADER.DrawMap

        // Draw / Initialise Player routine
        jsr


    /*
        Game loop
    */
    
    !Loop:
        jmp !Loop-
