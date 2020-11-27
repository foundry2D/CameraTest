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
	static function update(): Void {
		if(zoom && lastZoom != zoom && camera.zoom < 2.0){
			camera.zoom += 0.1;
		}
		if(unZoom && lastUnZoom != unZoom  && camera.zoom > 0.2){
			camera.zoom -= 0.1;
		}
		if(playerMove.x != 0){
			objects[0].position.x += playerMove.x;
		}
		if(playerMove.y != 0){
			objects[0].position.y += playerMove.y;
		}
		camera.lookAt(objects[0].center);
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
		var text = "Zoom level is: " + camera.zoom;
		g2.drawString(text,System.windowWidth() -300,0);

		g2.pushTransformation(camera.getTransformation(1.0));

		for(obj in objects){
			var pos = obj.position;
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
						case 0:
							objects.push(new Sprite());
						case 1:
							objects.push(new Sprite());
							objects[i].position = new Vector2(100,100);
							
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
