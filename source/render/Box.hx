package render;

import flixel.FlxSprite;

class Box extends FlxSprite {

    public function new(x:Float, y:Float) {
        super(x, y);

        // Initialize graphics
        loadGraphic(AssetPaths.img_box__png);
        centerOrigin();
        centerOffsets();

        // Setup physics
        this.drag.set(200, 200);
        this.width = 36;
        this.height = 14;
        this.offset.set(8, 22);
    }

}
