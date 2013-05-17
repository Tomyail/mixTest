package ui.toggleButton
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	public class MovieToggleButton extends BaseToggleButton
	{
		public function MovieToggleButton(src:MovieClip)
		{
			var index:int = 0;
			if(src.parent)
			{
				this.x = src.x;
				this.y = src.y;
				src.x = 0;
				src.y = 0;
				index = src.parent.getChildIndex(src);
				src.parent.addChildAt(this,index);
			}
			this.src = src;
			this.addChild(src);
			toggled = false;
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		override public function set mouseChildren(enable:Boolean):void
		{
			src.mouseChildren = enable;
			super.mouseChildren = enable;
		}
		
		override public function set mouseEnabled(enabled:Boolean):void
		{
			src.mouseEnabled = enabled;
			super.mouseEnabled = enabled;
		}

		private var src:MovieClip

		override public function set toggled(value:Boolean):void
		{
			super.toggled = value;
			if(toggled)
			{
				src.gotoAndStop(2)
			}
			else
			{
				src.gotoAndStop(1);
			}
		}

		private function onClick(e:MouseEvent):void
		{
			if(mouseChildren == false || mouseEnabled == false || !autoSwitch)
			{
				return;
			}
			toggled = !toggled;
		}
	}
}