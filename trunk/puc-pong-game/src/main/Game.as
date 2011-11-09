package main {
	import mx.core.FlexGlobals;
	
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
			mBall = new Ball();
			mStage.addElement(mBall);
				
			//create pads
			mPads = new Vector.<Pad>();
			var i:int;
			for(i=0; i < playerCount; i++){
				createPad(i+1);
			}
		}
		
		private function createPad(playerId:int):void{
			var x:int;
			var y:int;
			
			var width:int = 120;
			var height:int = 20;
			
			var wall:String;
			
			switch (playerId){
				case 1:
					x = (mStage.width / 2) - (width / 2);
					y = (mStage.y + 35);
					wall = Wall.H1;
					break;
				case 2:					
					x = (mStage.width / 2) - (width / 2);
					y = mStage.height - 60;
					wall = Wall.H2;
					break;
				case 3:
					x = mArea.mX + mArea.mSize - 32;
					y = (mStage.height / 2) - (width / 2);
					width = 20;
					height = 120;
					wall = Wall.V1;
					break;
				case 4:
					x = mArea.mX + 12;
					y = (mStage.height / 2) - (width / 2);
					width = 20;
					height = 120;
					wall = Wall.V2;
					break;
				default:
					break;
			}
			
			var pad:Pad = new Pad(playerId, x, y, width, height, wall);
			mStage.addElement(pad);
			mPads.push(pad);
		}
	}
}