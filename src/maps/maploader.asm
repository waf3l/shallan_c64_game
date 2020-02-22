MAPLOADER: {
    DrawMap: {
        // iterators ?
        .label ROW = TEMP1
        .label COL = TEMP2

        // init screen with address memory of vic screen address
        lda #<VIC.SCREEN_RAM //lsb
        sta Screen + 1
        lda #>VIC.SCREEM_RAM //msb
        sta Screen + 2

        // reset row count
        lda #$00
        sta ROW

        !RowLoop:
                // rest column cont
                lda #$00
                sta COL

                !ColumnLoop:
                        Screen:
                            sta $BEEF, x // put char on screen
            
                // increment position in screen memory
                clc
                lda Screen + 1 // load lsb from screen
                adc #$28 // add 40 columns -> new row
                sta Screen + 1 // store at LSB position
                lda Screen + 2 // load MSB from screen
                adc #$00 // we add 0 to check is a carry set
                sta Screen + 2 // store at MSB

                // incremen ROW counter
                inc ROW
                ldx ROW
                cpx #11 // compare is all 11 row's was draw
                beq !+ // everything is on screen you can exit subroutine
                jmp !RowLoop- // we have some row left to draw
            !:
                // pass to finish screen is draw
        // return
        rts
    }
}