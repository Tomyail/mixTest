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

        private var box:Body;

        override protected function init():void
        {
            space.worldAngularDrag = 0;
            space.worldLinearDrag = 0;
            createBorder();
            var group:InteractionGroup = new InteractionGroup(false);
            var ball:Body = createBall(10,5,5,new Material(Number.POSITIVE_INFINITY));
            ball.group = group;
            box = createBox(100,10,BodyType.KINEMATIC,50,200);
            box.group = group;
//            box.shapes.at(0).filter.collisionMask = 1;
//            box.shapes.at(0).filter

            trace((1<<5) )
            var pushBtn:PushButton = new PushButton(this, 200,0,"test",callback)
        }

        private function callback(e:MouseEvent):void
        {
            box.shapes.at(0).filter.collisionMask = ~box.shapes.at(0).filter.collisionMask;
        }
    }
}
