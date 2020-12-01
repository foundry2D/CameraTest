package test;

import kha.math.FastMatrix3;
import kha.math.Vector2;

class Camera extends Object {

    public var origin(get,null):Vector2 = new Vector2();
	function get_origin(){
		origin.x = width * 0.5;
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
		var transformation = FastMatrix3.identity();
		transformation.setFrom(FastMatrix3.scale(zoom,zoom).multmat(transformation));
		transformation.setFrom(FastMatrix3.translation(center.x, center.y).multmat(FastMatrix3.rotation(rotation)).multmat(FastMatrix3.translation(-center.x, -center.y)).multmat(transformation));
		transformation.setFrom(FastMatrix3.translation(center.x, center.y).multmat(transformation));
		transformation.setFrom(FastMatrix3.translation(-position.x*parallax, -position.y*parallax).multmat(transformation));
		return transformation;
	}
	
	public function move(movement:Vector2,considerRotation = false) {
		if (considerRotation)
		{
			movement = cast(FastMatrix3.rotation(rotation).multvec(cast(movement)));
		}
		this.position.x += movement.x;
		this.position.y += movement.y;
		
		
	}

    public function lookAt(obj:Object){
		this.position.x = (obj.position.x + obj.width * 0.5) * zoom;
		this.position.y = (obj.position.y + obj.height * 0.5) * zoom;
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