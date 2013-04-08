/**
 * User: lixuexin
 * Date: 13-4-2
 * Time: 上午10:54
 */
package nape
{
    import nape.geom.Vec2;
    import nape.phys.Body;
    import nape.phys.BodyType;
    import nape.shape.Polygon;

    public class GeometricTest extends Template
    {
        public function GeometricTest()
        {
            super({gravity: Vec2.weak(0, 0)});
        }


        override protected function init():void
        {
            createBorder();

            var body:Body = new Body(null, Vec2.weak(100,100));
            var obj:Object = (Polygon.regular(100,50,6,0))
            var s:Polygon = new Polygon(obj);
            body.shapes.add(s);
            body.space = space;
        }
    }
}
