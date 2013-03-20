/*
 * The author of this software is Steven Fortune.  Copyright (c) 1994 by AT&T
 * Bell Laboratories.
 * Permission to use, copy, modify, and distribute this software for any
 * purpose without fee is hereby granted, provided that this entire notice
 * is included in all copies of any software which is or includes a copy
 * or modification of this software and in all copies of the supporting
 * documentation for such software.
 * THIS SOFTWARE IS BEING PROVIDED "AS IS", WITHOUT ANY EXPRESS OR IMPLIED
 * WARRANTY.  IN PARTICULAR, NEITHER THE AUTHORS NOR AT&T MAKE ANY
 * REPRESENTATION OR WARRANTY OF ANY KIND CONCERNING THE MERCHANTABILITY
 * OF THIS SOFTWARE OR ITS FITNESS FOR ANY PARTICULAR PURPOSE.
 */


package com.nodename.Delaunay
{
	import com.nodename.geom.Circle;
	import com.nodename.geom.LineSegment;
	
	//import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public final class Voronoi
	{
		private var _sites:SiteList;
		private var _sitesIndexedByLocation:Dictionary;
		private var _triangles:Vector.<Triangle>;
		private var _edges:Vector.<Edge>;

		
		// TODO generalize this so it doesn't have to be a rectangle;
		// then we can make the fractal voronois-within-voronois
		public var plotBounds:Rectangle;
		//public function get plotBounds():Rectangle
		//{
			//return plotBounds;
		//}
		
		public function dispose():void
		{
			var i:int, n:int;
			if (_sites)
			{
				_sites.dispose();
				_sites = null;
			}
			if (_triangles)
			{
				n = _triangles.length;
				for (i = 0; i < n; ++i)
				{
					_triangles[i].dispose();
				}
				_triangles.length = 0;
				_triangles = null;
			}
			if (_edges)
			{
				n = _edges.length;
				for (i = 0; i < n; ++i)
				{
					_edges[i].dispose();
				}
				_edges.length = 0;
				_edges = null;
			}
			plotBounds = null;
			_sitesIndexedByLocation = null;
		}
		
		public function Voronoi(points:Vector.<Point>, colors:Vector.<uint>, plotBounds:Rectangle)
		{
			_sites = new SiteList();
			_sitesIndexedByLocation = new Dictionary(true);
			addSites(points, colors);
			this.plotBounds = plotBounds;
			_triangles = new Vector.<Triangle>();
			_edges = new Vector.<Edge>();
			fortunesAlgorithm();
		}
		
		private function addSites(points:Vector.<Point>, colors:Vector.<uint>):void
		{
			var length:uint = points.length;
			var p:Point;
			for (var i:uint = 0; i < length; ++i)
			{
				p = points[i];
				var site:Site = new Site(p, i, 0, 0);
				_sites.push(site);
				_sitesIndexedByLocation[p] = site;
				//addSite(points[i], colors ? colors[i] : 0, i);
			}
		}
		
		private function addSite(p:Point, color:uint, index:int):void
		{
			//var weight:Number = Math.random() * 100;
			var site:Site = new Site(p, index, 100, color);
			_sites.push(site);
			_sitesIndexedByLocation[p] = site;
		}
		
		public function region(p:Point):Vector.<Point>
		{
			var site:Site = _sitesIndexedByLocation[p];
			if (!site)
			{
				return new Vector.<Point>();
			}
			return site.region(plotBounds);
		}
		
		public function neighborSitesForSite(coord:Point):Vector.<Point>
		{
			var points:Vector.<Point> = new Vector.<Point>();
			var site:Site = _sitesIndexedByLocation[coord];
			if (!site)
			{
				return points;
			}
			var sites:Vector.<Site> = site.neighborSites();
			var neighbor:Site;
			var l:uint = sites.length;
			for (var i:int = 0; i < l; i++)
			{
				points.push(sites[i].coord);
			}
			return points;
		}

		public function circles():Vector.<Circle>
		{
			return _sites.circles();
		}
		
		public function voronoiBoundaryForSite(coord:Point):Vector.<LineSegment>
		{
			return visibleLineSegments(selectEdgesForSitePoint(coord, _edges));
		}

		public function delaunayLinesForSite(coord:Point):Vector.<LineSegment>
		{
			return delaunayLinesForEdges(selectEdgesForSitePoint(coord, _edges));
		}
		
		public function voronoiDiagram():Vector.<LineSegment>
		{
			return visibleLineSegments(_edges);
		}
		
		//public function delaunayTriangulation(keepOutMask:BitmapData = null):Vector.<LineSegment>
		//{
			//return delaunayLinesForEdges(selectNonIntersectingEdges(keepOutMask, _edges));
		//}
		
		public function hull():Vector.<LineSegment>
		{
			return delaunayLinesForEdges(hullEdges());
		}
		
		private function hullEdges():Vector.<Edge>
		{
			return _edges.filter(myTest);
		
			function myTest(edge:Edge, index:int, vector:Vector.<Edge>):Boolean
			{
				return (edge.isPartOfConvexHull());
			}
		}

		public function hullPointsInOrder():Vector.<Point>
		{
			var hullEdges:Vector.<Edge> = hullEdges();
			
			var points:Vector.<Point> = new Vector.<Point>();
			if (hullEdges.length == 0)
			{
				return points;
			}
			
			var reorderer:EdgeReorderer = new EdgeReorderer(hullEdges, Site);
			hullEdges = reorderer.edges;
			var orientations:Vector.<int> = reorderer.edgeOrientations;
			//reorderer.dispose();
			
			var orientation:int;

			var n:int = hullEdges.length;
			for (var i:int = 0; i < n; ++i)
			{
				var edge:Edge = hullEdges[i];
				orientation = orientations[i];
				points.push(edge.site(orientation).coord);
			}
			return points;
		}
		
		//public function spanningTree(type:String = "minimum", keepOutMask:BitmapData = null):Vector.<LineSegment>
		//{
			//var edges:Vector.<Edge> = selectNonIntersectingEdges(keepOutMask, _edges);
			//var segments:Vector.<LineSegment> = delaunayLinesForEdges(edges);
			//return kruskal(segments, type);
		//}

		public function regions():Vector.<Vector.<Point>>
		{
			return _sites.regions(plotBounds);
		}
		
		//public function siteColors(referenceImage:BitmapData = null):Vector.<uint>
		//{
			//return _sites.siteColors(referenceImage);
		//}
		
		/**
		 *
		 * @param proximityMap a BitmapData whose regions are filled with the site index values; see PlanePointsCanvas::fillRegions()
		 * @param x
		 * @param y
		 * @return coordinates of nearest Site to (x, y)
		 *
		 */
		//public function nearestSitePoint(proximityMap:BitmapData, x:Number, y:Number):Point
		//{
			//return _sites.nearestSitePoint(proximityMap, x, y);
		//}
		
		public function siteCoords():Vector.<Point>
		{
			return _sites.siteCoords();
		}

		private function fortunesAlgorithm():void
		{
			var newSite:Site, bottomSite:Site, topSite:Site, tempSite:Site;
			var v:Vertex, vertex:Vertex;
			var newintstar:Point;
			var leftRight:int;
			var lbnd:Halfedge, rbnd:Halfedge, llbnd:Halfedge, rrbnd:Halfedge, bisector:Halfedge;
			var edge:Edge;
			
			var dataBounds:Rectangle = _sites.getSitesBounds();
			
			var sqrt_nsites:int = int(Math.sqrt(_sites.length + 4));
			var heap:HalfedgePriorityQueue = new HalfedgePriorityQueue(dataBounds.y, dataBounds.height, sqrt_nsites);
			var edgeList:EdgeList = new EdgeList(dataBounds.x, dataBounds.width, sqrt_nsites);
			var halfEdges:Vector.<Halfedge> = new Vector.<Halfedge>();
			var vertices:Vector.<Vertex> = new Vector.<Vertex>();
			
			var bottomMostSite:Site = _sites.next();
			newSite = _sites.next();
			
			while ( true )
			{
				if (heap.empty() == false)
				{
					newintstar = heap.min();
				}
			
				if (newSite != null
				&&  (heap.empty() || compareByYThenXPoint(newSite, newintstar) < 0))
				{
					/* new site is smallest */
					//trace("smallest: new site " + newSite);
					
					// Step 8:
					lbnd = edgeList.edgeListLeftNeighbor(newSite.coord);	// the Halfedge just to the left of newSite
					//trace("lbnd: " + lbnd);
					rbnd = lbnd.edgeListRightNeighbor;		// the Halfedge just to the right
					//trace("rbnd: " + rbnd);
					bottomSite = lbnd.edge ? lbnd.edge.site(lbnd.leftRight == LR.LEFT ? LR.RIGHT : LR.LEFT) : bottomMostSite; //rightRegion(lbnd);		// this is the same as leftRegion(rbnd)
					// this Site determines the region containing the new site
					//trace("new Site is in region of existing site: " + bottomSite);
					
					// Step 9:
					edge = createBisectingEdge(bottomSite, newSite);
					//trace("new edge: " + edge);
					_edges.push(edge);
					
					bisector = new Halfedge(edge, LR.LEFT);
					halfEdges.push(bisector);
					// inserting two Halfedges into edgeList constitutes Step 10:
					// insert bisector to the right of lbnd:
					edgeList.insert(lbnd, bisector);
					
					// first half of Step 11:
					if ((vertex = intersect(lbnd, bisector)) != null)
					{
						vertices.push(vertex);
						heap.remove(lbnd);
						lbnd.vertex = vertex;
						lbnd.ystar = vertex.coord.y + newSite.dist(vertex);
						heap.insert(lbnd);
					}
					
					lbnd = bisector;
					bisector = new Halfedge(edge, LR.RIGHT);
					halfEdges.push(bisector);
					// second Halfedge for Step 10:
					// insert bisector to the right of lbnd:
					edgeList.insert(lbnd, bisector);
					
					// second half of Step 11:
					if ((vertex = intersect(bisector, rbnd)) != null)
					{
						vertices.push(vertex);
						bisector.vertex = vertex;
						bisector.ystar = vertex.coord.y + newSite.dist(vertex);
						heap.insert(bisector);
					}
					
					newSite = _sites.next();
				}
				else if (heap.empty() == false)
				{
					/* intersection is smallest */
					lbnd = heap.extractMin();
					llbnd = lbnd.edgeListLeftNeighbor;
					rbnd = lbnd.edgeListRightNeighbor;
					rrbnd = rbnd.edgeListRightNeighbor;
					bottomSite = lbnd.edge ? lbnd.edge.site(lbnd.leftRight) : bottomMostSite;// leftRegion(lbnd);
					topSite = rbnd.edge ? rbnd.edge.site(rbnd.leftRight == LR.LEFT ? LR.RIGHT : LR.LEFT) : bottomMostSite; //rightRegion(rbnd);
					// these three sites define a Delaunay triangle
					// (not actually using these for anything...)
					//_triangles.push(new Triangle(bottomSite, topSite, rightRegion(lbnd)));
					
					v = lbnd.vertex;
					v.setIndex();
					lbnd.edge.setVertex(lbnd.leftRight, v);
					rbnd.edge.setVertex(rbnd.leftRight, v);
					edgeList.remove(lbnd);
					heap.remove(rbnd);
					edgeList.remove(rbnd);
					leftRight = LR.LEFT;
					if (bottomSite.coord.y > topSite.coord.y)
					{
						tempSite = bottomSite; bottomSite = topSite; topSite = tempSite; leftRight = LR.RIGHT;
					}
					edge = createBisectingEdge(bottomSite, topSite);
					_edges.push(edge);
					bisector = new Halfedge(edge, leftRight);
					halfEdges.push(bisector);
					edgeList.insert(llbnd, bisector);
					edge.setVertex(leftRight == LR.LEFT ? LR.RIGHT : LR.LEFT, v);
					if ((vertex = intersect(llbnd, bisector)) != null)
					{
						vertices.push(vertex);
						heap.remove(llbnd);
						llbnd.vertex = vertex;
						llbnd.ystar = vertex.coord.y + bottomSite.dist(vertex);
						heap.insert(llbnd);
					}
					if ((vertex = intersect(bisector, rrbnd)) != null)
					{
						vertices.push(vertex);
						bisector.vertex = vertex;
						bisector.ystar = vertex.coord.y + bottomSite.dist(vertex);
						heap.insert(bisector);
					}
				}
				else
				{
					break;
				}
			}
			
			// heap should be empty now
			//heap.dispose();
			//edgeList.dispose();
			//
			//for each (var halfEdge:Halfedge in halfEdges)
			//{
				//halfEdge.reallyDispose();
			//}
			//halfEdges.length = 0;
			
			// we need the vertices to clip the edges
			var l:uint = _edges.length;
			for (var i:int = 0; i < l; i++)
			{
				_edges[i].clipVertices(plotBounds);
			}
			// but we don't actually ever use them again!
			//for each (vertex in vertices)
			//{
				//vertex.dispose();
			//}
			//vertices.length = 0;
			
			//function leftRegion(he:Halfedge):Site
			//{
				//var edge:Edge = he.edge;
				//if (edge == null)
				//{
					//return bottomMostSite;
				//}
				//return edge.site(he.leftRight);
			//}
			
			//function rightRegion(he:Halfedge):Site
			//{
				//var edge:Edge = he.edge;
				//if (edge == null)
				//{
					//return bottomMostSite;
				//}
				//return edge.site(he.leftRight == LR.LEFT ? LR.RIGHT : LR.LEFT);
				//he.edge ? he.edge.site(he.leftRight == LR.LEFT ? LR.RIGHT : LR.LEFT) : bottomMostSite;
			//}
		}
		
		/**
		 * This is the only way to create a new Edge
		 * @param site0
		 * @param site1
		 * @return
		 *
		 */
		public function createBisectingEdge(site0:Site, site1:Site):Edge
		{
			var dx:Number, dy:Number, absdx:Number, absdy:Number;
			var a:Number, b:Number, c:Number;
		
			var p0:Point = site0.coord;
			var p1:Point = site1.coord;
			dx = p1.x - p0.x;
			dy = p1.y - p0.y;
			absdx = dx > 0 ? dx : -dx;
			absdy = dy > 0 ? dy : -dy;
			c = p0.x * dx + p0.y * dy + (dx * dx + dy * dy) * 0.5;
			if (absdx > absdy)
			{
				a = 1.0; b = dy/dx; c /= dx;
			}
			else
			{
				b = 1.0; a = dx/dy; c /= dy;
			}
			
			var edge:Edge = new Edge();
		
			edge.leftSite = site0;
			edge.rightSite = site1;
			site0.edges.push(edge);
			site1.edges.push(edge);
			
			edge.leftVertex = null;
			edge.rightVertex = null;
			
			edge.a = a; edge.b = b; edge.c = c;
			//trace("createBisectingEdge: a ", edge.a, "b", edge.b, "c", edge.c);
			
			return edge;
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

		public function compareByYThenXPoint(s1:Site, s2:Point):Number
		{
			var p1:Point = s1.coord;
			if (p1.y < s2.y) return -1;
			if (p1.y > s2.y) return 1;
			if (p1.x < s2.x) return -1;
			if (p1.x > s2.x) return 1;
			return 0;
		}

	}
}