/**
 * User: Tomyail
 * Date: 13-5-16
 * Time: 下午11:33
 */
package gdv.splashwater
{
    import nape.Template;
    import nape.callbacks.CbEvent;
    import nape.callbacks.CbType;
    import nape.callbacks.InteractionCallback;
    import nape.callbacks.InteractionListener;
    import nape.callbacks.InteractionType;
    import nape.constraint.PivotJoint;
    import nape.geom.Vec2;
    import nape.geom.Vec2;
    import nape.geom.Vec3;
    import nape.phys.Body;

    public class SplashWater extends Template
    {
        public function SplashWater()
        {
            super({generator: clickHandler,
                gravity     : Vec2.weak(0, 600)
            });
        }

        override protected function init():void
        {
            super.init();
            createWater();

        }

        private function clickHandler(vec:Vec2):void
        {
            var ball:Body = createBall(20, vec.x, vec.y);
            ball.shapes.at(0).sensorEnabled = true;
            var lis:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, CbType.ANY_BODY, ball.cbTypes, handler)
            lis.space = space;
        }

        private function handler(e:InteractionCallback):void
        {
            var body:Body = e.int1 as Body;
//            body.applyImpulse(Vec2.weak(0, 0.5));
            e.listener.space = null;

            body.velocity.addeq(Vec2.weak(0, 2000))

        }

        private var leftDelta:Vector.<Vec2>;
        private var rightDelta:Vector.<Vec2>;

        override protected function preStep(time:Number):void
        {

            for (var j:int = 0; j < 8; j++)
            {


                for (var i:int = 0; i < bodies.length; i++)
                {
                    if (i > 0)
                    {
                        sub(bodies[i].position,bodies[i - 1].position,leftDelta[i]).muleq(.4);
                        bodies[i - 1].velocity.addeq(leftDelta[i])
                    }
                    if (i < bodies.length - 1)
                    {
                        sub(bodies[i].position,bodies[i + 1].position,rightDelta[i]).muleq(.4);
                        bodies[i + 1].velocity.addeq(rightDelta[i])
                    }
                }


//                for (i = 0; i < bodies.length; i++)
//                {
//                    if (i > 0)
//                        bodies[i - 1].position.add(leftDelta[i]);
//                    if (i < bodies.length - 1)
//                        bodies[i + 1].position.add(rightDelta[i]);
//                }

            }


        }

        private function sub(v1:Vec2, v2:Vec2, target:Vec2 = null):Vec2
        {
            var t:Vec2;
            if (target)
                t = target;
            else
                t = Vec2.weak();
            return t.setxy(v1.x - v2.x, v1.y - v2.y)
        }


        private var bodies:Vector.<Body>;

        private function createWater():void
        {
            bodies = new <Body>[];

            for (var i:int = 0; i < 100; i++)
            {
                var body2:Body = createBall(1, 100 + i * 10, 100);
                body2.shapes.at(0).sensorEnabled = true;
                var joint:PivotJoint = new PivotJoint(body2, space.world, Vec2.weak(0, 0), space.world.worldPointToLocal(Vec2.weak(100 + i * 10, 100)));
                joint.stiff = false;
                joint.frequency = .8;
                joint.damping = 0.05;
                joint.space = space;

                bodies.push(body2);
            }
            rightDelta = new Vector.<Vec2>(bodies.length);
            leftDelta = new Vector.<Vec2>(bodies.length);
            for(var i:int =0;i<bodies.length;i++)
            {
                rightDelta[i] = Vec2.get();
                leftDelta[i] = Vec2.get();
            }

        }
    }
}
