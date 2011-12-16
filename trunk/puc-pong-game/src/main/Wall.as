package main{
	
	import flash.display.CapsStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.utilityClasses.PostScaleAdapter;
	import mx.core.FlexGlobals;
	
	import spark.primitives.Path;
	
	public class Wall extends Sprite{
		
		public var mIsSolid:Boolean;
		private var mType:uint;
		
		public var mStartX:int;
		public var mStartY:int;
		public var mStopX:int;
		public var mStopY:int;
		
		public var minValue:Number = 90;
		public var maxValue:Number = 155;
		
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
			
			if(Game.CURVES_BY_MOUSE)addEventListener(Event.ENTER_FRAME, changeWalls);
			
		}
		
		private function createWall():void{
			if(mLine != null && contains(mLine)){
			removeChild(mLine);
			}
			mLine = new Shape();
			mLine.graphics.lineStyle(20, 0x757575, 1.0, false, "normal", CapsStyle.ROUND);
			mLine.graphics.moveTo(mStartX, mStartY);
			mLine.graphics.lineTo(mStopX, mStopY);
			addChild(mLine);
		}
		
		//only used with mouse control (test function)
		private function changeWalls(e:Event):void{
			bendWall(mouseY/4);
		}
		
		private var xx:int;
		private var xxx:int = 0;
		private var bi:int = 0;
		//test function to display the incoming microphone values
		private function createDot(val:int):void{
			var dot:Shape = new Shape();
			dot.graphics.beginFill(0x00ff00,1);
			dot.graphics.drawEllipse(xx, (val) + xxx, 2, 2);

			xx++;	
			
			if(xx > 1680){
				xxx +=250;
				xx = 0;
			}
			addChild(dot);
		}
			
		//bends the wall according to the received volume value
		public function bendWall(val:int):void {
			removeChild(mLine);
			createDot(val);
			trace(FlexGlobals.topLevelApplication.STAGE.height);
if(val >= minValue && val <= maxValue){ val = 899/4; }
				
				mLine = new Shape();
				mLine.graphics.lineStyle(20, 0x757575, 1.0, false, "normal", CapsStyle.ROUND);
				mLine.graphics.moveTo(mStartX, mStartY);
				
				if(name == Wall.D1){
					mLine.graphics.curveTo(mStartX+(0.5*val), mStopY-(0.5*val), mStopX, mStopY);
				}
				else if(name == Wall.D3){
				mLine.graphics.curveTo(mStartX-(0.5*val), mStopY+(0.5*val), mStopX, mStopY);	
				}
				else if(name == Wall.D2){
					mLine.graphics.curveTo(mStopX+(0.5*val), mStartY+(0.5*val), mStopX, mStopY);
				} else if (name == Wall.D4){
					mLine.graphics.curveTo(mStopX-(0.5*val), mStartY-(0.5*val), mStopX, mStopY);
				}
				else { createWall(); }


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