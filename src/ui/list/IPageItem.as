package ui.list
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * pagelist a
	 */
	public interface IPageItem
	{
		function setSource(s:DisplayObject):void;
		function setData(data:Object):void;
		function clear():void;
	}
}