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

    public class EndlessLadder extends Sprite
    {
        private var ladderContainer:Sprite;
        private var ladderVec:Vector.<Border>;

        private var baseGap:int = 50;
        private var randomGap:Number;

        private var viewBorder:Shape;
        private var gcBorder:Shape;

        public function EndlessLadder()
        {
            drawDebugView();

            ladderContainer = new Sprite();

            addChild(ladderContainer);

            ladderVec = new <Border>[];
            createNew();


            addEventListener(Event.ENTER_FRAME, update);
        }

        private function createNew():void
        {
            var border:Border = new Border();
            border.y = gcBorder.y;
            border.x = Math.random() * 320;

            ladderVec.push(border);
            ladderContainer.addChild(border);
        }


        private function drawDebugView():void
        {
            viewBorder = new Shape();
            addChild(viewBorder);
            viewBorder.graphics.beginFill(0, 0.2);
            viewBorder.graphics.drawRect(0, 0, 100, 100);

            viewBorder.x = 100;
            viewBorder.y = 100;

            gcBorder = new Shape();

            addChildAt(gcBorder, 0);

            gcBorder.graphics.beginFill(0xff, 0.2);
            gcBorder.graphics.drawRect(0, 0, 140, 140);

            gcBorder.x = viewBorder.x - ((gcBorder.width - viewBorder.width) >> 1);
            gcBorder.y = viewBorder.y - ((gcBorder.height - viewBorder.height) >> 1);
        }

        private var gcCount:int = 0;
        private var gcInterval:int = 20;

        private function update(event:Event):void
        {
            //create
            if(ladderVec[ladderVec.length-1].y -20 > gcBorder.y)
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
                if(ladderVec[i].shouldDelete) continue;
                if (ladderVec[i].y > gcBorder.y + gcBorder.height)
                {
                    ladderVec[i].shouldDelete = true;
                }
                else
                {
                    ladderVec[i].update();
                    ladderVec[i].y+=10;
                }
            }
        }
    }
}

import flash.display.Sprite;

class Border extends Sprite
{
    public var shouldDelete:Boolean = false;

    public function Border()
    {
        this.graphics.beginFill(Math.random() * 0xffffff);
        this.graphics.drawRect(0, 0, 80 + Math.random() * 50, 20);
    }

    public function update():void
    {

    }
}
