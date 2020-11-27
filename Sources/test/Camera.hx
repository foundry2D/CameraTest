package test;

import kha.math.FastMatrix3;
import kha.math.Vector2;

class Camera extends Object {

    public var origin(get,null):Vector2 = new Vector2();
	function get_origin(){
		origin.x = width* 0.5;
		origin.y = height * 0.5; 
		return origin;
	}


	public var offsetX:Float = 15;
	public var offsetY:Float = 25;

	public var zoom:Float = 1.0;
    var lastParallax = 1.0;
	public function getTransformation(parallax:Float) {
		lastParallax = parallax;
		var center = origin;
		var translation = FastMatrix3.translation(-position.x * parallax,-position.y * parallax).multmat(FastMatrix3.translation(-center.x,-center.y));
		translation = translation.multmat(FastMatrix3.rotation(rotation));
		translation.setFrom(FastMatrix3.scale(zoom, zoom).multmat(translation));
		return translation.multmat(FastMatrix3.translation(center.x,center.y));
    }
    public function lookAt(position:Vector2){
		var center = origin;
		this.position.x = position.x - center.x;
		this.position.y = position.y - center.y;
    }
    public function worldToScreen( worldPosition:Vector2 ):Vector2
    {
        return cast(getTransformation(lastParallax).multvec(cast(worldPosition)));
    }
    
    public function screenToWorld(screenPosition:Vector2):Vector2
    {
        return cast(getTransformation(lastParallax).inverse().multvec(cast(screenPosition)));
    }
}