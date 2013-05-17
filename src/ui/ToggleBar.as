package ui
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    import ui.toggleButton.BaseToggleButton;
    import ui.toggleButton.MovieToggleButton;
    import ui.toggleButton.SimpleToggleButton;
    import ui.utils.getChildrenSortedName;

    public class ToggleBar
    {



        /**
         * @param src 传入一个sp,这个sp包含了所有togglebtn的资源,
		 * @param targetType SimpleToggleButton 或者MovieToggleButton
         * @return
         */
        public static function createToggleBarByMovieClip(src:Sprite,targetType:Class, callback:Function,toggleLayerIndex:int = -1):ToggleBar
        {

			if(targetType == SimpleToggleButton || targetType == MovieToggleButton)
			{
				var nameArr:Array = getChildrenSortedName(src);
				var toggleBtns:Vector.<BaseToggleButton> = new Vector.<BaseToggleButton>();
				for (var i:int = 0; i < nameArr.length; i++)
				{
					var t:BaseToggleButton = new targetType(src.getChildByName(nameArr[i]));
					toggleBtns[i] = t;
				}
				
				return new ToggleBar(toggleBtns, callback,false,toggleLayerIndex);
			}
			else
			{
//				Debug.error("targetType 必须是SimpleToggleButton或者MovieToggleButton");
			}
			
			return null;
        }
		
		private var indexInfo:Vector.<int>;

        /**
         * @param toggleBtns
         * @param callback 接受index参数
         * @param rePosition 如果传入的toggleBtns已经排版好了,可以将此参数设置成false,否则将已第一个坐标为基准按照一定间隙自动排版
         */
        public function ToggleBar(toggleBtns:Vector.<BaseToggleButton>, callback:Function, rePosition:Boolean = false,toggleLayerIndex:int = -1)
        {
			if(!toggleBtns || toggleBtns.length == 0)
//				Debug.trace("空数据,不给力啊");
            this.toggleBtns = toggleBtns
            if (rePosition)
                setPosition(toggleBtns,align);
	
			this.toggleLayerIndex = toggleLayerIndex;
			indexInfo = new Vector.<int>();
			var p:DisplayObjectContainer = toggleBtns[0].parent
			//只能全部加监听 真的...
			for(var i:int = 0;i< toggleBtns.length;i++)
			{
	            toggleBtns[i].addEventListener(MouseEvent.CLICK, onClick);
				indexInfo[i] = p.getChildIndex(toggleBtns[i]);
			}
            this.callback = callback;
            setToggleIndex(currentIndex, false);
        }

		private var currentIndex:int = 0;
        //垂直
        private var align:String = "Hor" //"Vec"

        private var callback:Function;

        private var toggleBtns:Vector.<BaseToggleButton>;

        public function getToggleBtn(index:int):BaseToggleButton
        {
            if (isOutOfRange(index))
                return null;
            return toggleBtns[index];
        }
		
		public function iterateSet(fun:Function):void{
			if(toggleBtns){
				toggleBtns.forEach(function(btn:BaseToggleButton, ...args):void{
					if(fun != null){
						fun(btn);
					}
				});
			}
		}
		
		private var _groupButtonMode:Boolean = false;
		public function setButtonMode(value:Boolean):void{
			if(_groupButtonMode == value){
				return;
			}
			_groupButtonMode = value;
			toggleBtns.forEach(function(btn:BaseToggleButton, ...args):void{
				if(btn){
				   btn.buttonMode = _groupButtonMode;
				}
			});
		}
		
		public function getGroupLen():int{
			return toggleBtns ? toggleBtns.length : 0;
		}
		
		public function get currentToggledIndex():int
		{
			return currentIndex;
		}

        /**
         * 通过索引让某个按钮按下
         * @param index 索引(来自toggleBtns的索引)
         * @param hitCallback 是否触发回调函数
         */
        public function setToggleIndex(index:int, hitCallback:Boolean = true):void
        {
            if (isOutOfRange(index))
                return;
//			if(currentIndex == index) return;
			currentIndex = index
            unToggleAll();
            toggleBtns[currentIndex].toggled = true;
			if(toggleLayerIndex == -1)
				toggleBtns[currentIndex].parent.setChildIndex(toggleBtns[currentIndex],toggleBtns[currentIndex].parent.numChildren-1);
			else
				toggleBtns[currentIndex].parent.setChildIndex(toggleBtns[currentIndex],toggleLayerIndex);
            if (hitCallback && callback!= null)
                callback(currentIndex);
        }
		
		private var toggleLayerIndex:int = 0;

        protected function onClick(event:MouseEvent):void
        {
//            if (event.currentTarget is BaseToggleButton)
//            {
                setToggleIndex(toggleBtns.indexOf(event.currentTarget as BaseToggleButton));
//            }
        }

        private function isOutOfRange(index:int):Boolean
        {
            return index < 0 || index >= toggleBtns.length
        }

//        private function setPosition():void
//        {
//            var key:String;
//            var sizeKey:String;
//            if (align == "Hor")
//            {
//                key = "x";
//                sizeKey = "width";
//            }
//            else
//            {
//                key = "y";
//                sizeKey = "height"
//            }
//
//            //1开始
//            for (var i:int = 1; i < toggleBtns.length; i++)
//            {
//                toggleBtns[i][key] = toggleBtns[i - 1][key] + toggleBtns[i - 1][sizeKey];
//            }
//        }

        private function unToggleAll():void
        {
			var p:DisplayObjectContainer = toggleBtns[0].parent;
            for (var i:int = 0; i < toggleBtns.length; i++)
            {
                toggleBtns[i].toggled = false;
				p.setChildIndex(toggleBtns[i],indexInfo[i]);
            }
        }
    }
}
