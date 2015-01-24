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
import render.Box;

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

class StateFree extends State {
    public function new(target:PlayerRender) {
        super(target);
    }
    override public function enter() {
        target.maxVelocity.set(target.FREE_MAX_SPEED, target.FREE_MAX_SPEED);
    }
    override public function exec() {
        // Control movement
        if (FlxG.keys.pressed.W && !FlxG.keys.pressed.S) {
            target.acceleration.y = -target.ACCEL;
        }
        else if (!FlxG.keys.pressed.W && FlxG.keys.pressed.S) {
            target.acceleration.y = target.ACCEL;
        }
        else {
            target.velocity.y = 0;
            target.acceleration.y = 0;
        }

        if (FlxG.keys.pressed.A && !FlxG.keys.pressed.D) {
            target.acceleration.x = -target.ACCEL;
        }
        else if (!FlxG.keys.pressed.A && FlxG.keys.pressed.D) {
            target.acceleration.x = target.ACCEL;
        }
        else {
            target.velocity.x = 0;
            target.acceleration.x = 0;
        }
    }
    override public function exit() {
        super.exit();
    }
}

class StateCatchBox extends State {
    private var _boxToTargetOffset:FlxPoint;
    public function new(target:PlayerRender) {
        super(target);
        _boxToTargetOffset = new FlxPoint();
    }
    override public function enter() {
        target.maxVelocity.set(target.CATCH_MAX_SPEED, target.CATCH_MAX_SPEED);
        _boxToTargetOffset.set(
            target.catchedBox.x - target.x,
            target.catchedBox.y - target.y
        );
    }
    override public function exec() {
        // Control movement
        if (FlxG.keys.pressed.W && !FlxG.keys.pressed.S) {
            target.acceleration.y = -target.ACCEL;
        }
        else if (!FlxG.keys.pressed.W && FlxG.keys.pressed.S) {
            target.acceleration.y = target.ACCEL;
        }
        else {
            target.velocity.y = 0;
            target.acceleration.y = 0;
        }

        if (FlxG.keys.pressed.A && !FlxG.keys.pressed.D) {
            target.acceleration.x = -target.ACCEL;
        }
        else if (!FlxG.keys.pressed.A && FlxG.keys.pressed.D) {
            target.acceleration.x = target.ACCEL;
        }
        else {
            target.velocity.x = 0;
            target.acceleration.x = 0;
        }

        // Sync box with player
        target.catchedBox.x = target.x + _boxToTargetOffset.x;
        target.catchedBox.y = target.y + _boxToTargetOffset.y;
    }
    override public function exit() {
        target.catchedBox = null;
        super.exit();
    }
}

/**
 * 渲染玩家
 * @author
 */
class PlayerRender extends FlxSprite {

    public var ACCEL:Int = 360;
    public var FREE_MAX_SPEED:Int = 70;
    public var CATCH_MAX_SPEED:Int = 40;

    public var catchedBox:Box;

    private var _canReachItem:Bool = false;
    private var _nearbyItem:ItemRender;

    // AI
    private var _brain:FSM;
    private var _stateFree:StateFree;
    private var _stateCatch:StateCatchBox;

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

        // Setup AI
        _stateFree = new StateFree(this);
        _stateCatch = new StateCatchBox(this);
        _brain = new FSM(this, _stateFree);
    }

    override public function update():Void {
        super.update();

        // "Handle" action
        if (FlxG.mouse.justPressed) {
            if (_canReachItem && _nearbyItem != null) {
                this.pickItem(_nearbyItem);
            }
        }
        this._canReachItem = false;
        this._nearbyItem = null;

        _brain.update();

        perspective();
    }

    override public function destroy():Void {
        super.destroy();
    }

    public function touchesItem(item:ItemRender):Void {
        this._canReachItem = true;
        this._nearbyItem = item;
    }

    public function touchesBox(box:Box):Void {
        if (_brain.currState != _stateCatch) {
            trace("touch box");
            _brain.changeState(_stateCatch);
            catchedBox = box;
        }
    }

    private function perspective():Void {
        var distance = this.y - 32 * 6;
        var maxDistance = 32 * 10;
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

    private function pickItem(item:ItemRender):Void {
        WDGame.getSelf().pickUpItem(item.itemData);

        trace("Picked " + WDGame.getSelf().bagItems.length + " items");
    }

}
