package ui;

import data.WDItem;
import flixel.effects.FlxSpriteFilter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import source.data.WDGame;

/**
 * ...
 * @author 
 */
class BagSubState extends FlxSubState
{
	
	
	public var curSelInd:Int = 0;//from 0
	public var bigItem:FlxSprite;
	public var title:FlxText;
	public var btnText:FlxText;
	
	public function new(BGColor:Int=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		
		
		//add bg
		var bg:FlxSprite = new FlxSprite(120,140);
		bg.loadGraphic(AssetPaths.bagbg__fw__png);
		bg.x = 480 - bg.frameWidth / 2;
		bg.y = 320 - bg.frameHeight / 2;
		add(bg);
		
		//add event
		
		//big item to render
		bigItem = new FlxSprite(480,320);
		add(bigItem);
		
		//arrow btn
		var arrowBtn1:FlxButton = new FlxButton(480-220, 255, "", onLeft);
		arrowBtn1.loadGraphic(AssetPaths.pagebutton__fw__png);
		arrowBtn1.x -= arrowBtn1.frameWidth / 2;
		add(arrowBtn1);
		
		var arrowBtn2:FlxButton = new FlxButton(480+220, 255, "", onRight);
		arrowBtn2.loadGraphic(AssetPaths.pagebutton__fw__png);
		arrowBtn2.x -= arrowBtn2.frameWidth / 2;
		arrowBtn2.flipX = true;
		add(arrowBtn2);
		
		//add close function
		var closeBtn:FlxButton = new FlxButton(766, 123, "", onClose);
		closeBtn.loadGraphic(AssetPaths.exitbutton__fw__png);
		add(closeBtn);
		
		//var title
		title = new FlxText(480-400, 160, 800, "No Item", 96);
		title.font = AssetPaths.Anton__ttf;
		title.alignment = "center";
		add(title);
		
		//bottom btn
		var bottomBtn:FlxButton = new FlxButton(480, 395, "", onAction);
		bottomBtn.loadGraphic(AssetPaths.throwbutton__fw__png);
		bottomBtn.x -= bottomBtn.frameWidth / 2;
		add(bottomBtn);
		
		
		//bottom text
		btnText = new FlxText(480-400, bottomBtn.y + 20, 800, "Throw", 64);
		btnText.font = AssetPaths.Anton__ttf;
		btnText.alignment = "center";
		add(btnText);
		
		renderItem();
	}
	
	public function renderItem():Void{
		
		
		if(WDGame.getSelf().bagItems.length == 0){
			//no item to show
			
		}else{
			
			var wdItem:WDItem = WDGame.getSelf().bagItems[curSelInd];
			bigItem.loadGraphic(wdItem.pathIcon);
			bigItem.x = 480 - bigItem.frameWidth * bigItem.scale.x / 2;
			bigItem.y = 320 - bigItem.frameHeight * bigItem.scale.y / 2;
			//update bottom content
			
			title.text = wdItem.name;
			btnText.text = wdItem.opName;
		}
	}
	
	
	override public function update():Void 
	{
		super.update();
		
		if(FlxG.keys.justReleased.ESCAPE){
			this._parentState.closeSubState();
		}
	}
	
	function onClose():Void{
		this._parentState.closeSubState();
	}
	
	function onLeft():Void{
		curSelInd--;
		if(curSelInd <= 0){
			curSelInd = WDGame.getSelf().bagItems.length-1;
		}
		renderItem();
	}
	
	function onRight():Void{
		curSelInd++;
		if(curSelInd >= WDGame.getSelf().bagItems.length){
			curSelInd = 0;
		}
		renderItem();
	}
	
	function onAction():Void{
		
		
	}
	
}