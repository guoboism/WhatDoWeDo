package scene;

import data.WDItem;
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
import lime.Assets;
import render.ItemRender;
import render.PlayerRender;
import source.data.WDGame;
import ui.BagSubState;
import ui.ItemCell;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {

    public var player:PlayerRender;
    private var _itemGroup:flixel.group.FlxTypedGroup<ItemRender>;

    public var uiLayer:FlxGroup;
	public var o2bg:FlxSprite;
	public var o2fill:FlxSprite;
	
    //scene stuff
    public var sceneImg:FlxSprite;
    public var sceneMap:FlxTilemap;
	
    //ui stuff

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

        //scene stuff
        sceneMap = new FlxTilemap();
        sceneMap.loadMap(Assets.getText(AssetPaths.mapCSV_Group2_Map1__csv), AssetPaths.img_tiles__png, 32, 32,0,0,1,2);
        add(sceneMap);
		
        sceneImg = new FlxSprite();
        sceneImg.alpha = 0.6;
        sceneImg.loadGraphic(AssetPaths.img_scene__png);
        add(sceneImg);
		
        //items on ground
        _itemGroup = new FlxTypedGroup<ItemRender>();
        for(one in WDGame.getSelf().listItemOnGround){
            var wdItem:WDItem = cast one;
            var itemRender:ItemRender = new ItemRender(wdItem);
            wdItem.linkedRender = itemRender;
            _itemGroup.add(itemRender);
        }
        add(_itemGroup);

        //player stuff
        player = new PlayerRender();
        player.x = 100;
        player.y = 200;
        add(player);
		
		//fore ground
		var sceneForeImg:FlxSprite = new FlxSprite(0,520);
        sceneForeImg.loadGraphic(AssetPaths.img_scene_fore__png);
        add(sceneForeImg);

        //ui layers
        uiLayer = new FlxGroup();
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

        FlxG.overlap(player, _itemGroup, touchesItem);
        FlxG.collide(player, sceneMap);
		
		//render o2
		var prop:Float = WDGame.getSelf().curO2 / WDGame.getSelf().MAX_O2;
		var length:Int = cast 320 * prop;
		o2fill.makeGraphic(length, 60, FlxColor.AQUAMARINE);
    }

    public function touchesItem(player:PlayerRender, item:ItemRender):Void {
        player.touchesItem(item);
    }
	
	public function onBagClk():Void{
		this.openSubState(new BagSubState());
	}

}