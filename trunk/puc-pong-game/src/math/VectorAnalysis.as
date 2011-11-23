package math{
	import flash.geom.Point;
	
	public class VectorAnalysis{
		
		public function VectorAnalysis(){
		
		}
		
		/** return a normalized vector **/
		public static function normalize(vector:Point):Point{
			var length:Number = VectorAnalysis.getLength(vector);
			vector.x /= length;
			vector.y /= length;
			return vector;
		}
		
		/** return the length of a vector */
		public static function getLength(vector:Point):Number{
			return Math.sqrt(Math.pow(vector.x, 2) + Math.pow(vector.y, 2));
		}
		
		/** reflect vector 'v' against normalized vector 'n' **/
		public static function getReflectionVector(v:Point, n:Point):Point{
			var d:Number = getScalar(v,n);
			return new Point(v.x - 2 * d * n.x, v.y - 2 * d * n.y )
		}
	
		/** returns the scalar of two vector **/
		public static function getScalar(v1:Point, v2:Point):Number{
			return (v1.x * v2.x) + (v1.y * v2.y);
		} 
		
		/** find vector based on distance and angle **/
		public static function getVector(distance:Number, angle:Number):Point{
			return new Point(
				 distance * Math.sin(angle * (Math.PI / 180)),
				-distance * Math.cos(angle * (Math.PI / 180)))
		}
	}
}