package main {
	import mx.core.FlexGlobals;
	
	import spark.components.BorderContainer;
	
	public class Game{
		
		private var mBall:Ball;
		private var mStage:BorderContainer;
		
		public function Game(stage:BorderContainer){
			mStage = stage;
			createNewGame();
		}
		
		private function createNewGame():void{
			mBall = new Ball();
			mStage.addElement(mBall);
		}
	}
}