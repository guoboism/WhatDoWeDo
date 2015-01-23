package data;
import render.ItemRender;

/**
 * 物品数据基类
 * @author 
 */
class WDItem
{
	
	public var name:String;
	
	//when on ground
	public var x:Float;
	public var y:Float;
	
	public var pathOnGround:String;
	public var pathIcon:String;
	
	public var linkedRender:ItemRender;
	
	public function new() 
	{
	}
	
}