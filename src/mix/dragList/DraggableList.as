package mix.dragList
{
    import com.greensock.TweenLite;
    import com.greensock.easing.Sine;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;

    public class DraggableList extends Sprite
    {
        private var itemContainer:Sprite;

        private var listName:String = ""

        public function DraggableList(name:String = "")
        {
            super();
            this.listName = name;
            addEventListener(Event.ADDED_TO_STAGE, init)

        }

        private const TIME:Number = .2;
        private const EASE:Function = Sine.easeInOut;

        public function mouseUpHandler(dragItem:ListItem):Boolean
        {
            preview.visible = false;
            if(isInRange())
            {
                if (items.indexOf(dragItem) != -1)
                {
                    dragItem.x = globalToLocal(dragItem.localToGlobal(new Point())).x;
                    dragItem.y = globalToLocal(dragItem.localToGlobal(new Point())).y;
                    itemContainer.addChild(dragItem);
                    dragItem.alpha = 1;
                    focusUpdate();
                }
                return true;
            }
            return false;
        }

        public function addItem(listItem:ListItem):void
        {
            if (items.indexOf(listItem) == -1)
            {
                items.push(listItem);
            }
            listItem.x = mouseX;
            listItem.y = mouseY;
            itemContainer.addChild(listItem);
            listItem.alpha = 1;
            focusUpdate();
        }

        public function getData():Array
        {
            var result:Array = []
            for(var i:int = 0;i< items.length;i++)
            {
                result[i] = items[i].data;
            }
            return result;
        }

        public function focusUpdate():void
        {
            items.sort(sortFun);
            for (var i:int = 0; i < items.length; i++)
            {
                TweenLite.to(items[i], TIME, {y: GAP * i, x: 0,ease:EASE})
            }
        }

        public function mouseMoveHandler(dragItem:ListItem):void
        {
            if (isInRange())
            {
                preview.visible = true;
                if (items.indexOf(dragItem) == -1)
                {
                    items.push(dragItem);
                }

                update(dragItem);
            }
            else
            {
                preview.visible = false;
                if (items.indexOf(dragItem) != -1)
                {
                    items.splice(items.indexOf(dragItem), 1);
                }
                update(dragItem);
            }
        }

        private function init(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);

            itemContainer = new Sprite();
            addChild(itemContainer);

            preview = new ListItem(-1, -1);
            addChild(preview);
            preview.visible = preview.mouseEnabled = preview.mouseChildren = false;
            preview.alpha = .5;

            drawBorder();
            initList();
        }

        private function drawBorder():void
        {
            itemContainer.graphics.beginFill(0, 0.1);
            itemContainer.graphics.drawRect(0, 0, WIDTH, stage.stageHeight);
        }

        private const WIDTH:int = 100



        private var preview:ListItem;


        public function isInRange():Boolean
        {
            return mouseX >= 0 && mouseX <= WIDTH;
        }


        private function update(dragItem:ListItem):void
        {
            items.sort(sortFun);
            for (var i:int = 0; i < items.length; i++)
            {
                if (items[i] != dragItem)
                {
                    TweenLite.to(items[i], TIME, {y: GAP * i, x: 0,ease:EASE})
                }
                else
                {
                    preview.y = GAP * i;
                }
            }
        }

        private function sortFun(a:ListItem, b:ListItem):Number
        {
            return a.y - b.y;
        }


        private var items:Vector.<ListItem>;
        public static const GAP:int = 20;

        //标识两者是否相同
        private var id:int = 0;

        private function initList():void
        {
            items = new Vector.<ListItem>();
            for (var i:int = 0; i < 4; i++)
            {
                items[i] = new ListItem(id++, i);
                items[i].y = i * GAP;
                itemContainer.addChild(items[i]);
            }
        }
    }
}
