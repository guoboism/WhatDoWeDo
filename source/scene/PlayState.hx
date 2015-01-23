package scene;

import data.WDItem;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.touch.FlxTouchManager;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import lime.Assets;
import render.ItemRender;
import render.PlayerRender;
import source.data.WDGame;
import ui.ItemCell;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	var DISTENCE_GET_ITEM:Float = 50;
	
	public var player:PlayerRender;
	
	
	public var uiLayer:FlxGroup;
	
	//scene stuff
	public var sceneImg:FlxSprite;
	public var sceneMap:FlxTilemap;
	public var itemOnGroundRenders:Array<ItemRender>;
	
	//ui stuff
	public var itemHinter:FlxSprite;
	public var itemBgs:Array<ItemCell>;
	
	
	private static var self:PlayState;
	public static function getSelf():PlayState{
		return self;
	}
	
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
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
		itemOnGroundRenders = new Array<ItemRender>();
		for(one in WDGame.getSelf().listItemOnGround){
			var wdItem:WDItem = cast one;
			var itemRender:ItemRender = new ItemRender(wdItem);
			wdItem.linkedRender = itemRender;
			itemOnGroundRenders.push(itemRender);
			add(itemRender);
		}
		
		
		//player stuff
		player = new PlayerRender();
		player.x = 100;
		player.y = 200;
		add(player);
		
		//ui layers
		uiLayer = new FlxGroup();
		uiLayer.setAll("scrollFactor", FlxPoint.get(0, 0));
		add(uiLayer);
		
		//UI things
		//addItemCells
		itemBgs = new Array<ItemCell>();
		for (i in 0...WDGame.getSelf().MAX_BAG_ITEM) {
			var itemCell:ItemCell = new ItemCell();
			itemCell.setPos(  i * 60 + 450, 20  );
			itemBgs.push(itemCell);
			uiLayer.add(itemCell);
		}
		
		itemHinter = new FlxSprite();
		itemHinter.loadGraphic(AssetPaths.img_hinter__png);
		itemHinter.centerOffsets();
		add(itemHinter);
	}

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		FlxG.collide(player, sceneMap);
		
		//check if near any items
		if (player.justMoved == true) {
			checkNearItemOnGround();
			player.justMoved = false;
		}
		
		if(WDGame.getSelf().bagIitemDirty == true){
			updateBagItem();
			WDGame.getSelf().bagIitemDirty = false;
		}
		
	}
	
	
	public function checkNearItemOnGround():Void {
		
		var nearAnyone:Bool = false;
		WDGame.getSelf().selectedItemOnGround = null;
		for(one in WDGame.getSelf().listItemOnGround){
			var wdItem:WDItem = cast one;
			var theRender:ItemRender = wdItem.linkedRender;
			var distance:Float =  player.getMidpoint().distanceTo(theRender.getMidpoint());
			if (distance < DISTENCE_GET_ITEM) {
				itemHinter.x = theRender.x + (theRender.frameWidth - itemHinter.frameWidth)*0.5;
				itemHinter.y = theRender.y - 35;
				itemHinter.scale.x = itemHinter.scale.y = theRender.scale.x;
				itemHinter.centerOrigin();
				nearAnyone = true;
				WDGame.getSelf().selectedItemOnGround = wdItem;
				//trace(wdItem.name);
				break;
			}
		}
		itemHinter.visible = nearAnyone;
	}
	
	
	public function updateBagItem():Void{
		
		
		for(i in 0...WDGame.getSelf().MAX_BAG_ITEM){
			
			var exist:Bool =  i < WDGame.getSelf().bagItems.length;
			
			var itemBg:ItemCell = itemBgs[i];
			if(exist){
				var wdItem:WDItem = WDGame.getSelf().bagItems[i];
				itemBg.render(wdItem);
			}else{
				itemBg.render(null);
			}
		}
	}
	
}