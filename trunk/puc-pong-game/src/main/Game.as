package main {
	import flash.display.FrameLabel;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	
	import spark.components.BorderContainer;
	
	public class Game{
		
		private var mBall:Ball;
		private var mArea:GameArea;
		private var mStage:BorderContainer;
		private var mPads:Vector.<Pad>;
		
		public function Game(stage:BorderContainer, playerCount:int){
			mStage = stage;
			createNewGame(playerCount);
		}
		
		/* creates a new game with the ball, pads and the game area*/
		private function createNewGame(playerCount:int):void{
			
			//create game area
			mArea = new GameArea(mStage.height, mStage.width);
			mStage.addElement(mArea);
			
			//create pong ball
			mBall = new Ball(mStage.width/2, mStage.height/2);
			mStage.addElement(mBall);
				
			//create pads
			mPads = new Vector.<Pad>();
			var i:int;
			for(i=0; i < playerCount; i++){
				createPad(i+1);
			}
			
			mStage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			mStage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function createPad(playerId:int):void{
			var x:int;
			var y:int;
			
			var width:int = 120;
			var height:int = 20;
			
			var left:int;
			var right:int;
			
			var wall:Wall;
			
			switch (playerId){
				case 1:
					x = (mStage.width / 2) - (width / 2);
					y = (mStage.y + 35);
					
					wall = mArea.getWall("H1");
					left = wall.mStartX;
					right = wall.mStopX;
					break;
				case 2:					
					x = (mStage.width / 2) - (width / 2);
					y = mStage.height - 60;
					wall = mArea.getWall("H2");
					left = wall.mStopX;
					right = wall.mStartX;
					break;
				case 3:
					x = mArea.mX + mArea.mSize - 32;
					y = (mStage.height / 2) - (width / 2);
					width = 20;
					height = 120;
					wall = mArea.getWall("V1");
					left = wall.mStartY;
					right = wall.mStopY;
					break;
				case 4:
					x = mArea.mX + 12;
					y = (mStage.height / 2) - (width / 2);
					width = 20;
					height = 120;
					wall = mArea.getWall("V2");
					left = wall.mStopY;
					right = wall.mStartY;
					break;
				default:
					break;
			}
			
			var pad:Pad = new Pad(playerId, x, y, width, height, wall.name, left, right);
			mStage.addElement(pad);
			mPads.push(pad);
		}
		
		private function onMouseMove(e:MouseEvent):void{
			for each (var pad:Pad in mPads){
				pad.movePad(e.localX, e.localY);
			}
		}
		
		public function onEnterFrame(e:Event):void{
			checkBoundaries();
			mBall.moveBall();
		}
		
		public function checkBoundaries():void{

			for each (var pad:Pad in mPads){
				if(pad.hits(mBall)){
					if(pad.getWall() == Wall.H1){
						mBall.mVelocityY = - mBall.mVelocityY;
						mBall.changeDirection(new Point(mBall.mVelocityX, mBall.mVelocityY));
					}
					else if(pad.getWall() == Wall.H2){
						mBall.mVelocityY = - mBall.mVelocityY;
						mBall.changeDirection(new Point(mBall.mVelocityX, mBall.mVelocityY));
					}
				}
			}

			for each(var wall:Wall in mArea.mWalls){
				if(wall.hits(mBall)){
					if(wall.name == Wall.H1 && !wall.mLastHit){
						mBall.mVelocityX = mBall.mVelocityX;
						mBall.mVelocityY = -mBall.mVelocityY;	
						mArea.markLastHit(wall);
					}
					else if(wall.name == Wall.H2 && !wall.mLastHit){
						mBall.mVelocityX = mBall.mVelocityX;
						mBall.mVelocityY = -mBall.mVelocityY;	
						mArea.markLastHit(wall);
					}
					else if(wall.name == Wall.V1 && !wall.mLastHit){
						mBall.mVelocityX = -mBall.mVelocityX;
						mBall.mVelocityY = mBall.mVelocityY;
						mArea.markLastHit(wall);
					}
					else if(wall.name == Wall.V2 && !wall.mLastHit){
						mBall.mVelocityX = -mBall.mVelocityX;
						mBall.mVelocityY = mBall.mVelocityY;
						mArea.markLastHit(wall);
					}
					else if(wall.name == Wall.D1 && !wall.mLastHit){
						mBall.mVelocityX = -mBall.mVelocityX;
						mBall.mVelocityY = mBall.mVelocityY;
						mArea.markLastHit(wall);
					}
					else if(wall.name == Wall.D2 && !wall.mLastHit){
						mBall.mVelocityX = mBall.mVelocityX;
						mBall.mVelocityY = -mBall.mVelocityY;
						mArea.markLastHit(wall);
					}
					else if(wall.name == Wall.D3 && !wall.mLastHit){
						mBall.mVelocityX = -mBall.mVelocityX;
						mBall.mVelocityY = mBall.mVelocityY;
						mArea.markLastHit(wall);
					}
					else if(wall.name == Wall.D4 && !wall.mLastHit){
						mBall.mVelocityX = mBall.mVelocityX;
						mBall.mVelocityY = -mBall.mVelocityY;
						mArea.markLastHit(wall);
					}
					
					mBall.changeDirection(new Point(mBall.mVelocityX, mBall.mVelocityY));
				}
			}
		}
	}
}