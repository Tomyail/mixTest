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

        private var body:Body;
        private var shape:Shape;
        override protected function init():void
        {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            createBorder();

//            debug.drawCollisionArbiters = true;
//            debug.drawConstraints = true;
//            debug.drawFluidArbiters = true;
//            debug.drawSensorArbiters = true;
            debug.drawShapeAngleIndicators = true;

            debug.drawBodies = true;
            //绘制重心 空心方块
            debug.drawShapeDetail = true;
            //绘制坐标系原点 实心方形
            debug.drawBodyDetail = true;

            body = new Body(BodyType.KINEMATIC);
//            body = new Body();
//            shape = new Polygon(Polygon.box(100, 100));
//            shape = new Polygon(Polygon.rect(0,0,100, 100));
            shape = new Circle(50);

            body.shapes.add(shape);
            body.position.y = 100;
            body.position.x = 100;

            space.bodies.add(body);

            //强制刷新
            space.step(1/60);
            trace(shape.localCOM);
            trace(body.position);
//            shape.localCOM.x = 10;
//            shape.localCOM.y = 10;
            shape.translate(Vec2.weak(10,10));
        }
    }
}
