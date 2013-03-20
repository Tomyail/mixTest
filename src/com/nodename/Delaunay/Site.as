package com.nodename.Delaunay
{
	import com.nodename.geom.Polygon;
	import com.nodename.geom.Winding;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public final class Site implements ICoord
	{
		public const TOP:int = 1;
		public const BOTTOM:int = 2;
		public const LEFT:int = 4;
		public const RIGHT:int = 8;
		
		//private static var _pool:Vector.<Site> = new Vector.<Site>();
		//public static function create(p:Point, index:int, weight:Number, color:uint):Site
		//{
			//if (_pool.length > 0)
			//{
				//return _pool.pop().init(p, index, weight, color);
			//}
			//else
			//{
				//return new Site(PrivateConstructorEnforcer, p, index, weight, color);
			//}
		//}
		
		//public function sortSites(sites:Vector.<Site>):void
		//{
			//sites.sort(compare);
		//}

		/**
		 * sort sites on y, then x, coord
		 * also change each site's _siteIndex to match its new position in the list
		 * so the _siteIndex can be used to identify the site for nearest-neighbor queries
		 *
		 * haha "also" - means more than one responsibility...
		 *
		 */
		//private function compare(s1:Site, s2:Site):Number
		//{
			//var returnValue:int = compareByYThenX(s1, s2);
			//
			// swap _siteIndex values if necessary to match new ordering:
			//var tempIndex:int;
			//if (returnValue == -1)
			//{
				//if (s1._siteIndex > s2._siteIndex)
				//{
					//tempIndex = s1._siteIndex;
					//s1._siteIndex = s2._siteIndex;
					//s2._siteIndex = tempIndex;
				//}
			//}
			//else if (returnValue == 1)
			//{
				//if (s2._siteIndex > s1._siteIndex)
				//{
					//tempIndex = s2._siteIndex;
					//s2._siteIndex = s1._siteIndex;
					//s1._siteIndex = tempIndex;
				//}
				//
			//}
			//
			//return returnValue;
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


		private const EPSILON:Number = .005;
		private function closeEnough(p0:Point, p1:Point):Boolean
		{
			var x:Number = (p0.x - p1.x);
			var y:Number = (p0.y - p1.y);
			return (x * x) + (y * y) < EPSILON * EPSILON;
			
			//return Point.distance(p0, p1) < EPSILON;
		}
				
		private var _coord:Point;
		public function get coord():Point
		{
			return _coord;
		}
		
		public var color:uint;
		public var weight:Number;
		
		public var _siteIndex:uint;
		
		// the edges that define this Site's Voronoi region:
		public var edges:Vector.<Edge>;
		//public function get edges():Vector.<Edge>
		//{
			//return _edges;
		//}
		// which end of each edge hooks up with the previous edge in _edges:
		private var _edgeOrientations:Vector.<int>;
		// ordered list of points that define the region clipped to bounds:
		private var _region:Vector.<Point>;

		public function Site(p:Point, index:int, weight:Number, color:uint)
		{
			//if (lock != PrivateConstructorEnforcer)
			//{
				//throw new Error("Site constructor is private");
			//}
			_coord = p;
			_siteIndex = index;
			this.weight = weight;
			this.color = color;
			edges = new Vector.<Edge>();
			_region = null;
			//init(p, index, weight, color);
		}
		
		//private function init(p:Point, index:int, weight:Number, color:uint):Site
		//{
			//_coord = p;
			//_siteIndex = index;
			//this.weight = weight;
			//this.color = color;
			//edges = new Vector.<Edge>();
			//_region = null;
			//return this;
		//}
		
		public function toString():String
		{
			return "Site " + _siteIndex + ": " + coord;
		}
		
		private function move(p:Point):void
		{
			clear();
			_coord = p;
		}
		
		public function dispose():void
		{
			_coord = null;
			clear();
			//_pool.push(this);
		}
		
		private function clear():void
		{
			if (edges)
			{
				edges.length = 0;
				edges = null;
			}
			if (_edgeOrientations)
			{
				_edgeOrientations.length = 0;
				_edgeOrientations = null;
			}
			if (_region)
			{
				_region.length = 0;
				_region = null;
			}
		}
		
		//public function addEdge(edge:Edge):void
		//{
			//_edges.push(edge);
		//}
		
		public function nearestEdge():Edge
		{
			edges.sort(compareSitesDistances);
			return edges[0];
		}
		
		public function compareSitesDistances_MAX(edge0:Edge, edge1:Edge):Number
		{
			var length0:Number = edge0.sitesDistance();
			var length1:Number = edge1.sitesDistance();
			if (length0 < length1)
			{
				return 1;
			}
			if (length0 > length1)
			{
				return -1;
			}
			return 0;
		}
		
		public function compareSitesDistances(edge0:Edge, edge1:Edge):Number
		{
			var length0:Number = edge0.sitesDistance();
			var length1:Number = edge1.sitesDistance();
			if (length0 < length1)
			{
				return -1;
			}
			if (length0 > length1)
			{
				return -1;
			}
			return 0;
		}
		
		public function neighborSites():Vector.<Site>
		{
			if (edges == null || edges.length == 0)
			{
				return new Vector.<Site>();
			}
			if (_edgeOrientations == null)
			{
				reorderEdges();
			}
			var list:Vector.<Site> = new Vector.<Site>();
			var edge:Edge;
			var l:uint = edges.length;
			for (var i:int = 0; i < l; i++)
			{
				list.push( neighborSite( edges[i] ) );
			}
			return list;
		}
			
		private function neighborSite(edge:Edge):Site
		{
			if (this == edge.leftSite)
			{
				return edge.rightSite;
			}
			if (this == edge.rightSite)
			{
				return edge.leftSite;
			}
			return null;
		}
		
		public function region(clippingBounds:Rectangle):Vector.<Point>
		{
			if (edges == null || edges.length == 0)
			{
				return new Vector.<Point>();
			}
			if (_edgeOrientations == null)
			{
				reorderEdges();
				_region = clipToBounds(clippingBounds);
				if ((new Polygon(_region)).winding() == Winding.CLOCKWISE)
				{
					_region = _region.reverse();
				}
			}
			return _region;
		}
		
		private function reorderEdges():void
		{
			//trace("_edges:", _edges);
			var reorderer:EdgeReorderer = new EdgeReorderer(edges, Vertex);
			edges = reorderer.edges;
			//trace("reordered:", _edges);
			_edgeOrientations = reorderer.edgeOrientations;
			//reorderer.dispose();
		}
		
		private function clipToBounds(bounds:Rectangle):Vector.<Point>
		{
			var points:Vector.<Point> = new Vector.<Point>;
			var n:int = edges.length;
			var i:int = 0;
			var edge:Edge;
			while (i < n && (edges[i].visible == false))
			{
				++i;
			}
			
			if (i == n)
			{
				// no edges visible
				return new Vector.<Point>();
			}
			edge = edges[i];
			var orientation:int = _edgeOrientations[i];
			points.push(edge.clippedEnds[orientation]);
			points.push(edge.clippedEnds[orientation == LR.LEFT ? LR.RIGHT : LR.LEFT]);
			
			for (var j:int = i + 1; j < n; ++j)
			{
				edge = edges[j];
				if (edge.visible == false)
				{
					continue;
				}
				connect(points, j, bounds);
			}
			// close up the polygon by adding another corner point of the bounds if needed:
			connect(points, i, bounds, true);
			
			return points;
		}
		
		private function checkBounds(point:Point, bounds:Rectangle):int
		{
			var value:int = 0;
			if (point.x == bounds.left)
			{
				value |= LEFT;
			}
			if (point.x == bounds.right)
			{
				value |= RIGHT;
			}
			if (point.y == bounds.top)
			{
				value |= TOP;
			}
			if (point.y == bounds.bottom)
			{
				value |= BOTTOM;
			}
			return value;
		}
		
		private function connect(points:Vector.<Point>, j:int, bounds:Rectangle, closingUp:Boolean = false):void
		{
			var rightPoint:Point = points[points.length - 1];
			var newEdge:Edge = edges[j];
			var newOrientation:int = _edgeOrientations[j];
			// the point that  must be connected to rightPoint:
			var newPoint:Point = newEdge.clippedEnds[newOrientation];
			if (!closeEnough(rightPoint, newPoint))
			{
				// The points do not coincide, so they must have been clipped at the bounds;
				// see if they are on the same border of the bounds:
				if (rightPoint.x != newPoint.x
				&&  rightPoint.y != newPoint.y)
				{
					// They are on different borders of the bounds;
					// insert one or two corners of bounds as needed to hook them up:
					// (NOTE this will not be correct if the region should take up more than
					// half of the bounds rect, for then we will have gone the wrong way
					// around the bounds and included the smaller part rather than the larger)
					var rightCheck:int = checkBounds(rightPoint, bounds);
					var newCheck:int = checkBounds(newPoint, bounds);
					var px:Number, py:Number;
					if (rightCheck & RIGHT)
					{
						px = bounds.right;
						if (newCheck & BOTTOM)
						{
							py = bounds.bottom;
							points.push(new Point(px, py));
						}
						else if (newCheck & TOP)
						{
							py = bounds.top;
							points.push(new Point(px, py));
						}
						else if (newCheck & LEFT)
						{
							if (rightPoint.y - bounds.y + newPoint.y - bounds.y < bounds.height)
							{
								py = bounds.top;
							}
							else
							{
								py = bounds.bottom;
							}
							points.push(new Point(px, py));
							points.push(new Point(bounds.left, py));
						}
					}
					else if (rightCheck & LEFT)
					{
						px = bounds.left;
						if (newCheck & BOTTOM)
						{
							py = bounds.bottom;
							points.push(new Point(px, py));
						}
						else if (newCheck & TOP)
						{
							py = bounds.top;
							points.push(new Point(px, py));
						}
						else if (newCheck & RIGHT)
						{
							if (rightPoint.y - bounds.y + newPoint.y - bounds.y < bounds.height)
							{
								py = bounds.top;
							}
							else
							{
								py = bounds.bottom;
							}
							points.push(new Point(px, py));
							points.push(new Point(bounds.right, py));
						}
					}
					else if (rightCheck & TOP)
					{
						py = bounds.top;
						if (newCheck & RIGHT)
						{
							px = bounds.right;
							points.push(new Point(px, py));
						}
						else if (newCheck & LEFT)
						{
							px = bounds.left;
							points.push(new Point(px, py));
						}
						else if (newCheck & BOTTOM)
						{
							if (rightPoint.x - bounds.x + newPoint.x - bounds.x < bounds.width)
							{
								px = bounds.left;
							}
							else
							{
								px = bounds.right;
							}
							points.push(new Point(px, py));
							points.push(new Point(px, bounds.bottom));
						}
					}
					else if (rightCheck & BOTTOM)
					{
						py = bounds.bottom;
						if (newCheck & RIGHT)
						{
							px = bounds.right;
							points.push(new Point(px, py));
						}
						else if (newCheck & LEFT)
						{
							px = bounds.left;
							points.push(new Point(px, py));
						}
						else if (newCheck & TOP)
						{
							if (rightPoint.x - bounds.x + newPoint.x - bounds.x < bounds.width)
							{
								px = bounds.left;
							}
							else
							{
								px = bounds.right;
							}
							points.push(new Point(px, py));
							points.push(new Point(px, bounds.top));
						}
					}
				}
				if (closingUp)
				{
					// newEdge's ends have already been added
					return;
				}
				points.push(newPoint);
			}
			var newRightPoint:Point = newEdge.clippedEnds[newOrientation == LR.LEFT ? LR.RIGHT : LR.LEFT];
			if (!closeEnough(points[0], newRightPoint))
			{
				points.push(newRightPoint);
			}
		}
								
		//public function get x():Number
		//{
			//return _coord.x;
		//}
		//public function get y():Number
		//{
			//return _coord.y;
		//}
		
		public function dist(p:ICoord):Number
		{
			var pt:Point = p.coord;
			var x:Number = (pt.x - _coord.x);
			var y:Number = (pt.y - _coord.y);
			return Math.sqrt( (x * x) + (y * y) );
			//return Point.distance(p.coord, this._coord);
		}

	}
}

	//class PrivateConstructorEnforcer {}

	//import flash.geom.Point;
	//import flash.geom.Rectangle;
	
	//final class BoundsCheck
	//{
		//public static const TOP:int = 1;
		//public static const BOTTOM:int = 2;
		//public static const LEFT:int = 4;
		//public static const RIGHT:int = 8;
		//
		///**
		 //*
		 //* @param point
		 //* @param bounds
		 //* @return an int with the appropriate bits set if the Point lies on the corresponding bounds lines
		 //*
		 //*/
		//public static function check(point:Point, bounds:Rectangle):int
		//{
			//var value:int = 0;
			//if (point.x == bounds.left)
			//{
				//value |= LEFT;
			//}
			//if (point.x == bounds.right)
			//{
				//value |= RIGHT;
			//}
			//if (point.y == bounds.top)
			//{
				//value |= TOP;
			//}
			//if (point.y == bounds.bottom)
			//{
				//value |= BOTTOM;
			//}
			//return value;
		//}
		//
		//public function BoundsCheck()
		//{
			//throw new Error("BoundsCheck constructor unused");
		//}
//
	//}