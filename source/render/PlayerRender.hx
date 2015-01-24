package render;

import flixel.FlxG;
import flixel.FlxSprite;
import scene.PlayState;
import source.data.WDGame;

/**
 * 渲染玩家
 * @author
 */
class PlayerRender extends FlxSprite {

    private var ACCEL = 240;
    private var MAX_SPEED = 70;

    public function new() {
        super(0, 0);

        this.maxVelocity.set(MAX_SPEED, MAX_SPEED);

        loadGraphic(AssetPaths.img_char__png);
        centerOrigin();
        centerOffsets();

        trace("char loaded");
    }

    override public function update():Void {
        super.update();

        // Control movement
        if (FlxG.keys.pressed.W && !FlxG.keys.pressed.S) {
            this.acceleration.y = -ACCEL;
        }
        else if (!FlxG.keys.pressed.W && FlxG.keys.pressed.S) {
            this.acceleration.y = ACCEL;
        }
        else {
            this.velocity.y = 0;
            this.acceleration.y = 0;
        }

        if (FlxG.keys.pressed.A && !FlxG.keys.pressed.D) {
            this.acceleration.x = -ACCEL;
        }
        else if (!FlxG.keys.pressed.A && FlxG.keys.pressed.D) {
            this.acceleration.x = ACCEL;
        }
        else {
            this.velocity.x = 0;
            this.acceleration.x = 0;
        }

        // "Handle" action
        if (FlxG.keys.justPressed.F) {
            trace("try to pick at (" + x +", " + y + ")");
            //DO ACTIONS

            //PICK UP item
            var res:Bool = WDGame.getSelf().tryPickUpItem();
        }

        //update size with distance
        var distance = this.y - 32 * 6;
        var maxDistance = 32 * 10;
        //this.scale.x = 0.5 *  distance * distance / (maxDistance * maxDistance) + 0.5;
        this.scale.x = 0.5 *  Math.sqrt(distance) / Math.sqrt(maxDistance) + 0.5;
        if (this.scale.x  > 1) {
            this.scale.x  = 1;
        }
        else if (this.scale.x  < 0.5) {
            this.scale.x  = 0.5;
        }
        this.scale.y = this.scale.x;
        this.centerOrigin();
    }

}
