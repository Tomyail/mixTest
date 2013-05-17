/**
 * User: lixuexin
 * Date: 13-5-3
 * Time: 下午4:00
 */
package nape
{
    import flash.display.Shape;
    import flash.display.Sprite;

    import nape.geom.AABB;
    import nape.geom.GeomPoly;
    import nape.geom.GeomPolyList;
    import nape.geom.IsoFunction;
    import nape.geom.MarchingSquares;
    import nape.geom.Vec2;
    import nape.phys.Body;
    import nape.shape.Polygon;

    [SWF(width="400",height="300")]
    public class SimpleMarchSequence extends Template implements IsoFunction
    {
        public function SimpleMarchSequence()
        {
            super({});
        }

        private var _shape:Sprite;
        private var _debug:Shape;

        override protected function init():void
        {
            _shape = new Sprite();
            _shape.graphics.beginFill(0);
            _shape.graphics.moveTo(0,0);
            _shape.graphics.lineTo(0,300);
            _shape.graphics.lineTo(400,300);
            _shape.graphics.lineTo(0,0);
            addChild(_shape);
            _shape.alpha = .1
            _debug = new Shape();
            addChild(_debug);

            var list:GeomPolyList = MarchingSquares.run(this,new AABB(0,0,_shape.width,_shape.height),Vec2.get(100,100),1/*,Vec2.get(_shape.width>>1,_shape.height)*/);
            var body:Body = new Body();
            body.space = space;
            trace(list.length,list);
            for(var i:int = 0;i<list.length;i++)
            {
                var p:GeomPoly = list.at(i);
                trace(p.isConvex(), p.isSimple(), p.isMonotone())
//                body.shapes.add(new Polygon(p));
                var pl:GeomPolyList = p.monotoneDecomposition()
                trace("pl",pl)
                for(var j:int = 0;j<pl.length;j++)
                {
                    var g:GeomPoly = pl.at(j);
                    body.shapes.add(new Polygon(g));
                    g.dispose();
                }
                p.dispose();
                pl.clear();
            }
            list.clear();

            drawDebug(_debug,100);
        }

        private function drawDebug(shape:Shape,size:int):void
        {
            shape.graphics.clear();
            shape.graphics.lineStyle(1,0,0.1)
            var w:int = Math.ceil(stage.stageWidth/size);
            var h:int = Math.ceil(stage.stageHeight/size);
            for(var i:int = 0;i<h;i++)
            {
                for(var j:int = 0;j<w;j++)
                {
                    shape.graphics.drawRect(j*size,i*size,size,size);
                }
            }
        }

        public function iso(x:Number, y:Number):Number
        {
            trace(x,y,_shape.hitTestPoint(x, y, true))
            return (_shape.hitTestPoint(x, y, true) ? -1.0 : 1.0);;
        }
    }
}
