package main{
	import flash.display.Shape;
	
	import mx.core.UIComponent;
	
	import spark.primitives.Rect;
	
	public class Pad extends UIComponent{
		
		/* the wall on which the pad is implemented*/
		private var mWall:String;
		
		public var mX:int;
		public var mY:int;
		public var mWidth:int;
		public var mHeight:int;
		
		public var mLastHit:Boolean = false;
		
		private var mLeftMax:int;
		private var mRightMax:int;
		private var mPlayerID:int;
		
		private var mRect:Shape;
		
		public function Pad(playerId:int, x:int, y:int, width:int, height:int, wall:String, left:int, right:int) {
			super();
			
			this.mX = x;
			this.mY = y;
			this.mWall = wall;
			this.mWidth = width;
			this.mHeight = height;
			this.mPlayerID = playerId;
			this.mLeftMax = left;
			this.mRightMax = right;
			
			createPad();
		}
		
		private function createPad():void{
			mRect = new Shape();
			mRect.graphics.beginFill(0x454545, 1.0);
			mRect.graphics.drawRect(mX, mY, mWidth, mHeight);
			mRect.graphics.endFill();
			addChild(mRect);
		}
		
		public function movePad(mouseX:int, mouseY:int):void{
			if(mWall == Wall.H1){
				if(mouseX <= mLeftMax){
					mX = mLeftMax;
					removeChild(mRect);
					createPad();
				}
				else if(mouseX >= (mRightMax - mRect.width)){
					mX = mRightMax - mRect.width;
					removeChild(mRect);
					createPad();
				}else{
					mX = mouseX;
					removeChild(mRect);
					createPad();
				}
			}
			else if(mWall == Wall.H2){
				if(mouseX <= mLeftMax){
					mX = mLeftMax;
					removeChild(mRect);
					createPad();
				}
				else if(mouseX >= (mRightMax - mRect.width)){
					mX = mRightMax - mRect.width;
					removeChild(mRect);
					createPad();
				}else{
					mX = mouseX;
					removeChild(mRect);
					createPad();
				}				
			}
			else if(mWall == Wall.V1){
				if(mouseY <= mLeftMax){
					mY = mLeftMax;
					removeChild(mRect);
					createPad();
				}
				else if(mouseY >= (mRightMax - mRect.height)){
					mY = mRightMax - mRect.height;
					removeChild(mRect);
					createPad();
				}else{
					mY = mouseY;
					removeChild(mRect);
					createPad();
				}				
			}
			else if(mWall == Wall.V2){
				if(mouseY <= mLeftMax){
					mY = mLeftMax;
					removeChild(mRect);
					createPad();
				}
				else if(mouseY >= (mRightMax - mRect.height)){
					mY = mRightMax - mRect.height;
					removeChild(mRect);
					createPad();
				}else{
					mY = mouseY;
					removeChild(mRect);
					createPad();
				}		
			}
		}
		
		public function getWall():String{
			return mWall;
		}
		
		public function hits(ball:Ball):Boolean{
			return mRect.hitTestObject(ball);
		}
	}
}