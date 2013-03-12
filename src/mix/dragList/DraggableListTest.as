package mix.dragList
{
    import com.bit101.components.Label;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.text.TextField;

    public class DraggableListTest extends Sprite
    {
        private var listA:DraggableList;
        private var listB:DraggableList;
        private var debug:Label;
        public function DraggableListTest()
        {
            addEventListener(Event.ADDED_TO_STAGE,init)
        }

        private function init(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE,init);

            listA = new DraggableList("A");
            addChild(listA);

            listB = new DraggableList("B");
            listB.x = 100;
            addChild(listB);

            debug = addChild(new Label()) as Label;
            debug.x = 200;
            initListener();
        }

        private function initListener():void
        {
            stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseHandler);
            stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
        }

        private function getActiveList():DraggableList
        {
            if(listA.isInRange())
                return listA;
            if(listB.isInRange())
                return listB;
            return null;
        }

        public var isMouseDown:Boolean = false;
        public var dragItem:ListItem;
        private var activeList:DraggableList;
        private function mouseHandler(event:MouseEvent):void
        {
            var targetItem:ListItem = event.target as ListItem;
            switch (event.type)
            {
                case MouseEvent.MOUSE_DOWN:
                    if (targetItem)
                    {
                        isMouseDown = true;
                        dragItem = targetItem;
                        dragItem.x = dragItem.localToGlobal(new Point(0,0)).x;
                        dragItem.y = dragItem.localToGlobal(new Point(0,0)).y;
                        this.addChild(dragItem);
                        dragItem.startDrag();
                        dragItem.alpha = 0.1;
                    }
                    break;
                case MouseEvent.MOUSE_UP:
                    isMouseDown = false;
                    if (dragItem)
                    {
                        if(!listA.mouseUpHandler(dragItem) && !listB.mouseUpHandler(dragItem))
                        {
                            activeList.addItem(dragItem);
                        }
                        dragItem.stopDrag();
                        dragItem = null;
                    }
                    debug.text = listA.getData().join(":");
                    break;
                case MouseEvent.MOUSE_MOVE:
                    if (!isMouseDown) return;
                    if(getActiveList())
                    {
                        activeList = getActiveList();
                    }
                    listA.mouseMoveHandler(dragItem);
                    listB.mouseMoveHandler(dragItem);
                    break;
            }
        }
    }
}
