package render;

import flixel.FlxSprite;

class Box extends FlxSprite {

    public function new(x:Int, y:Int) {
        super(x, y);

        // Initialize graphics
        loadGraphic(AssetPaths.img_box__png);
        centerOrigin();
        centerOffsets();

        // Setup physics
        this.drag.set(300, 300);
        this.width = 36;
        this.height = 14;
        this.offset.set(8, 22);
    }

}
