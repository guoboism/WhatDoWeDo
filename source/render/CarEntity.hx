package render;

class CarEntity extends flixel.FlxSprite {
    private var SPEED:Int = 100;
    public function new(x:Float, y:Float, dir:Int) {
        super(x, y);
        if (dir == 2) { // Down
            this.loadGraphic(AssetPaths.CAR2__png);
            trace("dir == 2");
            this.x -= 70;
            this.velocity.y = SPEED;
        }
        else if (dir == 3) { // Left
            this.loadGraphic(AssetPaths.CAR6__png);
            this.flipX = true;
            trace("dir == 3");
            this.x -= 120;
            this.y += 10;
            this.velocity.x = -SPEED;
        }
        else if (dir == 1) { // Up
            this.loadGraphic(AssetPaths.CAR8__png);
            trace("dir == 1");
            this.x -= 70;
            this.y -= 100;
            this.velocity.y = -SPEED;
        }
        else if (dir == 4) { // Right
            this.loadGraphic(AssetPaths.CAR6__png);
            trace("dir == 4");
            this.x -= 20;
            this.y += 10;
            this.velocity.x = SPEED;
        }

        this.scale.set(0.3, 0.3);
    }
}
