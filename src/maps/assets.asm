/*  Memory maps
$c000 - $ffff Vic bank 3
$c000 - $c3ff screen
$c400 - $cffff 16 sprites
$d000 - $efff 128 sprites
$f000 - $f7ff 1 charset
$f800 - $fffd 16 sprites
*/


* = $8000 "Map data"
    MAP_TILES:
        .import binary "../../assets/maps/tiles.bin"
    
    CHAR_COLORS:
        .import binary "../../assets/maps/cols.bin"
    
    MAP_1:
        .import binary "../../assets/maps/map_1.bin"

* = $f000 "Chars data"
    CHARS:
        .import binary "../../assets/maps/chars.bin"