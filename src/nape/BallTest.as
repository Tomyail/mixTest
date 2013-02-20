/**
 * Created with IntelliJ IDEA.
 * User: lixuexin
 * Date: 13-2-19
 * Time: 上午9:20
 * To change this template use File | Settings | File Templates.
 */
package nape
{
    import nape.geom.Vec2;
    import nape.phys.Body;
    import nape.phys.BodyType;
    import nape.phys.Material;
    import nape.shape.Polygon;

    [SWF(backgroundColor="0x333333")]
    public class BallTest extends Template
    {
        public function BallTest()
        {
            super({gravity:Vec2.weak(0,10)});
        }

        override protected function init():void
        {
            //!!
            space.worldAngularDrag = 0;
            space.worldLinearDrag = 0;

            var circle:Body = new Body();
            circle.shapes.add(new Polygon(Polygon.box(100, 100), new Material(Number.POSITIVE_INFINITY)));

            space.bodies.add(circle);
            createBorder();
        }
    }
}
