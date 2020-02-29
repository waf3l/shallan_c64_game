PLAYER: {
	PlayerX:
			.byte $01 //2 pixel accuracy
	PlayerY:
			.byte $00 //1 pixel accuracy

	Initialise: {
			lda #$0a
			sta VIC.SPRITE_MULTICOLOR_1
			lda #$09
			sta VIC.SPRITE_MULTICOLOR_2

			lda #$05
			sta VIC.SPRITE_COLOR_0

			lda #$40
			sta VIC.SPRITE_POINTERS + 0

			lda VIC.SPRITE_ENABLE 
			ora %00000001
			sta VIC.SPRITE_ENABLE

			lda VIC.SPRITE_MULTICOLOR
			ora %00000001
			sta VIC.SPRITE_MULTICOLOR

			rts
	}

    GetCollisions: {
        ldx #1
        ldy #20
        jsr PLAYER.GetCollisionPoint // set x, y register
        stx COLLISION_X1
        sty COLLISION_Y1


        ldx #3
        ldy #20
        jsr PLAYER.GetCollisionPoint // set x, y register
        stx COLLISION_X2
        sty COLLISION_Y2
    }

	GetCollisionPoint: {
			// x register continnas x offset (half value)
            // y register containes y offset
            .label X_PIXEL_OFFSET = TEMP1
            .label Y_PIXEL_OFFSET = TEMP2
            
            stx X_PIXEL_OFFSET
            sty Y_PIXEL_OFFSET
            
            .label X_BORDER_OFFSET = $0c
			.label Y_BORDER_OFFSET = $30


			//calculate x and y in screen space
			lda PlayerX
			cmp #X_BORDER_OFFSET
			bcs !+
			lda #X_BORDER_OFFSET
		!:	
			clc
            adc X_PIXEL_OFFSET
            sec
			sbc #X_BORDER_OFFSET
			lsr
			lsr
			tax

			lda PlayerY
			cmp #Y_BORDER_OFFSET
			bcs !+
			lda #Y_BORDER_OFFSET
		!:
			clc
            adc Y_PIXEL_OFFSET
            sec
			sbc #Y_BORDER_OFFSET
			lsr
			lsr
			lsr
			tay

			rts
	}

	DrawPlayer: {
			lda PlayerX
			asl
			sta VIC.SPRITE_0_X
			bcc !+
			lda VIC.SPRITE_MSB
			ora #%00000001
			jmp !EndMSB+
		!:
			lda VIC.SPRITE_MSB
			and #%11111110
		!EndMSB:
			sta VIC.SPRITE_MSB

			lda PlayerY
			sta VIC.SPRITE_0_Y

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


		!Up:
			lda JOY_ZP	
			and #JOY_UP
			bne !+
			dec PlayerY
			dec PlayerY
			jmp !Left+
		!:

		!Down:
			lda JOY_ZP
			and #JOY_DN
			bne !+
			inc PlayerY
			inc PlayerY
		!:

		!Left:
			lda JOY_ZP
			and #JOY_LT
			bne !+
			ldx PLAYER.PlayerX
			dex
			cpx #255
			bne !Skip+
			ldx #183
		!Skip:
			stx PLAYER.PlayerX
			jmp !Right+
		!:

		!Right:
			lda JOY_ZP
			and #JOY_RT
			bne !+
			ldx PLAYER.PlayerX
			inx
			cpx #184
			bne !Skip+
			ldx #$00
		!Skip:
			stx PLAYER.PlayerX
		!:

			rts
	}
}