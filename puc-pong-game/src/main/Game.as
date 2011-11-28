package main {
	import flash.display.FrameLabel;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.Security;
	import flash.ui.Keyboard;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.states.RemoveChild;
	
	import net.eriksjodin.arduino.Arduino;
	import net.eriksjodin.arduino.events.ArduinoEvent;
	
	import spark.components.BorderContainer;
	
	public class Game{
		
		private var mBall:Ball;
		private var mArea:GameArea;
		private var mStage:BorderContainer;
		private var mPads:Vector.<Pad>;
		private var mArduino:Arduino;
		private var mPlayerCount:int;
		public var PS1:int = 10;
		public var PS2:int = 10;
		public var PS3:int = 10;
		public var PS4:int = 10;
		
		// true: game controlled by mouse
		// false: game controlled by arduino 
		private var mMouseControl:Boolean = true;
		
		public function Game(stage:BorderContainer, playerCount:int){
			
			mStage = stage;
			mPlayerCount = playerCount;
			
			if(!mMouseControl){
				mArduino = new Arduino();
				mArduino.addEventListener(Event.CONNECT, onArduinoConnect);
			}else{
				createNewGame(mPlayerCount);
			}
		}
		
		/* creates a new game with the ball, pads and the game area*/
		private function createNewGame(playerCount:int):void{
			
			//create game area
			mArea = new GameArea(mStage.height, mStage.width);
			mStage.addElement(mArea);
			
			//create pong ball
			mBall = new Ball(mStage.width/2, mStage.height/2, new Point(1,10));
			mStage.addElement(mBall);
				
			//create pads
			mPads = new Vector.<Pad>();
			var i:int;
			for(i=0; i < playerCount; i++){
				createPad(i+1);
			}
			
			if(mMouseControl)mStage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			mStage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
	
		
		private function onMouseMove(e:MouseEvent):void{
			for each (var pad:Pad in mPads){
				pad.movePadByMouse(e.localX, e.localY);
			}
		}
		
		public function onEnterFrame(e:Event):void{
			checkBoundaries();
			mBall.moveBall();
		}
		
		public function checkBoundaries():void{

			for each (var pad:Pad in mPads){
				if(pad.hits(mBall)){
					if(!pad.mLastHit)mBall.mDirection = mBall.setDirectionByPadHit(pad);
					markPadLastHit(pad);
					mArea.markWallLastHit(null);
				}
			}

			for each(var wall:Wall in mArea.mWalls){
				if(wall.hits(mBall)){
					if(!wall.mLastHit)mBall.mDirection = mBall.setNewDirection(wall);
					//trace(wall.name + ": " + mBall.mDirection.x + " | " + mBall.mDirection.y );
					if(wall.name == "H1") { 
					PS1 --;
					trace("PS1: " + PS1);

					mBall.mPosition.x = mStage.width/2; mBall.mPosition.y = mStage.height/2; mBall.moveBall();
					}
					
					if(wall.name == "H2") { 
					PS3 --;
					trace("PS3: " + PS3);

					mBall.mPosition.x = mStage.width/2; mBall.mPosition.y = mStage.height/2; mBall.moveBall();
					}
					
					if(wall.name == "V1") { 
						PS2 --;
						trace("PS2: " + PS2);
						mBall.mPosition.x = mStage.width/2; mBall.mPosition.y = mStage.height/2; mBall.moveBall();
					}

					if(wall.name == "V2") { 
						PS4 --;
						
						trace("PS4: " + PS4);
						mBall.mPosition.x = mStage.width/2; mBall.mPosition.y = mStage.height/2; mBall.moveBall();
					}
					
					
					mArea.markWallLastHit(wall);
					markPadLastHit(null);
				}
			}
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
			mArduino.setPinMode(1,Arduino.INPUT);
			mArduino.setPinMode(2,Arduino.INPUT);
			mArduino.setPinMode(3,Arduino.INPUT);
			mArduino.setPinMode(4,Arduino.INPUT);
			mArduino.addEventListener(ArduinoEvent.ANALOG_DATA, onReceiveData);
		}
		
		public function onReceiveData(e:ArduinoEvent):void{
			if(e.pin == 1 || e.pin == 2 || e.pin == 3 || e.pin == 4){
				trace("Analog pin " + e.pin + " on port: " + e.port +" = " + e.value);
				
				var pad:Pad;
				if(e.pin == 1){
					for each (pad in mPads){
						if(pad.getWall() == Wall.H1) pad.movePad(mapSensorValue(e.value, e.pin, pad.getWall()));
					}
				}
				else if(e.pin == 2){
					for each (pad in mPads){
						if(pad.getWall() == Wall.V1) pad.movePad(mapSensorValue(e.value, e.pin, pad.getWall()));
					}
				}
				else if(e.pin == 3){
					for each (pad in mPads){
						if(pad.getWall() == Wall.H2) pad.movePad(mapSensorValue(e.value, e.pin, pad.getWall()));
					}
				}
				else if(e.pin == 4){
					for each (pad in mPads){
						if(pad.getWall() == Wall.V2) pad.movePad(mapSensorValue(e.value, e.pin, pad.getWall()));
					}
				}
			}
		}
		
		/* function maps the sensor value (0 - 1023) to the position of the pad and returns it*/
		public function mapSensorValue(value:int, pin:int, wall:String):int{
			var max:Number = 1024;
			var length:Number = mArea.mWallLength;
			var position:Number = (length / 1024) * value;
			
			var wallPos:int
			if(wall == Wall.H1) wallPos = mArea.getWall(wall).mStartX;
			else if(wall == Wall.H2) wallPos = mArea.getWall(wall).mStopX;
			else if(wall == Wall.V1) wallPos = mArea.getWall(wall).mStartY;
			else if(wall == Wall.V2) wallPos = mArea.getWall(wall).mStopY;

			return wallPos + position;
		}
		
		private function onArduinoConnect(e:Event):void{
			setUpArduino();
			createNewGame(mPlayerCount);
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