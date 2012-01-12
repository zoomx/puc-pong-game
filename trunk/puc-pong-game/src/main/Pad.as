package main{
	import flash.display.Shape;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	import spark.primitives.Rect;
	
	public class Pad extends UIComponent{
		
		/* the wall on which the pad is implemented*/
		private var mWall:String;
		
		public var mPostion:Point;
		public var mWidth:int;
		public var mHeight:int;
		
		public var mLastHit:Boolean = false;
		
		private var mLeftMax:int;
		private var mRightMax:int;
		private var mPlayerID:int;
		
		private var mRect:Shape;
		
		public function Pad(playerId:int, x:int, y:int, width:int, height:int, wall:String, left:int, right:int) {
			super();
			
			this.mPostion = new Point(x,y);
			this.mWall = wall;
			this.mWidth = width;
			this.mHeight = height;
			this.mPlayerID = playerId;
			this.mLeftMax = left;
			this.mRightMax = right;
			
			createPad();
		}
		
		/* creates a pad made by a rectangle */
		private function createPad():void{
			mRect = new Shape();
			mRect.graphics.beginFill(0xdadada, 1.0);
			mRect.graphics.drawRect(mPostion.x, mPostion.y, mWidth, mHeight);
			mRect.graphics.endFill();
			addChild(mRect);
		}
		
		/* calculates the movement of a pad by a single sensor value */
		public function movePad(value:int):void{
			if(mWall == Wall.H1 || mWall == Wall.H2){
				mPostion.x = Math.max(mLeftMax, Math.min(mRightMax - mRect.width, value));
				removeChild(mRect);
				createPad();
			}
			else if(mWall == Wall.V1 || mWall == Wall.V2){
				mPostion.y = Math.max(mLeftMax, Math.min(mRightMax - mRect.height, value));
				removeChild(mRect);
				createPad();				
			}
		}
		
		/* [test function] move the pad by mouse values */
		public function movePadByMouse(mouseX:int, mouseY:int):void{
			if(mWall == Wall.H1 || mWall == Wall.H2){
				mPostion.x = Math.max(mLeftMax, Math.min(mRightMax - mRect.width, mouseX));
				removeChild(mRect);
				createPad();
			}
			else if(mWall == Wall.V1 || mWall == Wall.V2){
				mPostion.y = Math.max(mLeftMax, Math.min(mRightMax - mRect.height, mouseY));
				removeChild(mRect);
				createPad();			
			}
		}
		
		/* returns the wall a pad belongs to */
		public function getWall():String{
			return mWall;
		}
		
		/* returns if a ball hits a pad or not*/
		public function hits(ball:Ball):Boolean{
			return mRect.hitTestObject(ball);
		}
		
		public  function getPadSize(wall:String):int{
			if(wall == Wall.H1 || wall == Wall.H2) return mWidth;
			else return mHeight;
		}
	}
}