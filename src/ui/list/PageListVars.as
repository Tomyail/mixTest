package ui.list
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.text.TextField;

	public class PageListVars
	{
		public function PageListVars()
		{
		}
		
		/**
		 * must  have
		 */
		public var source:DisplayObjectContainer;
		/**must have and implement IPageItem*/
		public var itemRender:Class;
		public var txt_page:TextField;
		public var btn_pre:InteractiveObject;
		public var btn_next:InteractiveObject;
		
		/**source下面前缀带有这个标记的都会被当作字对象处理*/
		public var prefix:String = "_";
		
		/**列表翻页时发送消息,未实现*/
		public var dispatchPageChange:Boolean = false;
	}
}