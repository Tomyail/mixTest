package com.nodename.Delaunay
{
	import flash.geom.Point;
	
	public final class Vertex implements ICoord
	{
		//public static const VERTEX_AT_INFINITY:Vertex = new Vertex(NaN, NaN);
		
		//private static var _pool:Vector.<Vertex> = new Vector.<Vertex>();
		//private static function create(x:Number, y:Number):Vertex
		//{
			//if (isNaN(x) || isNaN(y))
			//{
				//return VERTEX_AT_INFINITY;
			//}
			//if (_pool.length > 0)
			//{
				//return _pool.pop().init(x, y);
			//}
			//else
			//{
				//return new Vertex(PrivateConstructorEnforcer, x, y);
			//}
		//}


		private var _nvertices:int = 0;
		
		private var _coord:Point;
		public function get coord():Point
		{
			return _coord;
		}
		public var vertexIndex:int;
		//public function get vertexIndex():int
		//{
			//return _vertexIndex;
		//}
		
		public function Vertex(x:Number, y:Number)
		{
			//if (lock != PrivateConstructorEnforcer)
			//{
				//throw new Error("Vertex constructor is private");
			//}
			
			_coord = new Point(x, y);
			//init(x, y);
		}
		
		//private function init(x:Number, y:Number):Vertex
		//{
			//_coord = new Point(x, y);
			//return this;
		//}
		
		public function dispose():void
		{
			_coord = null;
			//_pool.push(this);
		}
		
		public function setIndex():void
		{
			vertexIndex = _nvertices++;
		}
		
		public function toString():String
		{
			return "Vertex (" + vertexIndex + ")";
		}

		/**
		 * This is the only way to make a Vertex
		 *
		 * @param halfedge0
		 * @param halfedge1
		 * @return
		 *
		 */
		public function intersect(halfedge0:Halfedge, halfedge1:Halfedge):Vertex
		{
			var edge0:Edge, edge1:Edge, edge:Edge;
			var halfedge:Halfedge;
			var determinant:Number, intersectionX:Number, intersectionY:Number;
			var rightOfSite:Boolean;
		
			edge0 = halfedge0.edge;
			edge1 = halfedge1.edge;
			if (edge0 == null || edge1 == null)
			{
				return null;
			}
			if (edge0.rightSite == edge1.rightSite)
			{
				return null;
			}
		
			determinant = edge0.a * edge1.b - edge0.b * edge1.a;
			if (-1.0e-10 < determinant && determinant < 1.0e-10)
			{
				// the edges are parallel
				return null;
			}
		
			intersectionX = (edge0.c * edge1.b - edge1.c * edge0.b)/determinant;
			intersectionY = (edge1.c * edge0.a - edge0.c * edge1.a)/determinant;
		
			if (compareByYThenX(edge0.rightSite, edge1.rightSite) < 0)
			{
				halfedge = halfedge0; edge = edge0;
			}
			else
			{
				halfedge = halfedge1; edge = edge1;
			}
			rightOfSite = intersectionX >= edge.rightSite.coord.x;
			if ((rightOfSite && halfedge.leftRight == LR.LEFT)
			||  (!rightOfSite && halfedge.leftRight == LR.RIGHT))
			{
				return null;
			}
		
			return new Vertex(intersectionX, intersectionY);
		}
		
		//public function get x():Number
		//{
			//return _coord.x;
		//}
		//public function get y():Number
		//{
			//return _coord.y;
		//}

		public function compareByYThenX(s1:Site, s2:Site):Number
		{
			var p1:Point = s1.coord;
			var p2:Point = s2.coord;
			if (p1.y < p2.y) return -1;
			if (p1.y > p2.y) return 1;
			if (p1.x < p2.x) return -1;
			if (p1.x > p2.x) return 1;
			return 0;
		}
		
	}
}

//class PrivateConstructorEnforcer {}