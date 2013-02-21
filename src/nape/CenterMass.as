/**
 * Created with IntelliJ IDEA.
 * User: lixuexin
 * Date: 13-2-20
 * Time: 上午10:11
 * To change this template use File | Settings | File Templates.
 */
package nape
{
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;

    import nape.phys.Body;
    import nape.shape.Circle;

    public class CenterMass extends BallTest
    {
        public function CenterMass()
        {
            super();

        }

        private var circle:Body;
        override protected function init():void
        {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
//            debug.drawCollisionArbiters = true;
//            debug.drawConstraints = true;
//            debug.drawFluidArbiters = true;
//            debug.drawSensorArbiters = true;
            debug.drawShapeAngleIndicators = true;

//            space.worldAngularDrag = 0;
//            space.worldLinearDrag = 0;
            //坐标原点是实心方形
            debug.drawBodies = true;
            //绘制重心
            //debug.drawShapeDetail = true;
            //绘制坐标系原点
            //debug.drawBodyDetail = true;

            circle = new Body();
//            circle.shapes.add(new Circle(20,Vec2.get(10,10)));
//            circle.shapes.add(new Polygon(Polygon.box(100, 100), new Material()));
//            var shape:Polygon = new Polygon(Polygon.box(100, 100), new Material());
//            var shape:Polygon = new Polygon(Polygon.rect(0,0,100, 100), new Material());
//            var shape:Polygon = new Polygon(Polygon.regular(60,60,14), new Material());
            var shape:Circle = new Circle(50);

            circle.shapes.add(shape);
            trace(shape.localCOM);
//            shape.localCOM.set(Vec2.weak(50,0));
//            circle.velocity.setxy(10,0);
//            circle.force
            trace(circle.position)
            //circle.align();
            trace(circle.position)
            trace(shape.localCOM);
//            circle.position.y = 0;
//            circle.position.x = 100;
//            trace(circle.localPointToWorld(Vec2.weak(-30,30)));

            space.bodies.add(circle);
            createBorder();
        }

        override protected function preStep(deltaTime:Number):void
        {
            trace("POS"+circle.position);
        }
    }
}
