/**
 * User: Tomyail
 * Date: 13-5-16
 * Time: 下午11:33
 */
package gdv.splashwater
{
    import nape.Template;
    import nape.constraint.PivotJoint;
    import nape.constraint.WeldJoint;
    import nape.geom.Vec2;
    import nape.phys.Body;

    public class SplashWater extends Template
    {
        public function SplashWater()
        {
            super({generator:clickHandler,
                gravity:Vec2.weak(0,600)
            });
        }

        override protected function init():void
        {
            super.init();
            createWater();

        }

        private function clickHandler(vec:Vec2):void
        {
            var ball:Body = createBall(20,vec.x,vec.y);
        }



        private function createWater():void
        {
            for(var i:int = 0;i<100;i++)
            {
                var body2:Body = createBall(1,100+i*10,100);
                var joint:PivotJoint = new PivotJoint(body2,space.world,Vec2.weak(0,0),space.world.worldPointToLocal(Vec2.weak(100+i*10,100)));
                joint.stiff = false;
                joint.frequency = 30;
                joint.damping  = 0.01;
                joint.space = space;
            }

        }
    }
}
