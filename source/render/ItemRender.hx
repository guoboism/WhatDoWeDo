package render;

import data.WDItem;
import flixel.FlxSprite;

/**
 * 用于渲染地面上的物品
 * @author
 */
class ItemRender extends FlxSprite {

    public var itemData:WDItem;

    public function new(item:WDItem) {
        super();
        itemData = item;
        renderSelf();
    }

    public function renderSelf():Void {
        loadGraphic(itemData.pathOnGround);
        x = itemData.x;
        y = itemData.y;

        //scale with distance
        var distance = this.y - 32 * 6+1;
        var maxDistance = 32 * 10;
        this.scale.x = 0.5 *  Math.sqrt(distance )/ Math.sqrt(maxDistance) + 0.5;
        if (this.scale.x  > 1) {
            this.scale.x  = 1;
        }
        else if (this.scale.x  < 0.5) {
            this.scale.x  = 0.5;
        }
        this.scale.y = this.scale.x;
        centerOrigin();
        centerOffsets();
    }

}
