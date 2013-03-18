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
    import nape.phys.Body;
    import nape.phys.BodyType;
    import nape.phys.Compound;
    import nape.phys.Material;
    import nape.shape.Circle;
    import nape.shape.Shape;

    public class InteractionTest extends Template
    {
        public function InteractionTest()
        {
            super({
                gravity : Vec2.weak(0, 600),
                showInfo: false
            });
        }

        override protected function init():void
        {

            setup();
//            testSimpleFilter();
//            testSimpleGroup();

//            testMultiFilter();
//            testMultiGroup();

            testDemoGroup();
        }


        private function testMultiFilter():void
        {

            var Ba1:Body = createBall(10,110,100);
            var Ba2:Body = createBall(10,100,100);

            Ba1.shapes.at(0).filter.collisionGroup = 1;
            Ba2.shapes.at(0).filter.collisionGroup = 1;

            Ba1.shapes.at(0).filter.collisionMask = ~1;
            Ba2.shapes.at(0).filter.collisionMask = ~1;

            var Bb1:Body = createBall(50,110,100);
            var Bb2:Body = createBall(50,100,100);

            Bb1.shapes.at(0).filter.collisionGroup = 2;
            Bb2.shapes.at(0).filter.collisionGroup = 2;

            Bb1.shapes.at(0).filter.collisionMask = ~4;
            Bb2.shapes.at(0).filter.collisionMask = ~4;


            var Bc1:Body = createBall(100,110,100);
            var Bc2:Body = createBall(100,100,100);

            Bc1.shapes.at(0).filter.collisionGroup = 4;
            Bc2.shapes.at(0).filter.collisionGroup = 4;

            Bc1.shapes.at(0).filter.collisionMask = ~(4|2);
            Bc2.shapes.at(0).filter.collisionMask = ~(4|2);
        }

        private function testMultiGroup():void
        {
            var groupA:InteractionGroup = new InteractionGroup(true);
            var groupB:InteractionGroup = new InteractionGroup(false);
            var groupC:InteractionGroup = new InteractionGroup(true);

            var groupAB:InteractionGroup = new InteractionGroup(false);
            var groupBC:InteractionGroup = new InteractionGroup(true);
            var groupAC:InteractionGroup = new InteractionGroup(false);

            groupA.group = groupAB;
            groupA.group = groupAC;

            groupB.group = groupAB;
            groupB.group = groupBC;

            groupC.group = groupAC;
            groupC.group = groupBC;

            var Ba1:Body = createBall(10,110,100);
            var Ba2:Body = createBall(10,100,100);
            Ba1.group = groupA;
            Ba2.group = groupA;

            var Bb1:Body = createBall(50,110,100);
            var Bb2:Body = createBall(50,100,100);
            Bb1.group = groupB;
            Bb2.group = groupB;


            var Bc1:Body = createBall(100,110,100);
            var Bc2:Body = createBall(100,100,100);
            Bc1.group = groupC;
            Bc2.group = groupC;
        }
//
        private function testDemoGroup():void
        {
            var g1:InteractionGroup = new InteractionGroup(false);
            var g2:InteractionGroup = new InteractionGroup(true);
            var g3:InteractionGroup = new InteractionGroup(false);

            var s1:Shape = new Circle(10,Vec2.weak(20,0));
            var s2:Shape = new Circle(20);
            var s3:Shape = new Circle(30);
            var s4:Shape = new Circle(40);

            var b1:Body = new Body(null, Vec2.get(100,100));
            var b2:Body = new Body(null, Vec2.get(100,100));
            var b3:Body = new Body(null, Vec2.get(100,100));

            var c1:Compound = new Compound();
            var c2:Compound = new Compound();

            s1.body = b1;
            s2.body = b1;
            s3.body = b2;
            s4.body = b3;

            b1.group = g1;
            g2.group = g1;

            s2.group = g2;
            c1.group = g2;

            c2.group = g3;

            b2.compound = c1;
            c2.compound = c1;
            b3.compound = c2;

            b1.space = space;
            c1.space = space;
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
            var body:Body = createBorder();
            for(var i:int = 0;i< body.shapes.length;i++)
            {
                //和所有物体碰撞
                body.shapes.at(i).filter.collisionGroup = -1;
            }
        }

    }
}
