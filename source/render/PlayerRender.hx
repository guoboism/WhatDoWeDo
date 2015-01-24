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

class State {
    public var target:PlayerRender;
    public function new(target:PlayerRender) {
        this.target = target;
    }
    public function enter() {}
    public function exec() {}
    public function exit() {
        this.target = null;
    }
}

class FSM {
    public var currState:State;
    public var nextState:State;
    public var owner:PlayerRender;
    public function new(owner:PlayerRender, initState:State):Void {
        this.owner = owner;
        changeState(initState);
    }
    public function changeState(newState:State):Void {
        if (newState != currState) {
            nextState = newState;
        }
    }
    public function update():Void {
        if (nextState != null) {
            if (currState != null) {
                currState.exit();
            }

            currState = nextState;
            nextState = null;
            currState.enter();
        }
        if (currState != null) {
            currState.exec();
        }
    }
}

class StateIdle extends State {
    public function new(target:PlayerRender) {
        super(target);
    }
    override public function enter() {}
    override public function exec() {}
    override public function exit() {
        super.exit();
    }
}

class StateWalk extends State {
    public function new(target:PlayerRender) {
        super(target);
    }
    override public function enter() {}
    override public function exec() {}
    override public function exit() {
        super.exit();
    }
}

/**
 * 渲染玩家
 * @author
 */
class PlayerRender extends FlxSprite {

    private var ACCEL:Int = 360;
    private var MAX_SPEED:Int = 70;

    private var _canReachItem:Bool = false;
    private var _nearbyItem:ItemRender;

    // AI
    private var _brain:FSM;
    private var _idle:StateIdle;
    private var _walk:StateWalk;

    public function new() {
        super(0, 0);

        // Initialize graphics
        loadGraphic(AssetPaths.img_char__png);
        centerOrigin();
        centerOffsets();

        // Setup physics
        this.width = 30;
        this.height = 30;
        this.offset.set(4, 40);
        this.maxVelocity.set(MAX_SPEED, MAX_SPEED);

        // Setup AI
        _idle = new StateIdle(this);
        _walk = new StateWalk(this);
        _brain = new FSM(this, _idle);
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
        if (FlxG.mouse.justPressed) {
            if (_canReachItem && _nearbyItem != null) {
                this.pickItem(_nearbyItem);
            }
        }
        this._canReachItem = false;
        this._nearbyItem = null;

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
