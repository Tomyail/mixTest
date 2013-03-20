package com.nodename.geom
{
	import flash.errors.IllegalOperationError;

	public final class Winding
	{
		//public static const CLOCKWISE:Winding = new Winding(PrivateConstructorEnforcer, "clockwise");
		//public static const COUNTERCLOCKWISE:Winding = new Winding(PrivateConstructorEnforcer, "counterclockwise");
		//public static const NONE:Winding = new Winding(PrivateConstructorEnforcer, "none");
		public static const CLOCKWISE:String = "clockwise";
		public static const COUNTERCLOCKWISE:String = "counterclockwise";
		public static const NONE:String = "none";
		
		private var _name:String;
		
		//public function Winding(lock:Class, name:String)
		public function Winding(name:String)
		{
			//super();
			//if (lock != PrivateConstructorEnforcer)
			//{
				//throw new IllegalOperationError("Invalid constructor access");
			//}
			_name = name;
		}
		
		public function toString():String
		{
			return _name;
		}
	}
}

//class PrivateConstructorEnforcer {}