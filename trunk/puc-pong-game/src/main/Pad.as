package main{
	import flash.display.Shape;
	
	import mx.core.UIComponent;
	
	import spark.primitives.Rect;
	
	public class Pad extends UIComponent{
		
		/* the wall on which the pad is implemented*/
		private var mWall:String;
		
		private var mPlayerID:int;
		private var mX:int;
		private var mY:int;
		private var mWidth:int;
		private var mHeight:int;
		
		private var mRect:Shape;
		
		public function Pad(playerId:int, x:int, y:int, width:int, height:int, wall:String) {
			super();
			
			this.mX = x;
			this.mY = y;
			this.mWall = wall;
			this.mWidth = width;
			this.mHeight = height;
			this.mPlayerID = playerId;
			
			createPad();
		}
		
		private function createPad():void{
			mRect = new Shape();
			mRect.graphics.beginFill(0x454545, 1.0);
			mRect.graphics.drawRect(mX, mY, mWidth, mHeight);
			mRect.graphics.endFill();
			addChild(mRect);
		}
	}
}