package ui;
import data.WDItem;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * ...
 * @author 
 */
class ItemCell extends FlxGroup
{

	public var bg:FlxSprite;
	public var item:FlxSprite;
	
	public function new() 
	{
		super();
		
		bg = new FlxSprite();
		bg.loadGraphic(AssetPaths.img_item_cell__png);
		add(bg);
		
		item =  new FlxSprite();
		item.visible = false;
		add(item);
	}
	
	public function setPos(x:Float, y:Float):Void{
		bg.x = x;
		bg.y = y;
		item.x = x;
		item.y = y;
	}
	
	public function render(itemData:WDItem) {
		if(itemData == null){
			item.visible = false;
		}else{
			item.visible = true;
			item.loadGraphic(itemData.pathIcon);
		}
	}
	
}