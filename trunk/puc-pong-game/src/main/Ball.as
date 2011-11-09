package main {
	import flash.display.Shape;
	
	import mx.core.UIComponent;
	
	public class Ball extends UIComponent{
		
		private var mBall:Shape;
	
		public function Ball() {
			createBall();
		}
		
		private function createBall():void{
			mBall = new Shape();
			mBall.graphics.beginFill(0x000000, 1.0);
			mBall.graphics.drawCircle(50,50,15);
			mBall.graphics.endFill();
			addChild(mBall);
		}
		
		public function getBall():UIComponent{
			return this;
		}
	}
}