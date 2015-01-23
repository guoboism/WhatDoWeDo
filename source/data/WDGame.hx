package source.data;
import data.item.ItemEgg;
import data.WDItem;
import render.ItemRender;
import scene.PlayState;

/**
 * 核心数据都在这
 * @author 
 */
class WDGame
{
	
	public var MAX_BAG_ITEM = 5;
	
	//背包物品
	public var bagIitemDirty:Bool = false;
	public var bagItems:Array<WDItem>;
	
	//地上物品列表
	public var listItemOnGround:Array<WDItem>;
	public var selectedItemOnGround:WDItem;
	
	private static var self:WDGame;
	public static function getSelf():WDGame{
		if(self == null){
			self = new WDGame();
		}
		return self;
	}
	
	public function new() 
	{
		
		bagItems= new Array<WDItem>();
		listItemOnGround = new Array<WDItem>();
		
		
		//puts some test data
		var rdRangeW:Float = 18 * 32;
		var rdRangeH:Float = 12 * 32;
		var rdLeft:Float = 1 * 32;
		var rdTop:Float = 6 * 32;
		
		for(i in 0...10){
			var item:WDItem = new ItemEgg();
			item.name = "item" + i;
			item.x = Math.random() * rdRangeW + rdLeft;
			item.y = Math.random() * rdRangeH + rdTop;			
			listItemOnGround.push(item);
		}
	}
	
	public function pickUpItem(wdItem:WDItem):Void {		
		bagItems.push(wdItem);
		wdItem.linkedRender.destroy();
		listItemOnGround.remove(wdItem);
		bagIitemDirty = true;
	}
	
	public function tryPickUpItem():Bool{
		
		if(bagItems.length >= MAX_BAG_ITEM){
			return false;
		}
		
		if(selectedItemOnGround != null){
			pickUpItem(selectedItemOnGround);
			selectedItemOnGround  = null;
			PlayState.getSelf().player.justMoved = true;
		}
		
		return true;
	}
	
}