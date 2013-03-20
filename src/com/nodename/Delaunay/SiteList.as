package com.nodename.Delaunay
{
	import com.nodename.geom.Circle;
	import com.nodename.utils.IDisposable;
	
	//import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public final class SiteList implements IDisposable
	{
		private var _sites:Vector.<Site>;
		private var _currentIndex:uint;
		
		private var _sorted:Boolean;
		
		public function SiteList()
		{
			_sites = new Vector.<Site>();
			_sorted = false;
		}
		
		public function dispose():void
		{
			if (_sites)
			{
				for each (var site:Site in _sites)
				{
					site.dispose();
				}
				_sites.length = 0;
				_sites = null;
			}
		}
		
		public function push(site:Site):uint
		{
			_sorted = false;
			return _sites.push(site);
		}
		
		public function get length():uint
		{
			return _sites.length;
		}
		
		public function next():Site
		{
			if (_sorted == false)
			{
				throw new Error("SiteList::next():  sites have not been sorted");
			}
			if (_currentIndex < _sites.length)
			{
				return _sites[_currentIndex++];
			}
			else
			{
				return null;
			}
		}

		public function getSitesBounds():Rectangle
		{
			if (_sorted == false)
			{
				_sites.sort(compare);
				//sortSites(_sites);
				_currentIndex = 0;
				_sorted = true;
			}
			var xmin:Number, xmax:Number, ymin:Number, ymax:Number;
			if (_sites.length == 0)
			{
				return new Rectangle(0, 0, 0, 0);
			}
			xmin = Number.MAX_VALUE;
			xmax = Number.MIN_VALUE;
			var p:Point;
			var l:uint = _sites.length;
			for (var i:int = 0; i < l; i++)
			{
				p = _sites[i].coord;
				if (p.x < xmin)
				{
					xmin = p.x;
				}
				if (p.x > xmax)
				{
					xmax = p.x;
				}
			}
			// here's where we assume that the sites have been sorted on y:
			ymin = _sites[0].coord.y;
			ymax = _sites[_sites.length - 1].coord.y;
			
			return new Rectangle(xmin, ymin, xmax - xmin, ymax - ymin);
		}
		
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
		private function compare(s1:Site, s2:Site):Number
		{
			var returnValue:int = compareByYThenX(s1, s2);
			
			// swap _siteIndex values if necessary to match new ordering:
			var tempIndex:int;
			if (returnValue == -1)
			{
				if (s1._siteIndex > s2._siteIndex)
				{
					tempIndex = s1._siteIndex;
					s1._siteIndex = s2._siteIndex;
					s2._siteIndex = tempIndex;
				}
			}
			else if (returnValue == 1)
			{
				if (s2._siteIndex > s1._siteIndex)
				{
					tempIndex = s2._siteIndex;
					s2._siteIndex = s1._siteIndex;
					s1._siteIndex = tempIndex;
				}
				
			}
			
			return returnValue;
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

		//public function siteColors(referenceImage:BitmapData = null):Vector.<uint>
		//{
			//var colors:Vector.<uint> = new Vector.<uint>();
			//for each (var site:Site in _sites)
			//{
				//colors.push(referenceImage ? referenceImage.getPixel(site.x, site.y) : site.color);
			//}
			//return colors;
		//}

		public function siteCoords():Vector.<Point>
		{
			var coords:Vector.<Point> = new Vector.<Point>();
			var l:uint = _sites.length;
			for (var i:int = 0; i < l; i++)
			{
				coords.push(_sites[i].coord);
			}
			return coords;
		}

		/**
		 *
		 * @return the largest circle centered at each site that fits in its region;
		 * if the region is infinite, return a circle of radius 0.
		 *
		 */
		public function circles():Vector.<Circle>
		{
			var circles:Vector.<Circle> = new Vector.<Circle>();
			var p:Point;
			var site:Site;
			var l:uint = _sites.length;
			for (var i:int = 0; i < l; i++)
			{
				site = _sites[i];
				p = site.coord;
				var radius:Number = 0;
				var nearestEdge:Edge = site.nearestEdge();
				
				!nearestEdge.isPartOfConvexHull() && (radius = nearestEdge.sitesDistance() * 0.5);
				circles.push(new Circle(p.x, p.y, radius));
			}
			return circles;
		}

		public function regions(plotBounds:Rectangle):Vector.<Vector.<Point>>
		{
			var regions:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
			var l:uint = _sites.length;
			var site:Site;
			for (var i:int = 0; i < l; i++)
			{
				regions.push( _sites[i].region(plotBounds) );
			}
			return regions;
		}

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
			//var index:uint = proximityMap.getPixel(x, y);
			//if (index > _sites.length - 1)
			//{
				//return null;
			//}
			//return _sites[index].coord;
		//}
		
	}
}