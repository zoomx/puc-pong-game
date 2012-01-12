package main {
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	
	import math.VectorAnalysis;
	
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	
	public class Ball extends UIComponent{
		
		public var mCircle:Shape;
		
		//current poisiton of the ball
		public var mPosition:Point;
		
		//last position of the ball
		public var mLastPosition:Point;
		
		//direction of the ball
		public var mDirection:Point;
		
		//radius of the ball
		public var mRadius:int = 12;
		
		//velocity of the ball
		public var mVelocity:Number = 1;
		
		//max velocity
		public static var MAX_VELOCITY:Number = 3.5;
	
		public function Ball(startX:int, startY:int, direction:Point) {
			super();
			direction = VectorAnalysis.normalize(direction);
			this.mPosition = new Point(startX, startY);
			this.mDirection = new Point(direction.x + mVelocity, direction.y + mVelocity);
			createBall();
		}
		



		public function createBall():void{
			mCircle = new Shape();
			mCircle.graphics.beginFill(0xababab, 1.0);
			mCircle.graphics.drawCircle(mPosition.x, mPosition.y, mRadius);
			mCircle.graphics.endFill();
			addChild(mCircle);
		}
		
		//moves the ball to a specific position
		public function moveBall():void{
			removeChild(mCircle);
			mLastPosition = mPosition.clone();
			mPosition.x += (mDirection.x * mVelocity);
			mPosition.y += (mDirection.y * mVelocity);

			createBall();
		}
		
		//changes the direction of the ball
		private function changeDirection(direction:Point):void{
			mDirection = direction;
		}
		
		//returns the ball object
		public function getBall():UIComponent{
			return this;
		}
		
		//calculates and sets a new direction for the ball if it hits a wall
		public function setNewDirection(wall:Wall):Point{
			var vWall:Point = new Point();
			var vBall:Point = new Point();
			
			if(wall.name == Wall.H1 || wall.name == Wall.H2){
				return new Point(mDirection.x, -mDirection.y);;
			}
			else if(wall.name == Wall.V1 || wall.name == Wall.V2){
				return new Point(-mDirection.x, mDirection.y);;
			}
			else{
				
				if(false){//wall.mIsBending){
					
					var dx:Number = mPosition.x + wall.mWallRadius/2 - mPosition.x;
					var dy:Number = mPosition.y + wall.mWallRadius/2 - mPosition.y;
					var len:Number = Math.sqrt(dx*dx-dy*-dy);
					
					dx = dx/len;
					dy = dy/len;
									
					//determine wall vector
					vWall = VectorAnalysis.getVector(wall.mStopX - wall.mStartX, angle);
					//determine ball vector
					vBall.x = mPosition.x - mLastPosition.x;
					vBall.y = mPosition.y - mLastPosition.y;
					
					var a_sc:Number = -vBall.x * dx - vBall.y * dy;
					var b_sc:Number = vWall.x * dx - vWall.y * -dy;
					var a_cx:Number = -dx * a_sc;
					var a_cy:Number = -dy * a_sc;
					
					var ref:Point = new Point(a_cx, a_cy);
					var nRef:Point = VectorAnalysis.normalize(ref);
					return(new Point(nRef.x * mVelocity, nRef.y * mVelocity));
				}
				else{
				
					var angle:Number;
					
					if(wall.name == Wall.D1) angle = 45;
					else if(wall.name == Wall.D2) angle = 135;
					else if(wall.name == Wall.D3) angle = 45;
					else if(wall.name == Wall.D4) angle = 135;
										
					//determine wall vector
					vWall = VectorAnalysis.getVector(wall.mStopX - wall.mStartX, angle);
					//determine ball vector
					vBall.x = mPosition.x - mLastPosition.x;
					vBall.y = mPosition.y - mLastPosition.y;
									
					var n:Point = VectorAnalysis.normalize(vWall); // normalized wall vector
					var r:Point = VectorAnalysis.getReflectionVector(vBall, n); // reflection result vector
					
					n = VectorAnalysis.normalize(r);
					
					return new Point(n.x * mVelocity, n.y * mVelocity);
				}
			}
		}
		
		//calculates and sets a new direction for the ball if it hits a pad
		public function setDirectionByPadHit(pad:Pad):Point{
			
			var angle:Number;
			var hitPoint:Number = getHitPoint(pad);
			var multiplicator:Number = 10 / (pad.getPadSize(pad.getWall()) / 2);
			
			if(pad.getWall() == Wall.H1 || pad.getWall() == Wall.H2 ) angle = 0 + (hitPoint * multiplicator);
			else if(pad.getWall() == Wall.V1 || pad.getWall() == Wall.V2) angle = 90 + (hitPoint * multiplicator);
			
			var vPad:Point = new Point();
			var vBall:Point = new Point();
			
			//determine pad vector
			if(pad.getWall() == Wall.H1 || pad.getWall() == Wall.H2 ) {
				vPad = VectorAnalysis.getVector(pad.mWidth - pad.mPostion.x, angle);
			}
			else if(pad.getWall() == Wall.V1 || pad.getWall() == Wall.V2){
				vPad = VectorAnalysis.getVector(pad.mHeight - pad.mPostion.y, angle);
			}
			
			//determine ball vector
			vBall.x = mPosition.x - mLastPosition.x;
			vBall.y = mPosition.y - mLastPosition.y;
			
			var n:Point = VectorAnalysis.normalize(vPad); // normalized pad vector
			var r:Point = VectorAnalysis.getReflectionVector(vBall, n); // reflection result vector
			
			// normalize the reflection vector
			n = VectorAnalysis.normalize(r);
			
			return new Point(n.x * mVelocity, n.y * mVelocity);
		}
		
		private function getHitPoint(pad:Pad):Number{
			var p:Number = 0;
			var pX:Number = pad.mPostion.x;
			var pY:Number = pad.mPostion.y;
			var bX:Number = mPosition.x;
			var bY:Number = mPosition.y;
			var pSize:Number = pad.getPadSize(pad.getWall());
			var pMid:Number = pSize/2;
			
			if(pad.getWall() == Wall.H1 || pad.getWall() == Wall.H2){
				p = bX - pX;
				
				//if p greater than pad size, the edge has been hit
				if(p > pSize) p = pSize;
				
				//no negative values please
				if(p < 0) p *= -1;
				
				if(p > pMid)p = pSize - p;
			}
			else if(pad.getWall() == Wall.V1 || pad.getWall() == Wall.V2){
				p = bY - pY;
				
				//if p greater than pad size, the edge has been hit
				if(p > pSize) p = pSize;
				
				//no negative values please
				if(p < 0) p *= -1;
				
				if(p > pMid)p = pSize - p;
			}
			return p;
		}
	}
}