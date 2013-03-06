package nape
{
    import com.bit101.components.PushButton;

    import flash.events.MouseEvent;

    import nape.dynamics.InteractionGroup;

    import nape.geom.Vec2;
    import nape.phys.Body;
    import nape.phys.Body;
    import nape.phys.BodyType;
    import nape.phys.Material;

    public class InteractionTest extends Template
    {
        public function InteractionTest()
        {
            super({
                gravity:Vec2.weak(0,600),
                showInfo:false
            });
        }

        override protected function init():void
        {
//            testFilter();
            testGroup();
        }

        private function testFilter():void
        {
            setup();

            createBall(10,5,5,new Material(Number.POSITIVE_INFINITY));
            var box:Body = createBox(100,10,BodyType.KINEMATIC,50,200);
            new PushButton(this, 200,0,"swap:filter",clickCallback);

            function clickCallback(e:MouseEvent):void
            {
                box.shapes.at(0).filter.collisionMask = ~box.shapes.at(0).filter.collisionMask;
            }
        }

        private function testGroup():void
        {
            setup();

            createBall(10,5,5,new Material(Number.POSITIVE_INFINITY));
            var box:Body = createBox(100,10,BodyType.KINEMATIC,50,200);
            new PushButton(this, 200,0,"swap:group",clickCallback);

            function clickCallback(e:MouseEvent):void
            {
                box.shapes.at(0).filter.collisionMask = ~box.shapes.at(0).filter.collisionMask;
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
