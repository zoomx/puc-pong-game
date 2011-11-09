package main {
	import flash.display.Shape;
	
	import mx.core.UIComponent;
	
	public class Ball extends UIComponent{
		
		private var mCircle:Shape;
	
		public function Ball() {
			super();
			createBall();
		}
		
		private function createBall():void{
			mCircle = new Shape();
			mCircle.graphics.beginFill(0xefefef, 1.0);
			mCircle.graphics.drawCircle(50,50,15);
			mCircle.graphics.endFill();
			addChild(mCircle);
		}
		
		public function getBall():UIComponent{
			return this;
		}
	}
}