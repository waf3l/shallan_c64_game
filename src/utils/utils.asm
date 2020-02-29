UTILS: {
    GetCharacterAt: {
        
    }
        .label COLLISION_LOOKUP = TEMP1

        ldy COLLISION_Y1 // load player position

        /*
            Detect on which row we are
        */
        lda TABLES.ScreenRowLSB, y
        sta COLLISION_LOOKUP
        lda TABLES.ScreenRowMSB, y
        sta COLLISION_LOOKUP + 1

        ldy COLLISION_X1
        lda #$0c
        sta (COLLISION_LOOKUP), y
}