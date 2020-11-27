package test;

import kha.math.Vector2;

class Object {
    public var position:Vector2 = new Vector2();
    public var rotation:Float = 0.0;
    public var parallax:Float = 1.0;
    public var width:Float;
    public var height:Float;
    public var center(get,never):Vector2;
	function get_center() {
		return new Vector2(position.x + 0.5 * width, position.y + 0.5 * height);
	}
    public var color:kha.Color = kha.Color.Red;
    public function new(width:Float,height:Float){
        this.width = width;
        this.height = height;
    }
    public function render(g:kha.graphics2.Graphics){
        g.color = color;
        g.fillRect(0,0,width,height);
        g.color = kha.Color.White;
    }
}