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
import flixel.util.FlxColor;
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

import source.data.WDGame;
import ui.BagSubState;
import ui.ItemCell;

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
    public var _player:PlayerRender;
    public var cars:FlxTypedGroup<render.CarEntity>;
    private var _boxes:FlxTypedGroup<Box>;
    public var _itemGroup:FlxTypedGroup<ItemRender>;
	
    // UI stuff
    public var uiLayer:FlxGroup;
    public var o2bg:FlxSprite;
    public var o2fill:FlxSprite;

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
		sceneMap.visible = false;
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
        cars = new FlxTypedGroup<render.CarEntity>();

        // Generate items
        _itemGroup = new FlxTypedGroup<ItemRender>();
        for(one in WDGame.getSelf().listItemOnGround){
            var wdItem:WDItem = cast one;
            var itemRender:ItemRender = new ItemRender(wdItem);
            wdItem.linkedRender = itemRender;
            _itemGroup.add(itemRender);
            entities.add(itemRender);
        }

        // Add some boxes to make up a challenge
        var left:Int = 20,
            top:Int = 260;
        _boxes = new FlxTypedGroup<Box>();
        var box:Box;
        box = new Box(left + 64 * 0.5, top + 48 * 0.5); _boxes.add(box); entities.add(box);
        box = new Box(left + 64 * 1.5, top + 48 * 0.5); _boxes.add(box); entities.add(box);
        box = new Box(left + 64 * 2.5, top + 48 * 0.5); _boxes.add(box); entities.add(box);
        box = new Box(left + 64 * 2.5, top + 48 * 1.5); _boxes.add(box); entities.add(box);
        box = new Box(left + 64 * 0.5, top + 48 * 2.5); _boxes.add(box); entities.add(box);
        box = new Box(left + 64 * 1.5, top + 48 * 2.5); _boxes.add(box); entities.add(box);

        left = 240;
        top = 400;
        box = new Box(left + 64 * 0.5, top + 48 * 1.5); _boxes.add(box); entities.add(box);
        box = new Box(left + 64 * 2.5, top + 48 * 1.5); _boxes.add(box); entities.add(box);
        box = new Box(left + 64 * 1.5, top + 48 * 0.5); _boxes.add(box); entities.add(box);
        box = new Box(left + 64 * 1.5, top + 48 * 2.5); _boxes.add(box); entities.add(box);

        // Create an UI layer
        uiLayer = new FlxGroup();

        // Create our player
        _player = new PlayerRender(uiLayer);
        _player.x = 350;
        _player.y = 450;
        entities.add(_player);

        // Foreground
        var sceneForeImg:FlxSprite = new FlxSprite(0,520);
        sceneForeImg.loadGraphic(AssetPaths.img_scene_fore__png);
        add(sceneForeImg);

        // Add UI to the top
        uiLayer.setAll("scrollFactor", FlxPoint.get(0, 0));
        add(uiLayer);

		//bag btn
		var bagBtn:FlxButton = new FlxButton(750, 50, "", onBagClk);
		bagBtn.scale.x = bagBtn.scale.y = 0.6;
		bagBtn.loadGraphic(AssetPaths.bagbutton__fw__png);
		uiLayer.add(bagBtn);

		//o2
		o2bg = new FlxSprite(100,50);
        o2bg.loadGraphic(AssetPaths.y__fw__png);
		o2fill = new FlxSprite(o2bg.x + 44, o2bg.y + 10);
		o2fill.makeGraphic(320, 60, FlxColor.AQUAMARINE);
		add(o2fill);
        add(o2bg);
		
		FlxG.sound.playMusic(AssetPaths.D_space__mp3);
		FlxG.sound.play(AssetPaths.Boil_MoltenLiquidLoop2__wav, 0.5, true);
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
        FlxG.collide(cars, sceneMap);
        FlxG.collide(_player, sceneMap);
		
        entities.sort(FlxSort.byY);
		
        // Update O2 graphic
        var prop:Float = WDGame.getSelf().curO2 / WDGame.getSelf().MAX_O2;
        var length:Int = cast 320 * prop;
        o2fill.makeGraphic(length, 60, FlxColor.AQUAMARINE);
    }
	
    public function touchesItem(_player:PlayerRender, item:ItemRender):Void {
        _player.touchesItem(item);
    }

    public function touchesBox(_player:PlayerRender, box:Box):Void {
        _player.touchesBox(box);
    }

	public function onBagClk():Void{
		this.openSubState(new BagSubState());
	}

}