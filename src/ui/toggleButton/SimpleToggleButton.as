package ui.toggleButton
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	public class SimpleToggleButton extends BaseToggleButton
	{
		public function SimpleToggleButton(src:DisplayObject)
		{
			if(src.parent)
			{
				this.x = src.x;
				this.y = src.y;
				src.x = 0;
				src.y = 0;
				src.parent.addChild(this);
			}
			this.src = src;
			this.addChild(src);
			toggled = false;
			oriX = src.x;
			oriY = src.y;
			
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private const OFFSET:int = 5;
		private var oriX:int;
		private var oriY:int;
		private var src:DisplayObject;
		
		override public function set toggled(value:Boolean):void
		{
			super.toggled = value;
			if(toggled)
			{
				src.x +=OFFSET;
				src.y +=OFFSET;
			}
			else
			{
				src.x = oriX;
				src.y = oriY;
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			toggled = !toggled;
		}
	}
}