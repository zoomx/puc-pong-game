package main {
	import flash.display.Shape;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	public class Ball extends UIComponent{
		
		private var mCircle:Shape;
		
		//current poisiton of the ball
		public var mPosition:Point;
		
		//last position of the ball
		public var mLastPosition:Point;
		
		//direction of the ball
		public var mDirection:Point;
		
		//radius of the ball
		public var mRadius:int = 12;
		
		//velocity of the ball
		public var mVelocity:int = 3;
	
		public function Ball(startX:int, startY:int, direction:Point) {
			super();
			this.mPosition = new Point(startX, startY);
			this.mDirection = new Point(direction.x + mVelocity, direction.y + mVelocity);
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
			mLastPosition = mPosition.clone();
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
		
		public function setNewDirection(wall:Wall):Point{
			if(wall.name == Wall.H1){
				return new Point(mDirection.x, -mDirection.y);;
			}
			else if(wall.name == Wall.H2){
				return new Point(mDirection.x, -mDirection.y);;
			}
			else if(wall.name == Wall.V1){
				return new Point(-mDirection.x, mDirection.y);;
			}
			else if(wall.name == Wall.H2){
				return new Point(-mDirection.x, mDirection.y);;
			}else{

				var direction:Point = new Point(0,0);
				var vWall:Point = new Point();
				var vBall:Point = new Point();
				
				//determine wall vector
				vWall.x = wall.mStopX - wall.mStartX;
				vWall.y = wall.mStopY - wall.mStartY;
				
				//determine ball vector
				vBall.x = mPosition.x - mLastPosition.x;
				vBall.y = mPosition.y - mLastPosition.y;
				
				//calculate scalar
				var scalar:Number = (vBall.x * vWall.x) + (vBall.y * vWall.y);
				
				//length of vector vWall
				var vWallLength:Number = Math.sqrt(Math.pow(vWall.x, 2) + Math.pow(vWall.y, 2));
				
				//length of vector vBall
				var vBallLength:Number = Math.sqrt(Math.pow(vBall.x, 2) + Math.pow(vBall.y, 2));
				
				var vBallNorm:Point = new Point(vBall.x/vBallLength, vBall.y/vBallLength);
				
				//angle
				var rad:Number = (Math.acos(scalar / (vWallLength * vBallLength)));
				var degree:Number = rad * (180 / Math.PI);
				
				direction.x = vWall.x - (vBall.x * Math.cos(rad)) - vBall.y * Math.sin(rad);
				direction.y = vWall.y - (vBall.y * Math.sin(rad)) - vBall.y * Math.cos(rad);
				
				var vDirectionLength:Number = Math.sqrt(Math.pow(direction.x, 2) + Math.pow(direction.y, 2));
				var vDirectionNorm:Point = new Point(direction.x/vDirectionLength, direction.y/vDirectionLength);
				
				var reflex:Point = new Point(vDirectionNorm.x - vBallNorm.x, vDirectionNorm.y - vBallNorm.y);
				
				return new Point(reflex.x * mVelocity, reflex.y * mVelocity);
			}
		}
		
		public function setDirectionByPadHit(pad:Pad):Point{
			if(pad.getWall() == Wall.H1){
				return new Point(mDirection.x, -mDirection.y);;
			}
			else if(pad.getWall() == Wall.H2){
				return new Point(mDirection.x, -mDirection.y);;
			}
			else if(pad.getWall() == Wall.V1){
				return new Point(-mDirection.x, mDirection.y);;
			}
			else if(pad.getWall() == Wall.H2){
				return new Point(-mDirection.x, mDirection.y);;
			}else{
				return mDirection;
			}
		}
	}
}