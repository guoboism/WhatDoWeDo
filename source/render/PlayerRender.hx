package render;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;
import scene.PlayState;

import source.data.WDGame;
import render.ItemRender;

/**
 * 渲染玩家
 * @author
 */
class PlayerRender extends FlxSprite {

    private var ACCEL:Int = 240;
    private var MAX_SPEED:Int = 70;

    // TODO: Use "sensor" to detect nearby items
    private var _canReachItem:Bool = false;
    private var _nearbyItem:ItemRender;
	private var _lastFacing:Int = 2;//down
	
    public function new() {
        super(0, 0);
		
        // Setup physics
        this.maxVelocity.set(MAX_SPEED, MAX_SPEED);
		
        // Initialize graphics
        loadGraphic(AssetPaths.img_avatar__png, true, 260, 324);
		
		//dir: 1=up 2=down 3=left 4=right
		this.animation.add("stay_1", [0], 12);
		this.animation.add("stay_2", [3], 12);
		this.animation.add("stay_3", [6], 12);
		this.animation.add("stay_4", [9], 12);
		
		this.animation.add("walk_1", [0,1,0,2], 12);
		this.animation.add("walk_2", [3,4,3,5], 12);
		this.animation.add("walk_3", [6,7,6,8], 12);
		this.animation.add("walk_4", [9,10,9,11], 12);
		
		this.animation.play("stay_2");
		
		this.setSize(10, 10);
        centerOrigin();
        centerOffsets();
    }

    override public function update():Void {
        super.update();
		
		var moving:Bool = false;
		
        // Control movement
        if (FlxG.keys.pressed.W && !FlxG.keys.pressed.S) {
            this.acceleration.y = -ACCEL;
			_lastFacing = 1;
			moving = true;
        }
        else if (!FlxG.keys.pressed.W && FlxG.keys.pressed.S) {
            this.acceleration.y = ACCEL;
			_lastFacing = 2;
			moving = true;
        }
        else {
            this.velocity.y = 0;
            this.acceleration.y = 0;
        }
		
        if (FlxG.keys.pressed.A && !FlxG.keys.pressed.D) {
            this.acceleration.x = -ACCEL;
			_lastFacing = 3;
			moving = true;
        }
        else if (!FlxG.keys.pressed.A && FlxG.keys.pressed.D) {
            this.acceleration.x = ACCEL;
			_lastFacing = 4;
			moving = true;
        }
        else {
            this.velocity.x = 0;
            this.acceleration.x = 0;
        }
		
		if(moving){
			//walking
			this.animation.play("walk_" + _lastFacing);
		}else{
			//standing
			this.animation.play("stay_" + _lastFacing);
		}

        // "Handle" action
        if (FlxG.mouse.justPressed) {
            if (_canReachItem && _nearbyItem != null) {
                this.pickItem(_nearbyItem);
            }
        }
        this._canReachItem = false;
        this._nearbyItem = null;
		
        //update size with distance
        var distance = Math.abs(this.y - 32 * 6);
        var maxDistance = 32 * 10;
        //this.scale.x = 0.5 *  distance * distance / (maxDistance * maxDistance) + 0.5;
        this.scale.x = 0.5 *  Math.sqrt(distance) / Math.sqrt(maxDistance)+ 0.5;
        if (this.scale.x  > 1) {
            this.scale.x  = 1;
        }
        else if (this.scale.x  < 0.5) {
            this.scale.x  = 0.5;
        }
		scale.x *= 0.3;
        this.scale.y = this.scale.x;
        this.centerOrigin();
    }
	
    override public function destroy():Void {
        super.destroy();
    }

    public function touchesItem(item:ItemRender):Void {
        this._canReachItem = true;
        this._nearbyItem = item;
    }

    private function pickItem(item:ItemRender):Void {
        WDGame.getSelf().pickUpItem(item.itemData);
		
        trace("Picked " + WDGame.getSelf().bagItems.length + " items");
    }

}
