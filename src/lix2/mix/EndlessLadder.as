/**
 * User: lixuexin
 * Date: 13-4-8
 * Time: 上午11:06
 */
package lix2.mix
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.getTimer;

    import nape.Template;

    public class EndlessLadder extends Template
    {
        private var ladderContainer:Sprite;
        private var ladderVec:Vector.<Border>;

        private var baseGap:int = 50;
        private var randomGap:Number = 10

        private var viewBorder:Shape;
        private var gcBorder:Shape;

        public function EndlessLadder()
        {
            super({});
        }

        override protected function init():void
        {


            drawDebugView();

            ladderContainer = new Sprite();

            addChild(ladderContainer);

            ladderVec = new <Border>[];
            createNew();

            speed = 2;
            for (var i:int = 0; i < 200; i++)
            {
                update();
            }
            speed = 0


//            addEventListener(Event.ENTER_FRAME, update);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove)
        }

        private function onMove(event:MouseEvent):void
        {
            trace(mouseX, mouseY);
            var middle:Number = stage.stageHeight >> 1
            if (mouseY < middle)
            {
                speed = (middle - mouseY) / 50;
            }
        }

        private function createNew():void
        {
            var border:Border = new Border();
            border.y = gcBorder.y;
            border.x = Math.random() * 320;

            ladderVec.push(border);
            ladderContainer.addChild(border);

            space.bodies.add(border.body);
        }


        private function drawDebugView():void
        {
            viewBorder = new Shape();
            addChild(viewBorder);
            viewBorder.graphics.beginFill(0, 0.2);
            viewBorder.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);

            viewBorder.x = 0;
            viewBorder.y = 0;

            gcBorder = new Shape();

            addChildAt(gcBorder, 0);

            gcBorder.graphics.beginFill(0xff, 0.2);
            gcBorder.graphics.drawRect(0, 0, viewBorder.width + 40, viewBorder.height + 40);

            gcBorder.x = viewBorder.x - ((gcBorder.width - viewBorder.width) >> 1);
            gcBorder.y = viewBorder.y - ((gcBorder.height - viewBorder.height) >> 1);
        }

        private var gcCount:int = 0;
        private var gcInterval:int = 20;
        private var level:int;

        private function getGap():int
        {
            return baseGap + Math.random() * randomGap + level;
        }

        private var lastUpdateTime:Number = 0;
        private var speed:int = 1;

        override protected function preStep(deltaTime:Number):void
        {
            update()
        }

        private function update(event:Event = null):void
        {
            var time:Number = getTimer();
            if (time - lastUpdateTime > 5000)
            {
                lastUpdateTime = time;
                level++;
                speed += 1
            }
            var gap:Number = getGap();
            //create
            if (ladderVec[ladderVec.length - 1].y - gap > gcBorder.y)
                createNew();

            //gc
            gcCount++;
            if (gcCount > gcInterval)
            {
                for (var i:int = 0; i < ladderVec.length; i++)
                {
                    if (ladderVec[i].shouldDelete)
                    {
                        ladderContainer.removeChild(ladderVec.splice(i, 1)[0]);
                        i--;
                    }
                }
                gcCount = 0;
            }
            //update
            var l:int = 0;
            l = ladderVec.length;
            for (var i:int = 0; i < l; i++)
            {
                if (ladderVec[i].shouldDelete) continue;
                if (ladderVec[i].y > gcBorder.y + gcBorder.height)
                {
                    ladderVec[i].shouldDelete = true;
                }
                else
                {
                    ladderVec[i].update();
                    ladderVec[i].y += speed;
                }
            }
        }
    }
}

import flash.display.Sprite;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;

class Border extends Sprite
{
    public var shouldDelete:Boolean = false;

    public var body:Body;

    public function Border()
    {
        var w:Number = 80 + Math.random() * 50;
        var h:Number = 20;
        this.graphics.beginFill(Math.random() * 0xffffff);
        this.graphics.drawRect(-w >> 1, -h >> 1, w, h);
        body = new Body(BodyType.KINEMATIC);
        body.shapes.add(new Polygon(Polygon.box(w, h, true)));
    }

    public function update():void
    {
        body.position.x = x;
        body.position.y = y;
    }
}
