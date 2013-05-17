package ui.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 查找自定元件的字元件,收集_+数字元件名字 并排序返回
	 */
	//其元件名字要形如_number(_前缀加数字),数字大的自动排后面
	public function getChildrenSortedName(sp:DisplayObjectContainer,prefix:String = "_"):Array
	{
		var l:int= sp.numChildren;
		var c:DisplayObject
		var nameArr:Array = [];
		var name:String;
		var reg:RegExp = new RegExp(prefix+"\\d+$","g");
		for (var i:int = 0; i < l; i++)
		{
			c = sp.getChildAt(i);
			name = c.name;
			if (name.match(reg).length)
				nameArr.push(name);
		}
		nameArr.sort(comp);
		
		function comp(a:String, b:String):Number
		{
			return int(a.slice(prefix.length)) - int(b.slice(prefix.length));
		}
		return nameArr;
	}
	
}