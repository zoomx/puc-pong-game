package main {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.Float;
	
	import mx.core.FlexGlobals;
	
	import spark.components.BorderContainer;
	
	public class Game{
		
		private var mBall:Ball;
		private var mArea:GameArea;
		private var mStage:BorderContainer;
		private var mPads:Vector.<Pad>;
		private var mPlayerCount:int;
		private var mPoints:int = 10;
		private var mPadSize:int = 120;
		
		public var PS1:int;
		public var PS2:int;
		public var PS3:int;
		public var PS4:int;
			
		//incoming values from arduino, and filtered values
		public var values:Number;
		public var valuesRaw:Number;
		
		private static var MAX_PAD_VALUE:int = 70;

		
		//variabelen Balsnelheid
		private var mTimer:Timer;
		private var mSound:Sound;
		private var mSoundChannel:SoundChannel;
		private var mLink:String = "http://nm2n.net/snd/sect.mp3";
		
		private var mScore:String = "Player 1: " + PS1 + "\n" + 
									"Player 2: " + PS2 + "\n" + 
									"Player 3: " + PS3 + "\n" + 
									"Player 4: " + PS4;
		
		// true:  game controlled by mouse
		// false: game controlled by arduino 
		public static var MOUSE_CONTROL:Boolean = false;
		public static var CURVES_BY_MOUSE:Boolean = false;
		public static var PLAY_WITH_SOUND:Boolean = true;
		
		public function Game(stage:BorderContainer, playerCount:int){
			
			mStage = stage;
			mPlayerCount = playerCount;
			
			if(PLAY_WITH_SOUND){
				loadSound();
			}else{
				createNewGame(mPlayerCount);
			}
		}
		
		private function loadSound():void{
			//loadsound
			mSound = new Sound(new URLRequest(mLink));
			mSound.addEventListener(Event.COMPLETE, loadComplete);			
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
			
			if(MOUSE_CONTROL)mStage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			mStage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			FlexGlobals.topLevelApplication.mGameStarted = true;
		}
		
		private function loadComplete(e:Event):void{
			//create new game after sound has been loaded
			createNewGame(mPlayerCount);
			
			mSound.removeEventListener(Event.COMPLETE, loadComplete);
			
			mSound = e.target as Sound;
			mSoundChannel = mSound.play();
			
			//starts timer for beat detection
			mTimer = new Timer(26);
			mTimer.addEventListener(TimerEvent.TIMER, onEnterFrame);
			mTimer.start();
		}
		
		private function onMouseMove(e:MouseEvent):void{
			for each (var pad:Pad in mPads){
				pad.movePadByMouse(e.localX, e.localY);
			}
		}
		
		private function onEnterFrame(e:Event):void{
			hitTests();
			computeBallSpeed();
		}
		
		private var count:int = 0;
		private var sumVelo:Number = 0;
		private var velo:Number = 1;
		private function computeBallSpeed():void{
			//var spectrumBars_mc:Sprite = new Sprite();
			var spectrum:ByteArray = new ByteArray(); 
			var multiplier:uint = 4;
			var readSpec:int;
			
			SoundMixer.computeSpectrum(spectrum, true, 0);
			//spectrumBars_mc.graphics.clear();
			
			readSpec = spectrum.readFloat() * multiplier;
			
			if(count <= 100){
				sumVelo += readSpec;
				count++;
			}
			else{
				//calculate new velocity and smooth it
				velo = (0.9 * velo) + (0.1 * (sumVelo/100));
				//trace(velo);
				
				//reset counter and sumVelo
				count = 0;
				sumVelo = 0;
			}
			
			//spectrumBars_mc.graphics.beginFill(0x000000);
			//spectrumBars_mc.graphics.drawCircle(0, 0, -valor );
			
			if((velo * 2) > Ball.MAX_VELOCITY){
				mBall.mVelocity = Ball.MAX_VELOCITY;
			}else{
				mBall.mVelocity = velo * 2;	
			}
			mBall.moveBall();			
		}
			
		/** function tests if the ball is hit by a pad or a wall **/
		private function hitTests():void{
			
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
		
		private function wallHitTest():void{
			for each(var wall:Wall in mArea.mWalls){
				if(wall.hits(mBall)){
					if(!wall.mLastHit)mBall.mDirection = mBall.setNewDirection(wall);
					//trace(wall.name + ": " + mBall.mDirection.x + " | " + mBall.mDirection.y );
					if(wall.name == "H1" && !wall.mIsSolid) { 
						PS1 --;
						updateScore();
						mBall.mPosition.x = mStage.width/2; mBall.mPosition.y = mStage.height/2; mBall.moveBall();
						
						if(PS1 <= 0) removePlayer(wall);
					}else{
						mBall.setNewDirection(wall);
					}
					
					if(wall.name == "H2" && !wall.mIsSolid) { 
						PS3 --;
						updateScore();
						mBall.mPosition.x = mStage.width/2; mBall.mPosition.y = mStage.height/2; mBall.moveBall();
						if(PS3 <= 0) removePlayer(wall);
					}else{
						mBall.setNewDirection(wall);
					}
					
					if(wall.name == "V1" && !wall.mIsSolid) { 
						PS2 --;
						updateScore();
						mBall.mPosition.x = mStage.width/2; mBall.mPosition.y = mStage.height/2; mBall.moveBall();
						if(PS2 <= 0) removePlayer(wall);
					}else{
						mBall.setNewDirection(wall);
					}
					
					if(wall.name == "V2" && !wall.mIsSolid) { 
						PS4 --;
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
		
		private function updateScore():void{
			mScore = "Player 1: " + PS1 + "\n" + "Player 2: " + PS2 + "\n" + "Player 3: " + PS3 + "\n" + "Player 4: " + PS4;
			FlexGlobals.topLevelApplication.SCORE_TABLE.text = mScore;
		}
		
		// remove a player (pad) from a distinct wall
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
		
		private function markPadLastHit(pad:Pad):void{
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
		
		//processes the data according to the pin (0-3: move pad | 4-7: bend walls)
		public function processData(pin:int, data:int):void{
			
			var pad:Pad;
			var wall:Wall;
			
			if(pin == 0){
				trace("pin: " + pin + " data: " + data);
				for each (pad in mPads){
					if(pad.getWall() == Wall.H1){
						pad.movePad(mapSensorValue(data, pad.getWall()));
						break;
					} 
				}	
			}
			else if(pin == 1){
				for each (pad in mPads){
					if(pad.getWall() == Wall.V1){
						pad.movePad(mapSensorValue(data, pad.getWall()));
						break;
					} 
				}
			}
			else if(pin == 2){
				for each (pad in mPads){
					if(pad.getWall() == Wall.H2){
						pad.movePad(mapSensorValue(data, pad.getWall()));
						break;
					} 
				}
			}
			else if(pin == 3){
				for each (pad in mPads){
					if(pad.getWall() == Wall.V2){
						pad.movePad(mapSensorValue(data, pad.getWall()));
						break;
					} 
				}
			}
			else if(pin == 4){
				for each (wall in mArea.mWalls){
					if(wall.name == Wall.D1){
						wall.bendWall(data);
					}
				}
			}
			else if(pin == 5){
				for each (wall in mArea.mWalls){
					if(wall.name == Wall.D2){
					wall.bendWall(data);
				
					}
				}
			}
			else if(pin == 6){
				for each (wall in mArea.mWalls){
					if(wall.name == Wall.D3){
						wall.bendWall(data);
					}
				}
			}
			else if(pin == 7){
				for each (wall in mArea.mWalls){
					if(wall.name == Wall.D4){
						wall.bendWall(data);
					}
				}
			}
		}
	
		/* function maps the sensor value (0 - 255) to the position of the pad and returns it*/
		public function mapSensorValue(value:int, wall:String):int{
			var max:Number = MAX_PAD_VALUE;
			var length:Number = mArea.mWallLength;
			
			
			var position:Number = Math.max(0, ((length / max) * value) - mPadSize);
			if(position < mPadSize) position = ((length / max) * value);
			
			var wallPos:int
			var w:Wall = mArea.getWall(wall);
			
			if(w.name == Wall.H1) wallPos = w.mStartX;
			else if(w.name == Wall.H2) wallPos = w.mStopX;
			else if(w.name == Wall.V1) wallPos = w.mStartY;
			else if(w.name == Wall.V2) wallPos = w.mStopY;

			return wallPos + position;
		}
		
		//creates the pad
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
		
		public function isMouseControl():Boolean{
			return MOUSE_CONTROL;
		}
		
		public function release():void{
			mTimer.stop();
			mTimer.removeEventListener(TimerEvent.TIMER, onEnterFrame);
			mTimer = null;
			mSoundChannel.stop();
			mSound = null;
		}
	}
}