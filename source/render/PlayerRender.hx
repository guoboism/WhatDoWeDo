package render;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;
import flixel.ui.FlxButton;
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
            target._lastFacing = 1;
        }
        else if (!FlxG.keys.pressed.W && FlxG.keys.pressed.S) {
            target.acceleration.y = target.ACCEL;
            target._lastFacing = 2;
        }
        else {
            target.velocity.y = 0;
            target.acceleration.y = 0;
        }

        if (FlxG.keys.pressed.A && !FlxG.keys.pressed.D) {
            target.acceleration.x = -target.ACCEL;
            target._lastFacing = 3;
        }
        else if (!FlxG.keys.pressed.A && FlxG.keys.pressed.D) {
            target.acceleration.x = target.ACCEL;
            target._lastFacing = 4;
        }
        else {
            target.velocity.x = 0;
            target.acceleration.x = 0;
        }

        if (target.velocity.x != 0 || target.velocity.y != 0) {
            //walking
            target.animation.play("walk_" + target._lastFacing);
        }
        else {
            //standing
            target.animation.play("stay_" + target._lastFacing);
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
            target._lastFacing = 1;
        }
        else if (!FlxG.keys.pressed.W && FlxG.keys.pressed.S) {
            target.acceleration.y = target.ACCEL;
            target._lastFacing = 2;
        }
        else {
            target.velocity.y = 0;
            target.acceleration.y = 0;
        }

        if (FlxG.keys.pressed.A && !FlxG.keys.pressed.D) {
            target.acceleration.x = -target.ACCEL;
            target._lastFacing = 3;
        }
        else if (!FlxG.keys.pressed.A && FlxG.keys.pressed.D) {
            target.acceleration.x = target.ACCEL;
            target._lastFacing = 4;
        }
        else {
            target.velocity.x = 0;
            target.acceleration.x = 0;
        }

        if (target.velocity.x != 0 || target.velocity.y != 0) {
            //walking
            target.animation.play("walk_" + target._lastFacing);
        }
        else {
            //standing
            target.animation.play("stay_" + target._lastFacing);
        }

        // Sync box with player
        // target.catchedBox.x = target.x + _boxToTargetOffset.x;
        // target.catchedBox.y = target.y + _boxToTargetOffset.y;
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

    // Graphic
    public var _lastFacing:Int = 2; // down

    // AI
    private var _brain:FSM;
    private var _stateFree:StateFree;
    private var _stateCatch:StateCatchBox;

    // HUD
    // private var _thinkbox:FlxSprite;
    private var _openBoxBtn:FlxButton;
    private var _releaseBtn:FlxButton;

    public function new(uiLayer:flixel.group.FlxGroup) {
        super(0, 0);

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

        // Init HUD
        // _thinkbox = new FlxSprite(0, 0).loadGraphic(AssetPaths.thinkbutton__fw__png);
        // _thinkbox.scale.set(0.3, 0.3);
        // _thinkbox.centerOrigin();
        _openBoxBtn = new FlxButton(0, 0, openBox);
        _openBoxBtn.loadGraphic(AssetPaths.openbox__fw__png);
        _openBoxBtn.scale.set(0.3, 0.3);
        _openBoxBtn.centerOrigin();
        _releaseBtn = new FlxButton(0, 0, releaseBox);
        _releaseBtn.loadGraphic(AssetPaths.release__fw__png);
        _releaseBtn.scale.set(0.3, 0.3);
        _releaseBtn.centerOrigin();
        // uiLayer.add(_thinkbox);
        // uiLayer.add(_openBoxBtn);
        // uiLayer.add(_releaseBtn);

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

        // Sync HUD with player
        /*_thinkbox.x = x;
        _thinkbox.y = y - 150;*/
        _openBoxBtn.x = x - 80;
        _openBoxBtn.y = y - 100;
        _releaseBtn.x = x - 16;
        _releaseBtn.y = y - 94;

        // Perspective effect
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
            // _brain.changeState(_stateCatch);
            // catchedBox = box;
        }
    }

    private function perspective():Void {
        var distance = Math.abs(this.y - 32 * 6);
        var maxDistance = 32 * 10;
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

    private function pickItem(item:ItemRender):Void {
        WDGame.getSelf().pickUpItem(item.itemData);

        // trace("Picked " + WDGame.getSelf().bagItems.length + " items");
    }

    private function openBox() {
        // trace("try to open box");
    }

    private function releaseBox() {
        _brain.changeState(_stateFree);
        catchedBox = null;
    }

}
