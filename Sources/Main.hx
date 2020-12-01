package;

import kha.math.FastMatrix3;
import kha.input.KeyCode;
import kha.input.Keyboard;
import kha.math.Vector2;
import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import test.*;

class Main {
	static var objects:Array<Object> = [];
	static var camera:Camera;
	static var unZoom:Bool = false;
	static var zoom:Bool = false;
	static var playerMove:Vector2 = new Vector2();
	static var lastZoom:Bool = true;
	static var lastUnZoom:Bool = true;
	static var isRotate:Bool = false;
	static var isLookAt:Bool = true; 

	inline public static var PI = 3.141592653589793;

	inline static var d2r = PI / 180 ;
	public static function degToRad(degrees:Float):Float {
		return degrees * d2r;
	}

	inline static var r2d = 180 / PI;
	public static function radToDeg(radians:Float):Float {
		return radians * r2d;
	}

	static function update(): Void {
		if(zoom && lastZoom != zoom && camera.zoom < 2.0){
			camera.zoom += 0.1;
		}
		if(unZoom && lastUnZoom != unZoom  && camera.zoom > 0.2){
			camera.zoom -= 0.1;
		}
		if(isRotate){
			camera.rotation +=0.01;
		}
		if(playerMove.x != 0 && isLookAt){
			// camera.position.x += playerMove.x;
		}
		if(playerMove.y != 0 && isLookAt){
			// camera.position.y += playerMove.y;
		}
		if(isLookAt)
			camera.lookAt(objects[1]);
		else
			camera.move(playerMove,true);
		lastZoom = zoom;
		lastUnZoom = unZoom;

	}

	static function render(frames: Array<Framebuffer>): Void {
		final fb = frames[0];
		final g2 = fb.g2;
		// Start drawing, and clear the framebuffer to `petrol`
		if(g2.font == null) g2.font = Assets.fonts.font_default;
		g2.fontSize = 20;
		g2.begin(true, Color.fromBytes(0, 95, 106));
		var text = "Zoom level is: " + camera.zoom + "rotation is: " + radToDeg(camera.rotation);
		g2.drawString(text,System.windowWidth() -300,0);

		var lastLayer = -1;
		for(obj in objects){
			if(lastLayer != obj.layer){
				if(lastLayer > -1){
					g2.popTransformation();
				}
				g2.pushTransformation(camera.getTransformation(obj.parallax));
				lastLayer = obj.layer;
			}
			var pos = obj.position.mult(camera.zoom);
			g2.pushTranslation(pos.x,pos.y);
			obj.render(g2);
			g2.popTransformation();
		}

		g2.popTransformation();

		g2.end();
	}
	static function down(keycode:KeyCode){
		if(keycode == KeyCode.F1 )
		{
			zoom = true;	
		}
		else if(keycode == KeyCode.F2 ){
			unZoom = true;
		}
		else if(keycode == KeyCode.F3 ){
			isRotate = true;
		}
		else if (keycode == KeyCode.Up){
			playerMove.y = -1;
		}
		else if (keycode == KeyCode.Down){
			playerMove.y = 1;
		}
		else if (keycode == KeyCode.Left){
			playerMove.x = -1;
		}
		else if (keycode == KeyCode.Right){
			playerMove.x = 1;
		}
	}
	static function up(keycode:KeyCode){
		if(keycode == KeyCode.F1)
		{
			zoom = false;	
		}
		else if(keycode == KeyCode.F2){
			unZoom = false;
		}
		else if(keycode == KeyCode.F3 ){
			isRotate = false;
		}
		else if (keycode == KeyCode.Up){
			playerMove.y = 0;
		}
		else if (keycode == KeyCode.Down){
			playerMove.y = 0;
		}
		else if (keycode == KeyCode.Left){
			playerMove.x = 0;
		}
		else if (keycode == KeyCode.Right){
			playerMove.x = 0;
		}
	}
	public static function main() {
		System.start({title: "Project", width: 1024, height: 768}, function (_) {
			// Just loading everything is ok for small projects
			Assets.loadEverything(function () {
				// Avoid passing update/render directly,
				// so replacing them via code injection works
				for(i in 0...3){
					if( i > 1)
						objects.push(new Object(100,100));
					switch(i){
						case 1:
							objects.push(new Sprite());
						case 0:
							objects.push(new Sprite("backgroundEmpty",1,0.2));
							objects[i].position = new Vector2(500,500);
							
						case 2:
							objects[i].width*= 2;
							objects[i].height*= 2;
							objects[i].position = new Vector2(500,500);
							objects[i].color = kha.Color.Green;
					}
						
				}
				camera = new Camera(System.windowWidth(),System.windowHeight());
				Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
				System.notifyOnFrames(function (frames) { render(frames); });
				Keyboard.get(0).notify(down,up);
			});
		});
	}
}
