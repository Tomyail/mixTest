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

    import nape.geom.Vec2;

    import nape.phys.Body;
    import nape.phys.BodyType;
    import nape.phys.Material;
    import nape.shape.Circle;
    import nape.shape.Polygon;
    import nape.shape.Shape;

    public class CenterMass extends Template
    {
        public function CenterMass()
        {
            super({
                gravity:Vec2.weak(0,10),
                showInfo:false
            });
        }

        private var circle:Body;
        private var shape:Shape;
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
            debug.drawBodies = true;
            //绘制重心 空心方块
            debug.drawShapeDetail = true;
            //绘制坐标系原点 实心方形
            debug.drawBodyDetail = true;

            circle = new Body(BodyType.KINEMATIC);
//            circle.shapes.add(new Circle(20,Vec2.get(10,10)));
//            circle.shapes.add(new Polygon(Polygon.box(100, 100), new Material()));
//            var shape:Polygon = new Polygon(Polygon.box(100, 100), new Material());
            shape = new Polygon(Polygon.rect(0,0,100, 100), new Material());
//            var shape:Polygon = new Polygon(Polygon.regular(90,90,3), new Material());
//            var shape:Circle = new Circle(50);

            circle.shapes.add(shape);
//            shape.localCOM.set(Vec2.weak(50,0));
//            circle.velocity.setxy(10,0);
//            circle.force
            //circle.align();
            circle.position.y = 100;
            circle.position.x = 100;
//            trace(circle.localPointToWorld(Vec2.weak(-30,30)));

            space.bodies.add(circle);
            createBorder();

            space.step(1/60);
            trace(shape.localCOM);
            trace(circle.position);
            shape.localCOM.x = 10;
            shape.localCOM.y = 10;
        }

        override protected function preStep(deltaTime:Number):void
        {
//            trace("POS"+circle.position);
//            trace(shape.localCOM);
//            trace(circle.position);
        }
    }
}
