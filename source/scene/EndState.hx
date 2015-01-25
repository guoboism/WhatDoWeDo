package scene;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

/**
 * ...
 * @author 
 */
class EndState extends FlxState
{
	
	
	public var endText1:String = "yet you enjoyed every bit of your last time";
	public var endText2:String = "You waste all your time to live, in vain";
	public var endText3:String = "You found everything, but lose them all to death";
	public var endText4:String = "You didn't do anything...";
	
	
	override public function create():Void 
	{
		super.create();
		
		//var title
		var title:FlxText = new FlxText(480 - 400, 30, 800, "Game Over", 128);
		title.color = 0xFFFFFF;
		title.font = AssetPaths.f28DaysLater__ttf;
		title.alignment = "center";
		add(title);
		
		var endText:FlxText = new FlxText(480 - 500, 200, 1000, endText1, 48);
		endText.color = 0xFFFFFF;
		endText.font = AssetPaths.f28DaysLater__ttf;
		endText.alignment = "center";
		add(endText);
		
		var replatText:FlxText = new FlxText(480 - 400, 500, 800, "Play Again", 72);
		replatText.color = 0xFFFFFF;
		replatText.font = AssetPaths.Anton__ttf;
		replatText.alignment = "center";
		add(replatText);
		
		
		FlxG.sound.playMusic(AssetPaths.nightmare__mp3);
	}
	
	override public function update():Void 
	{
		super.update();
		
		if(FlxG.mouse.justPressed){
			onPlayAgain();
		}
		
	}
	
	function onPlayAgain():Void{
		FlxG.switchState(new MenuState());
	}
	
}