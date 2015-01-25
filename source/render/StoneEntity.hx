package render;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class StoneEntity extends FlxSprite {
    private var HORIZONTAL_DIST:Int = 200;
    private var VERTICAL_DIST:Int = 140;
    private var FALL_TIME:Float = 1.0;
    public function new(x:Float, y:Float, dir:Int) {
        super(x, y);
        this.loadGraphic(AssetPaths.STONE1__png);
        if (dir == 2) { // Down
            this.x -= 70;
            FlxTween.tween(this, {
                y: this.y + VERTICAL_DIST
            }, FALL_TIME, {
                ease: FlxEase.backIn
            });
        }
        else if (dir == 3) { // Left
            this.x -= 120;
            this.y += 10;
            FlxTween.tween(this, {
                x: this.x - HORIZONTAL_DIST
            }, FALL_TIME, {
                ease: FlxEase.quadOut
            });
            FlxTween.tween(this, {
                y: this.y - 40
            }, FALL_TIME / 2, {
                ease: FlxEase.cubeOut
            });
            FlxTween.tween(this, {
                y: this.y
            }, FALL_TIME / 2, {
                ease: FlxEase.cubeIn,
                startDelay: FALL_TIME / 2
            });
        }
        else if (dir == 1) { // Up
            this.x -= 70;
            this.y -= 100;
            FlxTween.tween(this, {
                y: this.y - VERTICAL_DIST
            }, FALL_TIME, {
                ease: FlxEase.backOut
            });
        }
        else if (dir == 4) { // Right
            this.x -= 20;
            this.y += 10;
            FlxTween.tween(this, {
                x: this.x + HORIZONTAL_DIST
            }, FALL_TIME, {
                ease: FlxEase.quadOut
            });
            FlxTween.tween(this, {
                y: this.y - 40
            }, FALL_TIME / 2, {
                ease: FlxEase.cubeOut
            });
            FlxTween.tween(this, {
                y: this.y
            }, FALL_TIME / 2, {
                ease: FlxEase.cubeIn,
                startDelay: FALL_TIME / 2
            });
        }

        this.scale.set(0.3, 0.3);
    }
}
