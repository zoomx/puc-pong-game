package main {
	import mx.core.FlexGlobals;
	
	import spark.components.BorderContainer;
	
	public class Game{
		
		private var mBall:Ball;
		private var mArea:GameArea;
		private var mStage:BorderContainer;
		
		public function Game(stage:BorderContainer){
			mStage = stage;
			createNewGame();
		}
		
		/* creates a new game with the ball, pads and the game area*/
		private function createNewGame():void{
			mBall = new Ball();
			mArea = new GameArea(mStage.height, mStage.width);
			mStage.addElement(mBall);
			mStage.addElement(mArea);
		}
	}
}