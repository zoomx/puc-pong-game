package main{
	
	import flash.display.Shape;
	
	import mx.core.UIComponent;
	
	import spark.primitives.Path;
	
	public class GameArea extends UIComponent{
		
		private var mScreenHeight:int;
		private var mScreenWidth:int;
		
		public var mX:int;
		public var mY:int;
		
		public var mWallLength:Number;
		public var mSize:int;
		
		public var mWalls:Vector.<Wall>;
		
		/* the area of the octagon, walls are extra drawed */
		private var mOctagon:Shape;
		
		public function GameArea(height:int, width:int){
			super();
			
			//substract 50px in order that the area isnt directly at the screen borders
			this.mScreenHeight = height - 50;
			this.mScreenWidth = width;
			this.mSize = mScreenHeight;
			createGameArea();
		}
		
		private function createGameArea():void{
			mWalls = new Vector.<Wall>();
					
			/* commands for drawing the octagon */
			var commands:Vector.<int> = new Vector.<int>();
			
			/* coordinates for drawing the octagon */
			var coords:Vector.<Number> = new Vector.<Number>();
			
			//groter getal = kleiner
			//kleiner gatel = groter
			mWallLength = mScreenHeight / 2.6;
			
			/* represents the first starting points to get a clean ending*/
			var xPos:int;
			var yPos:int;
			
			/* create H1 line */
			//Hier kunnen we verschuiven
			//hoe lager, hoe meer naar links
			var startX:int = (mScreenWidth / 2) - (mWallLength / 1.35);
			var startY:int = 75
			var stopX:int = startX + mWallLength;
			var stopY:int = 75;
			var wall:Wall = new Wall(startX, startY, stopX, stopY);
			
			wall.name = Wall.H1;
			wall.mIsSolid = false;
			wall.mWallRadius = mWallLength/2;
			addChild(wall);
			mWalls.push(wall);
			
			commands.push(1,2,2,2);			//add data do path commands
			coords.push(startX, startY);	//add data to path coordinates
			coords.push(stopX, stopY);		//add data to path coordinates	
			xPos = startX;	
			yPos = startY;
			mY = startY;

			/* create D1 line */
			startX = stopX;
			startY = stopY;
			stopX = startX + (mWallLength * (2/3));
			stopY = startY + (mWallLength * (2/3));
			wall = new Wall(startX, startY, stopX, stopY);
			wall.name = Wall.D1;
			wall.mWallRadius = mWallLength/2;
			addChild(wall);
			mWalls.push(wall);
			commands.push(2,2);
			coords.push(stopX, stopY);

			/* create V1 line */
			startX = stopX;
			startY = stopY;
			stopX = startX;
			stopY = startY + mWallLength;
			wall = new Wall(startX, startY, stopX, stopY);
			wall.name = Wall.V1;
			wall.mIsSolid = false;
			wall.mWallRadius = mWallLength/2;
			addChild(wall);
			mWalls.push(wall);
			commands.push(2,2);
			coords.push(stopX, stopY);
		
			/* create D2 line */
			startX = stopX;
			startY = stopY;
			stopX = startX - (mWallLength * (2/3));
			stopY = startY + (mWallLength * (2/3));
			wall = new Wall(startX, startY, stopX, stopY);
			wall.name = Wall.D2;
			wall.mWallRadius = mWallLength/2;
			addChild(wall);
			mWalls.push(wall);
			commands.push(2,2);
			coords.push(stopX, stopY);
			
			/* create H2 line */
			startX = stopX;
			startY = stopY;
			stopX = startX - mWallLength;
			stopY = startY;
			wall = new Wall(startX, startY, stopX, stopY);
			wall.name = Wall.H2;
			wall.mIsSolid = false;
			wall.mWallRadius = mWallLength/2;
			addChild(wall);
			mWalls.push(wall);
			commands.push(2,2);
			coords.push(stopX, stopY); 
			
			/* create D3 line */
			startX = stopX;
			startY = stopY;
			stopX = startX - (mWallLength * (2/3));
			stopY = startY - (mWallLength * (2/3));
			wall = new Wall(startX, startY, stopX, stopY);
			wall.name = Wall.D3;
			wall.mWallRadius = mWallLength/2;
			addChild(wall);
			mWalls.push(wall);
			commands.push(2,2);
			coords.push(stopX, stopY); 
			
			/* create V2 line */
			startX = stopX;
			startY = stopY;
			stopX = startX;
			stopY = startY - mWallLength;
			wall = new Wall(startX, startY, stopX, stopY);
			wall.name = Wall.V2;
			wall.mWallRadius = mWallLength/2;
			wall.mIsSolid = false;
			addChild(wall);
			mWalls.push(wall);
			commands.push(2,2);
			coords.push(stopX, stopY); 
			mX = startX;
			
			/* create D4 line */
			startX = stopX;
			startY = stopY;
			stopX = startX + (mWallLength * (2/3));
			stopY = startY - (mWallLength * (2/3));
			wall = new Wall(startX, startY, xPos, yPos);
			wall.name = Wall.D4;
			wall.mWallRadius = mWallLength/2;
			addChild(wall);
			mWalls.push(wall);
			commands.push(2,2);
			coords.push(xPos, yPos); 
	
			drawOctagon(commands, coords);
		}
		
		private function drawOctagon(commands:Vector.<int>, coords:Vector.<Number>):void{
			mOctagon = new Shape();
			mOctagon.graphics.beginFill(0x464646); 
			mOctagon.graphics.drawPath(commands, coords);
			mOctagon.name = "AREA";
			addChildAt(mOctagon, 0);
		}
		
		public function getWall(name:String):Wall{
			return getChildByName(name) as Wall;
		}
		
		public function hits(ball:Ball):Boolean{
			return mOctagon.hasOwnProperty(ball);
		}
		
		public function markWallLastHit(wall:Wall):void{
			var w:Wall;
			if(wall != null){
				for each(w in mWalls){
					if(w.name == wall.name){
						w.mLastHit = true;
					}else{
						w.mLastHit = false;
					}
				}
			}else{
				for each(w in mWalls){
					w.mLastHit = false;
				}
			}
		}
	}
}
	
