package data.item;

/**
 * ...
 * @author 
 */
class ItemEgg extends WDItem
{

	public function new() 
	{
		super();
		
		this.name = "egg";
		this.pathOnGround = AssetPaths.img_itemG1__png;
		this.pathIcon = AssetPaths.img_ico_egg__png;
	}
	
}