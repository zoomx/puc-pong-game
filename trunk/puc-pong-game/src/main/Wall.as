package main{
	
	import flash.display.CapsStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import spark.primitives.Path;
	
	public class Wall extends Sprite{
		
		private var mIsSolid:Boolean;
		private var mType:uint;
		private var mId:int;
		private var mStartX:int;
		private var mStartY:int;
		private var mStopX:int;
		private var mStopY:int;
		
		private var mLine:Shape;
		
		/* each static variable represents one side of the octagon for easy identification and works as the id of the wall */
		/* horizontal lines*/
		public static var H1:int = 0;
		public static var H2:int = 1;
		
		/* vertical lines */
		public static var V1:int = 2;
		public static var V2:int = 3;
		
		/* diagonal lines*/
		public static var D1:int = 4;
		public static var D2:int = 5;
		public static var D3:int = 6;
		public static var D4:int = 7;
		
		public static var PLAYER_WALL:int = 0;
		public static var NON_PLAYER_WALL:int = 1;
		
		public function Wall(id:int, startX:int, startY:int, stopX:int, stopY:int){
			super();
			
			this.mStartX = startX;
			this.mStartY = startY;
			this.mStopX = stopX;
			this.mStopY = stopY;
			
			createWall();
		}
		
		public function createWall():void{
			mLine = new Shape();
			mLine.graphics.lineStyle(25, 0x757575, 1.0, false, "normal", CapsStyle.ROUND);
			mLine.graphics.moveTo(mStartX, mStartY);
			mLine.graphics.lineTo(mStopX, mStopY);
			addChild(mLine);
		}
		
		public function getWall():Sprite{
			return this;
		}
	}
}