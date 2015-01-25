package data.item;

/**
 * ...
 * @author
 */
class ItemStone extends WDItem
{

	public function new()
	{
		super();

		this.name = "STONE";
		opName = "THROW";
		this.pathOnGround = AssetPaths.STONE1__png;
		this.pathIcon = AssetPaths.STONE1__png;

		scaleOnGround = 0.2;
	}

}