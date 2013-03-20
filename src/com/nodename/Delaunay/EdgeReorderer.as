package com.nodename.Delaunay
{
	
	
	public final class EdgeReorderer
	{
		public const VERTEX_AT_INFINITY:Vertex = new Vertex(NaN, NaN);
		
		public var edges:Vector.<Edge>;
		public var edgeOrientations:Vector.<int>;
		//public function get edges():Vector.<Edge>
		//{
			//return edges;
		//}
		//public function get edgeOrientations():Vector.<int>
		//{
			//return edgeOrientations;
		//}
		
		public function EdgeReorderer(origEdges:Vector.<Edge>, criterion:Class)
		{
			if (criterion != Vertex && criterion != Site)
			{
				throw new ArgumentError("Edges: criterion must be Vertex or Site");
			}
			edges = new Vector.<Edge>();
			edgeOrientations = new Vector.<int>();
			if (origEdges.length > 0)
			{
				edges = reorderEdges(origEdges, criterion);
			}
		}
		
		public function dispose():void
		{
			edges = null;
			edgeOrientations = null;
		}

		private function reorderEdges(origEdges:Vector.<Edge>, criterion:Class):Vector.<Edge>
		{
			var i:int;
			var j:int;
			var n:int = origEdges.length;
			var edge:Edge;
			// we're going to reorder the edges in order of traversal
			var done:Vector.<Boolean> = new Vector.<Boolean>(n, true);
			var nDone:int = 0;
			var l:uint = done.length;
			for (var k:int = 0; k < l; k++)
			{
				done[k] = false;
			}
			var newEdges:Vector.<Edge> = new Vector.<Edge>();
			
			i = 0;
			edge = origEdges[i];
			newEdges.push(edge);
			edgeOrientations.push(LR.LEFT);
			var firstPoint:ICoord = (criterion == Vertex) ? edge.leftVertex : edge.leftSite;
			var lastPoint:ICoord = (criterion == Vertex) ? edge.rightVertex : edge.rightSite;
			
			if (firstPoint == VERTEX_AT_INFINITY || lastPoint == VERTEX_AT_INFINITY)
			{
				return new Vector.<Edge>();
			}
			
			done[i] = true;
			++nDone;
			
			while (nDone < n)
			{
				for (i = 1; i < n; ++i)
				{
					if (done[i])
					{
						continue;
					}
					edge = origEdges[i];
					var leftPoint:ICoord = (criterion == Vertex) ? edge.leftVertex : edge.leftSite;
					var rightPoint:ICoord = (criterion == Vertex) ? edge.rightVertex : edge.rightSite;
					if (leftPoint == VERTEX_AT_INFINITY || rightPoint == VERTEX_AT_INFINITY)
					{
						return new Vector.<Edge>();
					}
					if (leftPoint == lastPoint)
					{
						lastPoint = rightPoint;
						edgeOrientations.push(LR.LEFT);
						newEdges.push(edge);
						done[i] = true;
					}
					else if (rightPoint == firstPoint)
					{
						firstPoint = leftPoint;
						edgeOrientations.unshift(LR.LEFT);
						newEdges.unshift(edge);
						done[i] = true;
					}
					else if (leftPoint == firstPoint)
					{
						firstPoint = rightPoint;
						edgeOrientations.unshift(LR.RIGHT);
						newEdges.unshift(edge);
						done[i] = true;
					}
					else if (rightPoint == lastPoint)
					{
						lastPoint = leftPoint;
						edgeOrientations.push(LR.RIGHT);
						newEdges.push(edge);
						done[i] = true;
					}
					if (done[i])
					{
						++nDone;
					}
				}
			}
			
			return newEdges;
		}

	}
}