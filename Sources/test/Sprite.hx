package test;

import kha.math.Vector2;

class Sprite extends Object {
    var image:kha.Image;
    public function new(?imageName:String = null,?layer:Int = 0,?parallax:Float = 1.0) {
        super(100,100,layer,parallax);
        image = imageName == null ? kha.Assets.images.bird : kha.Assets.images.get(imageName);
        width = image.width;
        height = image.height;
    }
    public var flip:Vector2 = new Vector2();
    public override function render(g:kha.graphics2.Graphics) {
        var w = width;
        var h = height;
        g.color = kha.Color.White;
        g.drawScaledSubImage(image,0 , 0, w, h, (flip.x > 0.0 ? w:0), (flip.y > 0.0 ? h:0), (flip.x > 0.0 ? -w:w), (flip.y > 0.0 ? -h:h));
    
    }
}