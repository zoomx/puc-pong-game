package main{
	
	import flash.display.CapsStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import spark.primitives.Path;
	
	public class Wall extends Sprite{
		
		private var mIsSolid:Boolean;
		private var mType:uint;
		private var mStartX:int;
		private var mStartY:int;
		private var mStopX:int;
		private var mStopY:int;
		
		private var mLine:Shape;
		
		/* each static variable represents one side of the octagon for easy identification and works as the id of the wall */
		/* horizontal lines*/
		public static var H1:String = "H1";
		public static var H2:String = "H2";
		
		/* vertical lines */
		public static var V1:String = "V1";
		public static var V2:String = "V2";
		
		/* diagonal lines*/
		public static var D1:String = "D1";
		public static var D2:String = "D2";
		public static var D3:String = "D3";
		public static var D4:String = "D4";
		
		public static var PLAYER_WALL:int = 0;
		public static var NON_PLAYER_WALL:int = 1;
		
		public function Wall(startX:int, startY:int, stopX:int, stopY:int){
			super();
			
			this.mStartX = startX;
			this.mStartY = startY;
			this.mStopX = stopX;
			this.mStopY = stopY;
			
			createWall();
		}
		
		public function createWall():void{
			mLine = new Shape();
			mLine.graphics.lineStyle(12, 0x757575, 1.0, false, "normal", CapsStyle.ROUND);
			mLine.graphics.moveTo(mStartX, mStartY);
			mLine.graphics.lineTo(mStopX, mStopY);
			addChild(mLine);
		}
		
		public function getWall():Sprite{
			return this;
		}
	}
}