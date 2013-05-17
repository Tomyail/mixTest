package ui
{
	import flash.display.DisplayObject;

	public function setPosition(displays:Object,align:String = "Hor"):void
	{
		var key:String;
		var sizeKey:String;
		if (align == Align.HORIZONTAL)
		{
			key = "x";
			sizeKey = "width";
		}
		else
		{
			key = "y";
			sizeKey = "height"
		}
		
		//1开始
		for (var i:int = 1; i < displays.length; i++)
		{
			displays[i][key] = displays[i - 1][key] + displays[i - 1][sizeKey];
		}
	}
}