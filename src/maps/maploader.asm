MAPLOADER: {
    DrawMap: {
        // iterators ?
        .label ROW = TEMP1
        .label COL = TEMP2

        // init screen with address memory of vic screen address
        lda #<VIC.SCREEN_RAM // lsb
        sta Screen + 1
        lda #>VIC.SCREEM_RAM // msb
        sta Screen + 2

        // init color screen address of vic color address
        lda #<VIC.COLOR_RAM // lsb
        sta Color + 1
        lda #>VIC.COLOR_RAM // msb
        sta Color + 2

        // initialize the map tile [seek to first tail in the map memory address]
        lda #<MAP_1 // lsb
        sta MapTile + 1
        lda #>MAP_!
        sta MapTile + 2

        // reset row count
        lda #$00
        sta ROW

        !RowLoop:
            // rest column cont
            lda #$00
            sta COL

            !ColumnLoop:
                ldy #$00 // general counter 0->3 [4 char in tile]

                /*
                    Init tile char lookup
                */
                lda #$00
                sta TileCharLookup + 1
                sta TileCharLookup + 2

                MapTile:
                    lda $BEEF

                    

                !DrawTile:    
                    
                    TileCharLookup:
                        sta $BEEF, y
                        ldx TABLES.TileScreenLocations2x2, y

                    Screen:
                        sta $BEEF, x // put char on screen

                        tax // transfer REG A to REG X
                        
                        lda CHAR_COLOR, x // load color value into REG A depend of char in REG X

                        ldx TABLES.TileScreenLocations2x2, y // recover REG X

                    Color:
                        sta $BEEF, x // set proper color for char on position

                    iny // increment draw tile loop
                    cpy #$04 // compare if we draw all 4 chars from tile
                    bne !DrawTile- // we not finish yet drawing the tile

                // increment position in map memory address [step to next tile]
                clc
                lda MapTile + 1
                adc #$01
                sta MapTile + 1
                lda MapTile + 2
                adc #$00
                sta MapTile + 2
                
                // increment screen memory position
                clc
                lda Screen + 1
                adc #$02
                sta Screen + 1
                lda Screen + 2
                adc #$00
                sta Screen + 2

                // increment color memory position
                clc
                lda Color + 1
                adc #$02
                sta Color + 1
                lda Color + 2
                adc #$00
                sta Color + 2

                inc COL
                ldx COL
                cpx #20
                beq !EndColumnLoop+
                jmp !ColumnLoop-

                !EndColumnLoop:    
                    //finish column loop

            // increment position in screen memory to next row
            clc
            lda Screen + 1 // load lsb from screen
            adc #$28 // add 40 columns -> new row
            sta Screen + 1 // store at LSB position
            lda Screen + 2 // load MSB from screen
            adc #$00 // we add 0 to check is a carry set
            sta Screen + 2 // store at MSB

            // increment color position in screen memory to next row
            clc
            lda Color + 1 // load lsb from color screen memory
            adc #$28 // add 40 columns -> new row
            sta Color + 1 // store at LSB position
            lda Color + 2 // load MSB from color screen memory
            adc #$00 // we add 0 to cehck if cary bit was set
            sta Color + 2 // store at MSB position

            // incremen ROW counter
            inc ROW
            ldx ROW
            cpx #11 // compare is all 11 row's was draw
            beq !EndRowLoop+ // everything is on screen you can exit subroutine
            jmp !RowLoop- // we have some row left to draw
            
            !EndRowLoop:
                // pass to finish screen is draw
        
        // return
        rts
    }
}