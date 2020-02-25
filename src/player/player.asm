PLAYER: {
    //Player coordinates
    PlayerX:
        .byte $00, $40, $00
    
    PlayerY:
        .byte $40

    PlayerWalkSpeed:
        .byte $ff, $00

    Init: {
        lda #$0a // set color pink
        sta VIC.SPRITE_MULTICOLOR_1
        lda #$09 // set color brown
        sta VIC.SPRITE_MULTICOLOR_2

        lda #$05 // set sprite clor to green
        sta VIC.SPRITE_COLOR_0

        lda #$40 // where sprite is in memory
        sta VIC.SPRITE_POINTERS + 0
        
        // enable sprites
        lda VIC.SPRITE_ENABLE
        ora #%00000001
        sta VIC.SPRITE_ENABLE 
        
        // enable psrite multicolor
        lda VIC.SPRITE_MULTICOLOR
        ora #%00000001
        sta VIC.SPRITE_MULTICOLOR

        rts
    }

    PlayerJoyControl: {
        .label JOY_PORT_2 = $dc00

        .label JOY_UP = %00001
        .label JOY_DN = %00010
        .label JOY_LT = %00100
        .label JOY_RT = %01000
        .label JOY_FR = %10000

        lda JOY_PORT_2
        sta JOY_ZP

        !Left:
            lda JOY_ZP
            and #JOY_LT
            bne !LeftEnd+
            
            sec
            lda PlayerX
            sbc PlayerWalkSpeed
            sta PlayerX

            lda PlayerX + 1
            sbc PlayerWalkSpeed + 1
            sta PlayerX + 1

            lda PlayerX + 2
            sbc #$00
            sta PlayerX + 2

        !LeftEnd:
            

        !Right:
            lda JOY_ZP // load joystick staus
            and #JOY_RT // compare it with right reference
            bne !RightEnd+ // if not push right go next

            /*
                We will need to calculate the move
            */
            clc
            lda PlayerX // we load LSB
            adc PlayerWalkSpeed // add 
            sta PlayerX // store without check and clear carry bit -> fractal value
            lda PlayerX + 1 // load position lsb
            adc PlayerWalkSpeed + 1 // add MSB  without clear carry bit
            sta PlayerX + 1 // store at position LSB
            lda PlayerX + 2 // load MSB position
            adc #$00 // add without clear the carry bit
            sta PlayerX + 2 // store at MSB position
        
        !RightEnd:

        rts
    }

    /*
        Set player x & y position
    */
    DrawPlayer: {
            // we need to load the PlayerX value and store it
            // into SPRITE_0_X register
            lda PlayerX + 1
            sta VIC.SPRITE_0_X

            //load second byte and check if is zero or not
            lda PlayerX + 2 // this load second[1] byte from our local VAR
            beq !+ // id the value is #$00 in the LDA then go to !+ label

            // second byte of PlayerX is set
            // we need move our sprite over 255
            // we set the SPRITE_MSB register
            lda VIC.SPRITE_MSB
            ora #%00000001
            jmp !EndMSB+
        
        !:
            //from branch we know that the SPRITE_MSB 
            // is no need to set, so we load the ori value 
            // and make AND with 0 values to be sure that
            // SPRITE_MSB is not set
            lda VIC.SPRITE_MSB
            and #%11111110
        
        !EndMSB:
            // we have set the SPRITE_MSB
            // so we not store it
            sta VIC.SPRITE_MSB

            // Now we copy the PlayerY postion
            // into SPRITE_0_Y register
            lda PlayerY
            sta VIC.SPRITE_0_Y
        
        rts
    }
}