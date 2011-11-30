package main{
	
	import flash.display.CapsStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import mx.containers.utilityClasses.PostScaleAdapter;
	
	import spark.primitives.Path;
	
	public class Wall extends Sprite{
		
		public var mIsSolid:Boolean;
		private var mType:uint;
		
		public var mStartX:int;
		public var mStartY:int;
		public var mStopX:int;
		public var mStopY:int;
		
		public var mLastHit:Boolean = false;
				
		private var mLine:Shape;
		
		/* each static variable represents one side of the octagon for easy identification and works as the name of the wall */
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
			mLine.graphics.lineStyle(20, 0x757575, 1.0, false, "normal", CapsStyle.ROUND);
			mLine.graphics.moveTo(mStartX, mStartY);
			mLine.graphics.lineTo(mStopX, mStopY);
			addChild(mLine);
		}
		
		public function getWall():Sprite{
			return this;
		}
		
		/* function detects collision between the ball and the walls */
		public function hits(ball:Ball):Boolean{
			
			if(name == Wall.H1){
				return mLine.hitTestPoint(ball.mPosition.x, ball.mPosition.y - (ball.mRadius), true);
			}
			else if(name == Wall.H2){
				return mLine.hitTestPoint(ball.mPosition.x, ball.mPosition.y  + (ball.mRadius), true);
			}
			else if(name == Wall.V1){
				return mLine.hitTestPoint(ball.mPosition.x + (ball.mRadius), ball.mPosition.y, true);
			}
			else if(name == Wall.V2){
				return mLine.hitTestPoint(ball.mPosition.x - (ball.mRadius), ball.mPosition.y, true);
			}
			else if(name == Wall.D1){				 
				return mLine.hitTestPoint(ball.mPosition.x, ball.mPosition.y, true);
			}
			else if(name == Wall.D2){
				return mLine.hitTestPoint(ball.mPosition.x, ball.mPosition.y, true);
			}
			else if(name == Wall.D3){
				return mLine.hitTestPoint(ball.mPosition.x, ball.mPosition.y, true);
			}
			else if(name == Wall.D4){
				return mLine.hitTestPoint(ball.mPosition.x, ball.mPosition.y, true);
			}
			else{
				return false;
			}
		}
	}
}