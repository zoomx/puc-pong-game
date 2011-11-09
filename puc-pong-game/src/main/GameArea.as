package main{
	
	import flash.display.Shape;
	
	import mx.core.UIComponent;
	
	import spark.primitives.Path;
	
	public class GameArea extends UIComponent{
		
		private var mHeight:int;
		private var mWidth:int;
		
		/* the area of the octagon, walls are extra drawed */
		private var mOctagon:Path;
		
		public function GameArea(height:int, width:int){
			super();
			this.mHeight = height - 50;
			this.mWidth = width;
			createGameArea();
		}
		
		private function createGameArea():void{
			
			mOctagon = new Path();
			
			var lineWidth:int = mHeight / 2.333;
			
			/* create H1 line */
			var startX:int = (mWidth / 2) - (lineWidth / 2);
			var startY:int = 25;
			var stopX:int = startX + lineWidth;
			var stopY:int = 25;
			var wall:Wall = new Wall(Wall.H1, startX, startY, stopX, stopY);
			addChild(wall);
			
			/* create D1 line */
			startX = stopX;
			startY = stopY;
			stopX = startX + (lineWidth * (2/3));
			stopY = startY + (lineWidth * (2/3));
			wall = new Wall(Wall.D1, startX, startY, stopX, stopY);
			addChild(wall);
			
			/* create V1 line */
			startX = stopX;
			startY = stopY;
			stopX = startX;
			stopY = startY + lineWidth;
			wall = new Wall(Wall.V1, startX, startY, stopX, stopY);
			addChild(wall);
			
			/* create D2 line */
			startX = stopX;
			startY = stopY;
			stopX = startX - (lineWidth * (2/3));
			stopY = startY + (lineWidth * (2/3));
			wall = new Wall(Wall.D2, startX, startY, stopX, stopY);
			addChild(wall);
			
			/* create H2 line */
			startX = stopX;
			startY = stopY;
			stopX = startX - lineWidth;
			stopY = startY;
			wall = new Wall(Wall.H2, startX, startY, stopX, stopY);
			addChild(wall);
			
			/* create D3 line */
			startX = stopX;
			startY = stopY;
			stopX = startX - (lineWidth * (2/3));
			stopY = startY - (lineWidth * (2/3));
			wall = new Wall(Wall.D3, startX, startY, stopX, stopY);
			addChild(wall);
			
			/* create V2 line */
			startX = stopX;
			startY = stopY;
			stopX = startX;
			stopY = startY - lineWidth;
			wall = new Wall(Wall.V2, startX, startY, stopX, stopY);
			addChild(wall);
			
			/* create D4 line */
			startX = stopX;
			startY = stopY;
			stopX = startX + (lineWidth * (2/3));
			stopY = startY - (lineWidth * (2/3));
			wall = new Wall(Wall.D4, startX, startY, stopX, stopY);
			addChild(wall);
		}	
	}
}
	
