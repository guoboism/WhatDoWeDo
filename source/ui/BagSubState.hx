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
import scene.PlayState;

import render.CarEntity;
import render.StoneEntity;

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
	public var bottomBtn:FlxButton;

	private var PAGE_BTN_OFFSET:Int = 370;

	public function new(BGColor:Int=FlxColor.TRANSPARENT)
	{
		super(BGColor);
		
		var titleBg:FlxSprite = new FlxSprite(480, 0);
		titleBg.loadGraphic(AssetPaths.title__fw__png);
		titleBg.x = 480 - titleBg.frameWidth / 2;
		add(titleBg);
		
		//add bg
		var bg:FlxSprite = new FlxSprite(0,0);
		bg.loadGraphic(AssetPaths.bagbg__fw__png);
		bg.setSize(800, 600);
		bg.centerOrigin();
		bg.x = 480 - bg.frameWidth / 2;
		bg.y = 320 - bg.frameHeight / 2;
		add(bg);

		//big item to render
		bigItem = new FlxSprite(480, 320);
		bigItem.visible = false;
		add(bigItem);

		//arrow btn
		var arrowBtn1:FlxButton = new FlxButton(480-PAGE_BTN_OFFSET, 255, "", onLeft);
		arrowBtn1.loadGraphic(AssetPaths.pagebutton__fw__png);
		arrowBtn1.x -= arrowBtn1.frameWidth / 2;
		add(arrowBtn1);

		var arrowBtn2:FlxButton = new FlxButton(480+PAGE_BTN_OFFSET, 255, "", onRight);
		arrowBtn2.loadGraphic(AssetPaths.pagebutton__fw__png);
		arrowBtn2.x -= arrowBtn2.frameWidth / 2;
		arrowBtn2.flipX = true;
		add(arrowBtn2);

		//add close function
		var closeBtn:FlxButton = new FlxButton(766, 123, "", onClose);
		closeBtn.loadGraphic(AssetPaths.exitbutton__fw__png);
		add(closeBtn);

		//var title
		title = new FlxText(480-400, 0, 800, "NO ITEM", 96);
		title.font = AssetPaths.Anton__ttf;
		title.alignment = "center";
		add(title);

		//bottom btn
		bottomBtn = new FlxButton(480, 505, "", onAction);
		bottomBtn.loadGraphic(AssetPaths.throwbutton__fw__png);
		bottomBtn.x -= bottomBtn.frameWidth / 2;
		add(bottomBtn);
		
		//bottom text
		btnText = new FlxText(480-400, bottomBtn.y + 20, 800, "THROW", 64);
		btnText.font = AssetPaths.Anton__ttf;
		btnText.alignment = "center";
		add(btnText);
		
		renderItem();
		
		//sound open
		FlxG.sound.play(AssetPaths.open_box__wav);
	}

	public function renderItem():Void{


		if(WDGame.getSelf().bagItems.length == 0){
			//no item to show
			
			bigItem.visible = false;
			btnText.visible = false;
			bottomBtn.visible = false;
		}else{

			var wdItem:WDItem = WDGame.getSelf().bagItems[curSelInd];
			bigItem.loadGraphic(wdItem.pathIcon);
			bigItem.x = 480 - bigItem.frameWidth * bigItem.scale.x / 2;
			bigItem.y = 320 - bigItem.frameHeight * bigItem.scale.y / 2;
			bigItem.visible = true;
			//update bottom content

			title.text = wdItem.name;
			btnText.text = wdItem.opName;
			btnText.visible = true;
			bottomBtn.visible = true;
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
		
		//sound close
		FlxG.sound.play(AssetPaths.Close_box__wav);
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

	function onAction():Void {
		var wdItem:WDItem = WDGame.getSelf().bagItems[curSelInd];
		if(wdItem == null){
			return;
		}
		
		if (wdItem.name == "CAR") {
			
			var state:PlayState = cast this._parentState;
			var carEntity:CarEntity = new CarEntity(wdItem);
			carEntity.makeCarRun(state._player.x, state._player.y, state._player._lastFacing);
			state.cars.add(carEntity);
			state._itemGroup.add(carEntity);
			state.entities.add(carEntity);
			
			wdItem.linkedRender = carEntity;
			WDGame.getSelf().listItemOnGround.push(wdItem);
			
			this.onClose();
		}
		else if (wdItem.opName == "THROW") {
			var state:PlayState = cast this._parentState;
			var stoneEntity:StoneEntity = new StoneEntity(state._player.x, state._player.y, state._player._lastFacing);
			state.entities.add(stoneEntity);
			this.onClose();
		}
		
		//delete this item
		WDGame.getSelf().bagItems.remove(wdItem);
	}

}