package scene;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState {

    private var _playButton:FlxButton;

    /**
     * Function that is called up when to state is created to set it up.
     */
    override public function create():Void {
        super.create();
	
		var titlePic:FlxSprite = new FlxSprite();
		titlePic.loadGraphic(AssetPaths.img_title__png);
		add(titlePic);
		
		FlxG.sound.playMusic(AssetPaths.nightmare__mp3);
    }

    /**
     * Function that is called when this state is destroyed - you might want to
     * consider setting all objects this state uses to null to help garbage collection.
     */
    override public function destroy():Void {
        super.destroy();
    }

    private function onPlay():Void {
        FlxG.switchState(new PlayState());
		FlxG.sound.play(AssetPaths.menu_click__wav);
    }

    /**
     * Function that is called once every frame.
     */
    override public function update():Void {
        super.update();
		
		if(FlxG.mouse.justPressed){
			onPlay();
		}
    }

}
