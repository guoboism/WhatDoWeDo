package scene;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.input.touch.FlxTouchManager;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSort;
import lime.Assets;

import data.WDItem;
import source.data.WDGame;

import render.ItemRender;
import render.PlayerRender;
import render.Box;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {

    // Config
    private var BOX_MARGIN_LEFT:Int = 100;
    private var BOX_MARGIN_RIGHT:Int = 640;
    private var BOX_MARGIN_TOP:Int = 200;
    private var BOX_MARGIN_BOTTOM:Int = 500;

    // Scene stuff
    public var sceneImg:FlxSprite;
    public var sceneMap:FlxTilemap;
    public var entities:FlxTypedGroup<flixel.FlxObject>;

    // Sprites
    private var _player:PlayerRender;
    private var _boxes:FlxTypedGroup<Box>;
    private var _itemGroup:FlxTypedGroup<ItemRender>;

    // UI stuff
    public var uiLayer:FlxGroup;

    // Singleton
    private static var self:PlayState;
    public static function getSelf():PlayState {
        return self;
    }

    /**
     * Function that is called up when to state is created to set it up.
     */
    override public function create():Void {
        super.create();
        self = this;

        //init data
        WDGame.getSelf();
        FlxG.stage.color = 0xFFFFFF;

        // Tilemap for terrain collision
        sceneMap = new FlxTilemap();
        sceneMap.loadMap(Assets.getText(AssetPaths.mapCSV_Group2_Map1__csv), AssetPaths.img_tiles__png, 32, 32,0,0,1,2);
        add(sceneMap);

        // Background
        sceneImg = new FlxSprite();
        sceneImg.alpha = 0.6;
        sceneImg.loadGraphic(AssetPaths.img_scene__png);
        add(sceneImg);

        // Entities
        entities = new FlxTypedGroup<flixel.FlxObject>();
        add(entities);

        // Generate items
        _itemGroup = new FlxTypedGroup<ItemRender>();
        for(one in WDGame.getSelf().listItemOnGround){
            var wdItem:WDItem = cast one;
            var itemRender:ItemRender = new ItemRender(wdItem);
            wdItem.linkedRender = itemRender;
            _itemGroup.add(itemRender);
            entities.add(itemRender);
        }

        // Add 3 boxes to the scene
        _boxes = new FlxTypedGroup<Box>();
        for (i in 0...3) {
            var box:Box = new Box(
                FlxRandom.intRanged(BOX_MARGIN_LEFT, BOX_MARGIN_RIGHT),
                FlxRandom.intRanged(BOX_MARGIN_TOP, BOX_MARGIN_BOTTOM)
            );
            _boxes.add(box);
            entities.add(box);
        }

        // Create our player
        _player = new PlayerRender();
        _player.x = 100;
        _player.y = 200;
        entities.add(_player);

        // Create an UI layer and add to the top
        uiLayer = new FlxGroup();
        uiLayer.setAll("scrollFactor", FlxPoint.get(0, 0));
        add(uiLayer);
    }

    /**
     * Function that is called when this state is destroyed - you might want to
     * consider setting all objects this state uses to null to help garbage collection.
     */
    override public function destroy():Void {
        super.destroy();
    }

    /**
     * Function that is called once every frame.
     */
    override public function update():Void {
        super.update();

        FlxG.overlap(_player, _itemGroup, touchesItem);
        FlxG.collide(_player, _boxes, touchesBox);
        FlxG.collide(_boxes, _boxes);
        FlxG.collide(_player, sceneMap);

        entities.sort(FlxSort.byY);
    }

    public function touchesItem(_player:PlayerRender, item:ItemRender):Void {
        _player.touchesItem(item);
    }

    public function touchesBox(_player:PlayerRender, box:Box):Void {
        _player.touchesBox(box);
    }

}