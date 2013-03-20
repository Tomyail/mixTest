/**
 * Created with IntelliJ IDEA.
 * User: lixuexin
 * Date: 13-3-20
 * Time: 下午1:28
 * To change this template use File | Settings | File Templates.
 */
package nape
{
    import com.nodename.Delaunay.Voronoi;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    import nape.callbacks.CbEvent;
    import nape.callbacks.CbType;
    import nape.callbacks.InteractionCallback;
    import nape.callbacks.InteractionListener;
    import nape.callbacks.InteractionType;
    import nape.callbacks.PreCallback;
    import nape.callbacks.PreFlag;
    import nape.callbacks.PreListener;
    import nape.geom.AABB;
    import nape.geom.Vec2;
    import nape.phys.Body;
    import nape.phys.BodyType;
    import nape.phys.Material;
    import nape.shape.Polygon;

    public class BodiesImpact extends Template
    {
        public function BodiesImpact()
        {

            super({});
        }

        [Embed(source="../media/texture.jpg")]
        private var Texture:Class;

        private var CLICK:int = 0;
        private var psycho_box:Body;
        private var psycho_box2:Body;
        private var cb1:CbType;
        private var cb2:CbType;
        override protected function init():void
        {
            this.cb1 = new CbType();
            this.cb2 = new CbType();
            var _local2:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, this.cb1, this.cb2, this.floorHit);
            this.space.listeners.add(_local2);
            var _local3:PreListener = new PreListener(InteractionType.COLLISION, this.cb1, this.cb2, this.preImpact);
            this.space.listeners.add(_local3);
            var _local4:BitmapData = new BitmapData(500, 380, false, 0x222222);
            var _local5:TextField = new TextField();
            _local5.defaultTextFormat = new TextFormat("arial", "24", 0xFFFFFF);
            _local5.text = "随便点";
            _local5.autoSize = TextFieldAutoSize.LEFT;
            _local4.draw(_local5, new Matrix(1, 0, 0, 1, 0xFF, 200));
            addChild(new Bitmap(_local4));
            this.creatDestoables();
            stage.addEventListener(MouseEvent.CLICK, this.go);
//            addEventListener(Event.ENTER_FRAME, this.tick);
        }


        override protected function postUpdate(deltaTime:Number):void
        {
            for (var i:int = 0; i < space.bodies.length; i++) {
                var b:Body = space.bodies.at(i);
                var graphic:DisplayObject = b.userData.graphic;
                if(graphic)
                {
                    graphic.x = b.position.x;
                    graphic.y = b.position.y;
                    graphic.rotation = (b.rotation * 180/Math.PI) % 360;
                }
            }
        }

        private function preImpact(_arg1:PreCallback):PreFlag{
            var _local2:Body = (_arg1.int2 as Body);
            var _local3:Body = (_arg1.int1 as Body);
            _local2.userData.velocity = _local2.velocity.copy();
            _local2.userData.angularVel = _local2.angularVel;
            _local3.userData.velocity = _local3.velocity.copy();
            _local3.userData.angularVel = _local3.angularVel;
            return (PreFlag.ACCEPT);
        }


        private function go(_arg1:Event=null):void{
            var _local2:Body;
            switch (this.CLICK){
                case 0:
                    this.space.gravity = new Vec2(0, 50);
                    this.psycho_box.applyImpulse(new Vec2(1500, 0),Vec2.weak(-50 + (Math.random() * 100)));
                    this.psycho_box2.applyImpulse(new Vec2(-2000, 0),Vec2.weak(-50 + (Math.random() * 100)));
                    this.CLICK++;
                    return;
                case 1:
                    while (this.space.bodies.length > 0) {
                        _local2 = this.space.bodies.at(0);
                        if (_local2.userData.graphic != null){
                            removeChild(_local2.userData.graphic);
                        };
                        _local2.space = null;
                    };
                    this.creatDestoables();
                    this.CLICK--;
                    return;
            };
        }
        private function creatDestoables():void{
            this.space.gravity = new Vec2(0, 0);
            createBorder();
            this.psycho_box = new Body(BodyType.DYNAMIC, new Vec2(10, (50 + (Math.random() * 50))));
            this.psycho_box.shapes.add(new Polygon(Polygon.rect(0, 0, 100, 100), Material.sand()));
            this.psycho_box.align();
            this.psycho_box.cbTypes.add(cb1);
            this.psycho_box.userData.graphic = this.cutSpriteFromBMD(new Texture(), this.psycho_box);
            addChild(this.psycho_box.userData.graphic);
            this.psycho_box.space = this.space;
            this.psycho_box2 = new Body(BodyType.DYNAMIC, new Vec2(400, (50 + (Math.random() * 50))));
            this.psycho_box2.shapes.add(new Polygon(Polygon.rect(0, 0, 100, 100), Material.ice()));
            this.psycho_box2.align();
            this.psycho_box2.cbTypes.add(cb2);
            this.psycho_box2.rotation = (Math.random() * Math.PI);
            this.psycho_box.rotation = (Math.random() * Math.PI);
            this.psycho_box2.userData.graphic = this.cutSpriteFromBMD(new Texture(), this.psycho_box);
            addChild(this.psycho_box2.userData.graphic);
            this.psycho_box2.space = this.space;
        }

        private function cutSpriteFromBMD(param1:Bitmap, _arg2:Body, _arg3:Vec2=null, _arg4:Number=0):Sprite{
            var _arg1 = param1.bitmapData;
            var _local9:Polygon;
            var _local10:Vec2;
            var _local11:int;
            var _local12:Vec2;
            var _local5:Sprite = new Sprite();
            var _local6:Matrix = new Matrix();
            var _local7:Number = (((Math.abs(Math.sin(_arg4)) > Math.abs(Math.cos(_arg4)))) ? Math.abs(Math.sin(_arg4)) : Math.abs(Math.cos(_arg4)));
            _local6.tx = (-(_arg1.width) * 0.5);
            _local6.ty = (-(_arg1.height) * 0.5);
            _local6.ty = (_local6.tx = (-((100 / _local7)) * 0.5));
            _local6.rotate(_arg4);
            if (_arg3 != null){
                _local6.tx = (_local6.tx + _arg3.x);
                _local6.ty = (_local6.ty + _arg3.y);
            };
            _local5.graphics.beginBitmapFill(_arg1, _local6, true, true);
            var _local8:int = 0;
            while (_local8 < _arg2.shapes.length) {
                _local9 = (_arg2.shapes.at(_local8) as Polygon);
                _local10 = _local9.localVerts.at(0);
                _local5.graphics.moveTo(_local10.x, _local10.y);
                _local11 = 1;
                while (_local11 < _local9.localVerts.length) {
                    _local12 = _local9.localVerts.at(_local11);
                    _local5.graphics.lineTo(_local12.x, _local12.y);
                    _local11++;
                };
                _local5.graphics.lineTo(_local10.x, _local10.y);
                _local8++;
            };
            _local5.graphics.endFill();
            return (_local5);
        }

        private function floorHit(_arg1:InteractionCallback):void{
            var _local4:Body;
            var _local2:Body = (_arg1.int2 as Body);
            var _local3:Body = (_arg1.int1 as Body);
            for each (_local4 in [_local2, _local3]) {
                this.collide(_local4);
            };
        }

        private var voronoiTempBody:Body;
        private function collide(_arg1:Body):void{
            var _local7:Polygon;
            var _local8:Vec2;
            var _local2:Vec2 = _arg1.worldCOM.copy();
            var _local3:Number = _arg1.rotation;
            var _local4:Vec2 = _arg1.userData.velocity;
            var _local5:Number = _arg1.userData.angularVel;
            var _local6:Vector.<Polygon> = this.VoronoiDesctruction((_arg1.shapes.at(0) as Polygon));
            removeChild(_arg1.userData.graphic);
            _arg1.space = null;
            for each (_local7 in _local6) {
                _local7.rotate(_local3);
                this.voronoiTempBody = new Body(BodyType.DYNAMIC, _local2);
                this.voronoiTempBody.shapes.add(_local7);
                this.voronoiTempBody.align();
                this.voronoiTempBody.velocity = _local4;
                _local8 = new Vec2((-(_local2.y) + this.voronoiTempBody.worldCOM.y), (_local2.x - this.voronoiTempBody.worldCOM.x));
                _local8.length = (-(_local5) * _local8.length);
                this.voronoiTempBody.velocity.x = (this.voronoiTempBody.velocity.x + _local8.x);
                this.voronoiTempBody.velocity.y = (this.voronoiTempBody.velocity.y + _local8.y);
                this.voronoiTempBody.userData.graphic = this.cutSpriteFromBMD(new Texture(), this.voronoiTempBody, _local2.copy().subeq(this.voronoiTempBody.worldCOM), _local3);
                addChild(this.voronoiTempBody.userData.graphic);
                this.voronoiTempBody.space = this.space;
            };
        }

        private function VoronoiDesctruction(shape:Polygon):Vector.<Polygon>{
            var w:Number;
            var h:Number;
            var vp:Vector.<Point>;
            var nape_verts:Vector.<Vec2>;
            var p:Point;
            var aabb:AABB = shape.bounds;
            w = aabb.width;
            h = aabb.height;
            var _local3:int = 100;
            h = _local3;
            w = _local3;
            var material:Material = shape.material;
            var result:Vector.<Polygon> = new <Polygon>[];
            var randPoint:Function = function ():Point{
                return (new Point(((-(w) / 2) + (Math.random() * w)), ((-(h) / 2) + (Math.random() * h))));
            };
            var verts:Vector.<Point> = new <Point>[];
            var i:int;
            while (i < (100 + (Math.random() * 100))) {
                verts.push(randPoint());
                i = (i + 1);
            };
            var voronoi:Voronoi = new Voronoi(verts, null, new Rectangle((-(w) / 2), (-(h) / 2), w, h));
            var vvp:Vector.<Vector.<Point>> = voronoi.regions();
            for each (vp in vvp) {
                nape_verts = new <Vec2>[];
                for each (p in vp) {
                    nape_verts.push(new Vec2(p.x, p.y));
                };
                result.push(new Polygon(nape_verts, material));
            };
            return (result);
        }

    }
}
