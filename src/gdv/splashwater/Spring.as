/**
 * User: lixuexin
 * Date: 13-5-17
 * Time: 上午9:01
 */
package gdv.splashwater
{
    import flash.display.Sprite;

    import nape.Template;
    import nape.constraint.DistanceJoint;
    import nape.constraint.PivotJoint;
    import nape.constraint.WeldJoint;
    import nape.geom.Vec2;
    import nape.phys.Body;
    import nape.phys.Material;

    public class Spring extends Template
    {
        public var display:Sprite;

        public function Spring()
        {
            super({gravity: Vec2.weak(0, 600),generator:downHandler});
        }

        private function downHandler(vec:Vec2):void
        {
//            trace("down",ball.force);
//            ball.force.y +=500;
            ball.applyImpulse(Vec2.weak(0,100));
        }

        private var ball:Body;
        override protected function init():void
        {
            var joint:DistanceJoint = new DistanceJoint(null, null, Vec2.weak(), Vec2.weak(),10,30);

            ball = createBall(10, 150, 150);
            joint.frequency = 1;
            joint.damping = 0.1;
            joint.stiff = false;
            joint.body1 = ball;
            joint.body2 = space.world;
            joint.anchor1 = Vec2.weak(0, 0);
            joint.anchor2 = space.world.worldPointToLocal(Vec2.weak(150, 50));

            joint.space = space;


        }
    }
}
