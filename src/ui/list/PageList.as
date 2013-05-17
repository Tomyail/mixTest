package ui.list
{
    import flash.events.MouseEvent;

    import ui.utils.getChildrenSortedName;

    public class PageList
	{
		public function PageList(vars:PageListVars)
		{
			this.vars = vars;
			if(!vars.source)
				Log.logger.error("source must have");
			if(!vars.itemRender )/**|| !(vars.itemRender as IPageItem)*/
                Log.logger.error("must have and implement IPageItem");
			createItems();
		}
		
		private var _currentPage:int;
		private var _data:Array = [];
		private var _pageItem:int;
		private var _totalPage:int;
		
		private var items:Vector.<IPageItem>;
		private var vars:PageListVars;

		/**
		 * 当前页(0开始) 
		 * @return 
		 * 
		 */		
		public function get currentPage():int
		{
			return _currentPage;
		}
		
		public function get data():Array
		{
			return _data;
		}

		public function set data(value:Array):void
		{
			_data = value;
			_totalPage = Math.ceil(_data.length/_pageItem);//0/1->0 1/1->1
			gotoPage(0);
		}

		public function goToNext():void
		{
			gotoPage(++_currentPage);
		}
		
		public function gotoPage(page:int):void
		{
			//verify page
			if(_currentPage < 0 || _totalPage == 0)
				_currentPage = 0;
			else if(_currentPage >= _totalPage)
				_currentPage = _totalPage-1;
			
			//set visual thing
			if(vars.txt_page)
				vars.txt_page.text = int(currentPage+1)+"/"+(_totalPage == 0 ? 1:_totalPage);

			if(vars.btn_next)
			{
				vars.btn_next.mouseEnabled = false;
				if(_currentPage < _totalPage-1)
					vars.btn_next.mouseEnabled = true;
			}
			
			if(vars.btn_pre)
			{
				vars.btn_pre.mouseEnabled = false
				if(_currentPage>0)
					vars.btn_pre.mouseEnabled = true;
			}
			
			//data
			render(_data.slice(_currentPage*_pageItem,_currentPage*_pageItem+_pageItem));
			
		}

		public function gotoPre():void
		{
			gotoPage(--_currentPage);
		}

		/**
		 * 每页的单元数 
		 * @return 
		 */
		public function get pageItem():int
		{
			return _pageItem;
		}

		/**总页数*/
		public function get totalPage():int
		{
			return _totalPage;
		}
		
		private function createItems():void
		{
			var names:Array = getChildrenSortedName(vars.source,vars.prefix);
			if(names.length == 0)
				Log.logger.error("no children found");
			_pageItem = names.length;
			items = new Vector.<IPageItem>();
			for(var i:int = 0;i< _pageItem;i++)
			{
				items[i] = new vars.itemRender();
				IPageItem(items[i]).setSource(vars.source.getChildByName(names[i]));
				IPageItem(items[i]).clear();
			}
			
			if(vars.btn_next)
				vars.btn_next.addEventListener(MouseEvent.CLICK,function():void{goToNext()});
			if(vars.btn_pre)
				vars.btn_pre.addEventListener(MouseEvent.CLICK,function():void{gotoPre()});
			gotoPage(0);
		}
		
		private function render(data:Array):void
		{
			for(var i:int = 0;i< _pageItem;i++)
			{
				if(data.length>i)
				{
					items[i].setData(data[i]);
				}
				else
				{
					items[i].clear();
				}
			}
		}
	}
}