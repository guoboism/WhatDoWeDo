
package data.item;

class ItemCar extends WDItem
{

    public function new()  {
        super();

        this.name = "Car";
        opName = "Play";
        this.pathOnGround = AssetPaths.CAR6__png;
        this.pathIcon = AssetPaths.CAR8__png;

        scaleOnGround = 0.3;
    }

}
