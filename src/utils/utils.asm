UTILS: {
    GetCharacterAt: {
        // x reg = x char position
        // y reg = y char position

        .label COLLISION_LOOKUP = TEMP1

        /*
            Detect on which row we are
        */
        lda TABLES.ScreenRowLSB, y
        sta COLLISION_LOOKUP
        lda TABLES.ScreenRowMSB, y
        sta COLLISION_LOOKUP + 1

        txa
        tay
        lda (COLLISION_LOOKUP), y

        rts
    }
}