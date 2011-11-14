package main {
	import flash.display.Shape;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	public class Ball extends UIComponent{
		
		private var mCircle:Shape;
		
		public var mPosition:Point;
		private var mDirection:Point;
		
		private var mRadius:int = 12;
		public var mVelocity:int = 2;
	
		public function Ball(startX:int, startY:int) {
			super();
			this.mPosition = new Point(startX, startY);
			this.mDirection = new Point(0, mVelocity);
			createBall();
		}
		
		private function createBall():void{
			mCircle = new Shape();
			mCircle.graphics.beginFill(0xababab, 1.0);
			mCircle.graphics.drawCircle(mPosition.x, mPosition.y, mRadius);
			mCircle.graphics.endFill();
			addChild(mCircle);
		}
		
		public function moveBall():void{
			removeChild(mCircle);
			mPosition.x += mDirection.x;
			mPosition.y += mDirection.y;
			createBall();
		}
		
		public function changeDirection(direction:Point):void{
			mDirection = direction;
		}
		
		public function getBall():UIComponent{
			return this;
		}
	}
}