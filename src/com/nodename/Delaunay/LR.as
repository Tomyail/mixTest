package com.nodename.Delaunay
{
	public final class LR
	{
		//public static const LEFT:LR = new LR(PrivateConstructorEnforcer, "left");
		//public static const RIGHT:LR = new LR(PrivateConstructorEnforcer, "right");
		public static const LEFT:int = 0;
		public static const RIGHT:int = 1;
		
		private var _name:String;
		
		//public function LR(lock:Class, name:String)
		public function LR(name:String)
		{
			//if (lock != PrivateConstructorEnforcer)
			//{
				//throw new Error("Illegal constructor access");
			//}
			_name = name;
		}
		
		//public static function other(leftRight:LR):LR
		//{
			//return leftRight == LEFT ? RIGHT : LEFT;
		//}
		
		public function toString():String
		{
			return _name;
		}

	}
}

//class PrivateConstructorEnforcer {}
