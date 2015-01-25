package source.data;
import data.item.ItemBox;
import data.item.ItemStone;
import data.item.ItemCar;
import data.WDItem;
import flixel.FlxG;
import haxe.Timer;
import render.ItemRender;
import scene.EndState;
import scene.PlayState;

/**
 * 核心数据都在这
 * @author
 */
class WDGame
{

    public var MAX_BAG_ITEM = 5;
	public var MAX_O2:Int = 250;
	public var curO2:Int = 250;
	
    //背包物品
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
        var rdRangeW:Float = 14 * 32;
        var rdRangeH:Float = 10 * 32;
        var rdLeft:Float = 1 * 32;
        var rdTop:Float = 6 * 32;

        for (i in 0...8) {
            var item:WDItem = new ItemStone();
            item.name = "item" + i;
            item.x = Math.random() * rdRangeW + rdLeft;
            item.y = Math.random() * rdRangeH + rdTop;
            listItemOnGround.push(item);
        }
		
        var car:WDItem = new ItemCar();
        car.x = 50;
        car.y = 300;
        listItemOnGround.push(car);
		
		//add timer
		var timer:Timer = new Timer(1000);
		timer.run = onSecond;
    }

    public function pickUpItem(wdItem:WDItem):Void {
        bagItems.push(wdItem);
        wdItem.linkedRender.destroy();
        listItemOnGround.remove(wdItem);
    }
	
    public function tryPickUpItem():Bool{

        if(bagItems.length >= MAX_BAG_ITEM){
            return false;
        }

        if(selectedItemOnGround != null){
            pickUpItem(selectedItemOnGround);
            selectedItemOnGround  = null;
        }
		
        return true;
    }
	
	public function castO2(cost:Int):Void{
		
		curO2 -= cost;
		if (curO2 < 0) curO2 = 0;
		
		if(curO2 == 0){
			//end game
			
			FlxG.switchState(new EndState());
		}
	}
	
	public function onSecond():Void{
		trace("on second:" + curO2);
		curO2 -= 1;
	}

}