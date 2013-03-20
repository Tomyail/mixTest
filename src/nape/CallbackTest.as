/**
 * Created with IntelliJ IDEA.
 * User: Tomyail
 * Date: 13-3-17
 * Time: 下午10:45
 * To change this template use File | Settings | File Templates.
 */
package nape
{
    import com.bit101.components.PushButton;

    import flash.events.MouseEvent;

    import nape.callbacks.BodyCallback;
    import nape.callbacks.BodyListener;
    import nape.callbacks.CbEvent;
    import nape.callbacks.CbType;
    import nape.callbacks.InteractionCallback;
    import nape.callbacks.InteractionListener;
    import nape.callbacks.InteractionType;
    import nape.callbacks.InteractionType;
    import nape.callbacks.Listener;
    import nape.callbacks.PreCallback;
    import nape.callbacks.PreFlag;
    import nape.callbacks.PreListener;
    import nape.geom.Vec2;
    import nape.phys.Body;
    import nape.phys.Material;

    public class CallbackTest extends Template
    {
        public function CallbackTest()
        {
            super({gravity:Vec2.weak(0,10)});
        }

        override protected function init():void
        {
            createBorder();
//            testBodyCb();
//            testCollisionCb();
            testPreListenCb();
        }

        private function testPreListenCb():void
        {
            var type:CbType = new CbType();

            var circle1:Body = createBall(50,50,0);
            var circle2:Body = createBall(60,50,300);

//            circle1.shapes.at(0).sensorEnabled = true;
//            circle2.shapes.at(0).sensorEnabled = true;

            circle1.cbTypes.add(type);
            circle2.cbTypes.add(type);

            trace(circle1.arbiters)
            space.listeners.add(new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,type,type,handler));
            space.listeners.add(new InteractionListener(CbEvent.ONGOING,InteractionType.COLLISION,type,type,handler));
            space.listeners.add(new InteractionListener(CbEvent.END,InteractionType.COLLISION,type,type,handler));

            space.listeners.add(new PreListener(InteractionType.COLLISION,type,type,preHandler,0,false))

            function handler(cb:InteractionCallback):void
            {
                trace(isAccept,cb.toString());
            }

            function preHandler(cb:PreCallback):PreFlag {
                trace(cb.toString());
                if(isAccept)
                {
                    return PreFlag.ACCEPT_ONCE;
                }
                else
                {
                    return PreFlag.IGNORE_ONCE;
                }

            }
            new PushButton(this, 0,0,"",callback);

            var isAccept:Boolean = false;
            function callback(e:MouseEvent):void
            {
                isAccept = !isAccept;
            }
        }

        /**简单的刚体状态回调*/
        private function testBodyCb():void
        {
            //创建一个特定的事件类型,可以理解为标签
            var circleType:CbType = new CbType();

            var circle:Body = createBall(50, 100, 100);
            //为这个刚体打上这个"标签"
            circle.cbTypes.add(circleType);

            //新增一个全局监听
            var circleListener:Listener = new BodyListener(CbEvent.SLEEP, circle.cbTypes, circleHandler);

            //注册这个全局监听
            space.listeners.add(circleListener);

            function circleHandler(cb:BodyCallback):void
            {
                trace("circle sleep");
            }
        }

        private function testCollisionCb():void
        {
            var circleType:CbType = new CbType();

            var circle:Body = createBall(50, 100, 100, new Material(1));
            circle.shapes.at(0).filter.collisionMask = ~1;
            circle.cbTypes.add(circleType);

            //谁和谁在何时何事干嘛了
            //比如 A和B在 开始 碰撞时 hello了
            space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, circle.cbTypes, CbType.ANY_BODY, circleHandler));
            space.listeners.add(new InteractionListener(CbEvent.ONGOING, InteractionType.COLLISION, circle.cbTypes, CbType.ANY_BODY, circleHandler));
            space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.COLLISION, circle.cbTypes, CbType.ANY_BODY, circleHandler));


            function circleHandler(cb:InteractionCallback):void
            {
                trace(cb.int1.toString())
            }
        }

        private function testSensor():void
        {

        }

        private function testPreCb():void
        {

        }

    }
}
