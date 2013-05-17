package mix.dragList
{
    import com.bit101.components.Label;

    import flash.display.Sprite;

    class ListItem extends Sprite
    {
        private var label:Label;

        private var _data:int = 0;
        private var _id:int = 0;

        public function ListItem(id:int = 0, data:int = -1)
        {
            this._id = id;
            //这个是一个标签组件,只是用来显示的
            label = new Label(this, 0, 0, "");
            this.data = data;
            this.mouseChildren = false;
        }


        public function get id():int
        {
            return _id;
        }


        public function get data():int
        {
            return _data;
        }
        public function set data(value:int):void
        {
            _data = value;
            this.graphics.clear();
            if (value == -1)
            {
                label.text = "";
                this.graphics.beginFill(0x333333, .3);//背景样式
                this.graphics.lineStyle(1, 0xff0000);//边框样式
                this.graphics.drawRect(0, 0, 50, DraggableList.GAP);
            }
            else
            {
                label.text = value.toString();
                this.graphics.beginFill(0, .3);//背景样式
                this.graphics.lineStyle(1);//边框样式
                this.graphics.drawRect(0, 0, 50, DraggableList.GAP);
            }
        }

    }
}
