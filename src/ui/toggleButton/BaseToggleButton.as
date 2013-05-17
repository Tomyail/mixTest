package ui.toggleButton
{
    import flash.utils.getQualifiedClassName;

    import ui.UIBase;

    public class BaseToggleButton extends UIBase implements IBaseToggleButton
	{
		public function BaseToggleButton()
		{
			if (getQualifiedClassName(this) == "tool.ui.toggleButton::BaseToggleButton")
			{
//				Debug.error("BaseToggleButton:抽象类");
			}
		}
		
		internal var _toggled:Boolean = false;
		
		public var autoSwitch:Boolean = true;

		public function get toggled():Boolean
		{
			return _toggled;
		}
		public function set toggled(value:Boolean):void
		{
			if(_toggled == value) return;
			_toggled = value;
		}
	}
}