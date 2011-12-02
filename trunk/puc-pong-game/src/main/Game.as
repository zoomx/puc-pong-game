package main {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import mx.core.FlexGlobals;
	
	import spark.components.BorderContainer;
	
	public class Game{
		
		private var mBall:Ball;
		private var mArea:GameArea;
		private var mStage:BorderContainer;
		private var mPads:Vector.<Pad>;
		private var mPlayerCount:int;
		private var mArduinoSocket:Socket;
		private var mPoints:int = 10;
		
		public var PS1:int;
		public var PS2:int;
		public var PS3:int;
		public var PS4:int;
		
		private var mScore:String = "Player 1: " + PS1 + "\n" + 
									"Player 2: " + PS2 + "\n" + 
									"Player 3: " + PS3 + "\n" + 
									"Player 4: " + PS4;
		
		// true:  game controlled by mouse
		// false: game controlled by arduino 
		private var mMouseControl:Boolean = false;
		
		public function Game(stage:BorderContainer, playerCount:int){
			
			mStage = stage;
			mPlayerCount = playerCount;
			
			if(!mMouseControl) setUpArduino();
			
			createNewGame(mPlayerCount);
		}
		
		/* creates a new game with the ball, pads and the game area*/
		private function createNewGame(playerCount:int):void{
			
			//create game area
			mArea = new GameArea(mStage.height, mStage.width);
			mStage.addElement(mArea);
			
			//create pong ball

			mBall = new Ball(mStage.width/2, mStage.height/2, new Point(1,20));
			mStage.addElement(mBall);
				
			//create pads
			mPads = new Vector.<Pad>();
			var i:int;
			for(i=0; i < playerCount; i++){
				createPad(i+1);
			}
			
			PS1 = mPoints;
			PS2 = mPoints;
			PS3 = mPoints;
			PS4 = mPoints;
			
			updateScore();
			
			if(mMouseControl)mStage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			mStage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onMouseMove(e:MouseEvent):void{
			for each (var pad:Pad in mPads){
				pad.movePadByMouse(e.localX, e.localY);
			}
		}
		
		public function onEnterFrame(e:Event):void{
			hitTests();
			mBall.mVelocity = 8 + (mBall.mouseX / 100);
			mBall.moveBall();
		}
			
		/** function tests if the ball is hit by a pad or a wall **/
		public function hitTests():void{
			
			var padHit:Boolean = false;
			
			//test if ball is hit by the ball
			for each (var pad:Pad in mPads){
				if(pad.hits(mBall)){
					if(!pad.mLastHit)mBall.mDirection = mBall.setDirectionByPadHit(pad);
					markPadLastHit(pad);
					mArea.markWallLastHit(null);
					padHit = true;
					break;
				}
			}


			//if ball is not hit by a pad test for the wall
			if(!padHit){
				wallHitTest();
			}
			
		}
		
		public function wallHitTest():void{
			for each(var wall:Wall in mArea.mWalls){
				if(wall.hits(mBall)){
					if(!wall.mLastHit)mBall.mDirection = mBall.setNewDirection(wall);
					//trace(wall.name + ": " + mBall.mDirection.x + " | " + mBall.mDirection.y );
					if(wall.name == "H1" && !wall.mIsSolid) { 
						PS1 --;
						trace("PS1: " + PS1);
						updateScore();
						mBall.mPosition.x = mStage.width/2; mBall.mPosition.y = mStage.height/2; mBall.moveBall();
						
						if(PS1 <= 0) removePlayer(wall);
					}else{
						mBall.setNewDirection(wall);
					}
					
					if(wall.name == "H2" && !wall.mIsSolid) { 
						PS3 --;
						trace("PS3: " + PS3);
						updateScore();
						mBall.mPosition.x = mStage.width/2; mBall.mPosition.y = mStage.height/2; mBall.moveBall();
						if(PS3 <= 0) removePlayer(wall);
					}else{
						mBall.setNewDirection(wall);
					}
					
					if(wall.name == "V1" && !wall.mIsSolid) { 
						PS2 --;
						trace("PS2: " + PS2);
						updateScore();
						mBall.mPosition.x = mStage.width/2; mBall.mPosition.y = mStage.height/2; mBall.moveBall();
						if(PS2 <= 0) removePlayer(wall);
					}else{
						mBall.setNewDirection(wall);
					}
					
					if(wall.name == "V2" && !wall.mIsSolid) { 
						PS4 --;
						
						trace("PS4: " + PS4);
						updateScore();
						mBall.mPosition.x = mStage.width/2; mBall.mPosition.y = mStage.height/2; mBall.moveBall();
						if(PS4 <= 0) removePlayer(wall);
					}else{
						mBall.setNewDirection(wall);
					}
					
					
					mArea.markWallLastHit(wall);
					markPadLastHit(null);
					
				}	
			}
		}
		
		public function updateScore():void{
			mScore = "Player 1: " + PS1 + "\n" + "Player 2: " + PS2 + "\n" + "Player 3: " + PS3 + "\n" + "Player 4: " + PS4;
			FlexGlobals.topLevelApplication.SCORE_TABLE.text = mScore;
		}
		
		private function removePlayer(wall:Wall):void{
			wall.mIsSolid = true;
			var pad:Pad;
			var tempVec:Vector.<Pad> = new Vector.<Pad>();
			for each(pad in mPads){
				if(pad.getWall() == wall.name){
					mStage.removeElement(pad);
				}else{
					tempVec.push(pad);
				}
			}
			mPads = tempVec;
		}
		
		public function markPadLastHit(pad:Pad):void{
			var p:Pad;
			if(pad != null){
				for each(p in mPads){
					if(p.getWall() == pad.getWall()){
						p.mLastHit = true;
					}else{
						p.mLastHit = false;
					}
				}
			}else{
				for each(p in mPads){
					p.mLastHit = false;
				}
			}
		}
		
		public function setUpArduino():void{
			mArduinoSocket = new Socket();
			mArduinoSocket.connect("127.0.0.1", 5331);
			mArduinoSocket.addEventListener(ProgressEvent.SOCKET_DATA, onReceiveData);
		}
		
		public function onReceiveData(e:ProgressEvent):void{
			var bytes:ByteArray = new ByteArray();
			mArduinoSocket.readBytes(bytes,0,0);
			var i:int;
			for(i=0; i<bytes.length; i++){
				processData(bytes[i], bytes[i+1]);
				i++;
			}
		}

		private function processData(pin:int, data:int):void{
			
			var pad:Pad;
			if(pin == 0){
				for each (pad in mPads){
					if(pad.getWall() == Wall.H1){
						//trace(pin);
						trace(data);
						if(data > 3)pad.movePad(mapSensorValue(data, pad.getWall()));
						break;
					} 
				}	
			}
			else if(pin == 1){
				for each (pad in mPads){
					if(pad.getWall() == Wall.V1){
						if(data > 3)pad.movePad(mapSensorValue(data, pad.getWall()));
						break;
					} 
				}
			}
			else if(pin == 2){
				for each (pad in mPads){
					if(pad.getWall() == Wall.H2){
						if(data > 3)pad.movePad(mapSensorValue(data, pad.getWall()));
						break;
					} 
				}
			}
			else if(pin == 3){
				for each (pad in mPads){
					if(pad.getWall() == Wall.V2){
						if(data > 3)pad.movePad(mapSensorValue(data, pad.getWall()));
						break;
					} 
				}
			}
		}
	
		/* function maps the sensor value (0 - 255) to the position of the pad and returns it*/
		public function mapSensorValue(value:int, wall:String):int{
			var max:Number = 255;
			var length:Number = mArea.mWallLength;
			var position:Number = (length / max) * value;
			
			var wallPos:int
			if(wall == Wall.H1) wallPos = mArea.getWall(wall).mStartX;
			else if(wall == Wall.H2) wallPos = mArea.getWall(wall).mStopX;
			else if(wall == Wall.V1) wallPos = mArea.getWall(wall).mStartY;
			else if(wall == Wall.V2) wallPos = mArea.getWall(wall).mStopY;

			return wallPos + position;
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
	}
	

}