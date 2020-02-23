VIC: {
    .label SCREEN_RAM = $c000
    .label SPRITE_POINTERS = SCREEN_RAM + $3f8

    .label MEMORY_SETUP_REGISTER = $d018

    .label BORDER_COLOR = $d020
    .label BACKGROUND_COLOR = $d021

	.label COLOR_RAM = $d800
}