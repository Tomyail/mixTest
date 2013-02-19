/**
 * Created with IntelliJ IDEA.
 * User: lixuexin
 * Date: 13-2-19
 * Time: 上午9:20
 * To change this template use File | Settings | File Templates.
 */
package nape
{
    import flash.display.Sprite;
    import flash.events.Event;

    import nape.geom.Vec2;
    import nape.phys.Body;
    import nape.phys.BodyType;
    import nape.phys.Material;
    import nape.shape.Polygon;
    import nape.space.Space;
    import nape.util.BitmapDebug;

    public class BallTest extends Sprite
    {
        private var space:Space;

        private var debug:BitmapDebug;
        public function BallTest()
        {
            super();
            debug = new BitmapDebug(stage.stageWidth,stage.stageHeight);
            addChild(debug.display)
            space = new Space(new Vec2(0,600));

            var circle:Body = new Body();
            circle.shapes.add(new Polygon(Polygon.box(100,100), new Material(Number.POSITIVE_INFINITY)));

            var border:Body = new Body(BodyType.STATIC,new Vec2(0,200));
            border.shapes.add(new Polygon(Polygon.rect(0,0,50,50)));
            space.bodies.add(border);
            space.bodies.add(circle)

            space.worldAngularDrag = 0;
            space.worldLinearDrag = 0;
            addEventListener(Event.ENTER_FRAME, update)
        }

        private function update(event:Event):void
        {
            space.step(1/stage.frameRate);
            debug.clear();
            debug.draw(space);
            debug.flush();
        }
    }
}
