package nape
{
    import com.bit101.components.PushButton;
    import com.greensock.easing.Back;
    import com.greensock.plugins.CacheAsBitmapPlugin;

    import flash.events.MouseEvent;

    import nape.dynamics.InteractionGroup;
    import nape.geom.Vec2;
    import nape.phys.Body;
    import nape.phys.Body;
    import nape.phys.BodyType;
    import nape.phys.Material;

    [SWF(backgroundColor="0x333333")]
    public class InteractionTest extends Template
    {
        public function InteractionTest()
        {
            stage.color = 0x333333;
            super({
                gravity : Vec2.weak(0, 600),
                showInfo: false
            });
        }

        override protected function init():void
        {

            setup();
            testSimpleFilter();
//            testSimpleGroup();
//            testMultiFilter();
//            testMultiGroup();
//            trace(~3)
        }

        private function testMultiFilter():void
        {
            var ball:Body = createBall(10, 5, 5, new Material(Number.POSITIVE_INFINITY));

            var boxA:Body = createBox(100, 10, BodyType.KINEMATIC, 50, 100);
            boxA.shapes.at(0).filter.collisionGroup = 2;//2^0;
            new PushButton(this, 200, 100, "swapA:filter", clickCallbackA);
            ball.shapes.at(0).filter.collisionMask = 1;
            function clickCallbackA(e:MouseEvent):void
            {
                ball.shapes.at(0).filter.collisionMask = (~boxA.shapes.at(0).filter.collisionGroup) & (boxB.shapes.at(0).filter.collisionGroup);
            }

            var boxB:Body = createBox(100, 10, BodyType.KINEMATIC, 50, 200);
            new PushButton(this, 200, 200, "swapB:filter", clickCallbackB);
            boxB.shapes.at(0).filter.collisionGroup = 4;//2^1;

            function clickCallbackB(e:MouseEvent):void
            {
                ball.shapes.at(0).filter.collisionMask = (~boxB.shapes.at(0).filter.collisionGroup) & (boxA.shapes.at(0).filter.collisionGroup);
                trace(ball.shapes.at(0).filter.collisionMask)
            }
        }

        private function testMultiGroup():void
        {

        }

        private function testSimpleFilter():void
        {
            createBall(10, 5, 5, new Material(Number.POSITIVE_INFINITY));
            var box:Body = createBox(100, 10, BodyType.KINEMATIC, 50, 100);
            new PushButton(this, 200, 100, "swap:filter", clickCallback);
            function clickCallback(e:MouseEvent):void
            {
                box.shapes.at(0).filter.collisionMask = ~box.shapes.at(0).filter.collisionMask;
            }
        }

        private function testSimpleGroup():void
        {
            var group:InteractionGroup = new InteractionGroup();
            var ball:Body = createBall(10, 5, 5, new Material(Number.POSITIVE_INFINITY));
            var box:Body = createBox(100, 10, BodyType.KINEMATIC, 50, 100);
            ball.group = box.group = group;
            new PushButton(this, 200, 100, "swap:group", clickCallback);

            function clickCallback(e:MouseEvent):void
            {
                group.ignore = !group.ignore;
            }
        }

        private function setup():void
        {
            //消除摩擦力
            space.worldAngularDrag = 0;
            space.worldLinearDrag = 0;
            //创建边框
            createBorder();
        }

    }
}
