package render;
import flixel.FlxG;
import flixel.FlxSprite;
import scene.PlayState;
import source.data.WDGame;

/**
 * 渲染玩家
 * @author 
 */
class PlayerRender extends FlxSprite
{
	
	
	public var SPEED = 5;
	public var justMoved:Bool = false;
	
	public function new() 
	{
		super(0, 0);
		loadGraphic(AssetPaths.img_char__png);
		centerOrigin();
		centerOffsets();
		
		trace("char loaded");
	}
	
	override public function update():Void 
	{
		super.update();
		
		//check input
		
		if(FlxG.keys.pressed.UP){
			justMoved = true;
			this.y -= SPEED;
			
		}else if(FlxG.keys.pressed.DOWN){
			justMoved = true;
			this.y += SPEED;
		}
		
		if(FlxG.keys.pressed.LEFT){
			justMoved = true;
			this.x -= SPEED;
		}else if (FlxG.keys.pressed.RIGHT){
			justMoved = true;
			this.x += SPEED;
		}
		
		if(FlxG.keys.justPressed.F){
			trace(x +"=" + y);
			//DO ACTIONS
			
			//PICK UP item
			var res:Bool = WDGame.getSelf().tryPickUpItem();
			
			
			
		}
		
		
		//update size with distance
		var distance = this.y - 32 * 6;
		var maxDistance = 32 * 10;
		//this.scale.x = 0.5 *  distance * distance / (maxDistance * maxDistance) + 0.5;
		this.scale.x = 0.5 *  Math.sqrt(distance )/ Math.sqrt(maxDistance) + 0.5;
		if(this.scale.x  > 1){
			this.scale.x  = 1;
		}else if(this.scale.x  < 0.5){
			this.scale.x  = 0.5;
		}
		this.scale.y = this.scale.x;
		this.centerOrigin();
	}
	
}