package {
	import binding2.Binding2;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author michal.przybys at gmail.com
	 */
	
	 [SWF(width="400", height="400")]
	public class Main extends Sprite {
		
		private var blue:Circle;
		private var red:Circle;
		
		private var factor:int = 0;
		
		public function Main():void {
			graphics.beginFill(0xCCCCCC);
			graphics.drawRoundRect(0, 0, 400, 400, 20, 20);
			graphics.endFill();
			
			blue = new Circle(0x0000FF);
			addChild(blue);
			
			red = new Circle(0xFF0000);
			addChild(red);
			
			Binding2.bind(blue, 'x', red, 'y');
			Binding2.bind(blue, 'y', red, 'x');
			Binding2.bind(blue, "alpha", red, "alpha");
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function onEnterFrame(e:Event):void {
			
			blue.x = 50 * Math.sin(factor * 0.01) + 200;
			blue.y = 50 * Math.cos(factor * 0.01) + 200;
			factor += 1;
		}
		
		private function onClick(e:MouseEvent):void {
			blue.alpha = Math.random();
			blue.dispatchEvent(new Event(Event.CHANGE));
		}
		
	}
	
}
import flash.display.Shape;
import flash.events.Event;

class Circle extends Shape {
	
	public function Circle(color:uint = 0x0) {
		super();
		graphics.beginFill(color);
		graphics.drawCircle(0, 0, 50);
		graphics.endFill();
	}
	
	override public function get x():Number {
		return super.x;
	}
	
	override public function set x(value:Number):void {
		var changed:Boolean = (x != value);
		super.x = value;
		if (changed) dispatchEvent(new Event(Event.CHANGE));
	}
	
	override public function get y():Number {
		return super.y;
	}
	
	override public function set y(value:Number):void {
		var changed:Boolean = (y != value);
		super.y = value;
		if (changed) dispatchEvent(new Event(Event.CHANGE));
	}
	
}