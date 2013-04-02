/**
 * Created with IntelliJ IDEA.
 * User: Tomyail
 * Date: 13-3-17
 * Time: 下午10:45
 * To change this template use File | Settings | File Templates.
 */
package nape
{
    import com.bit101.components.CheckBox;
    import com.bit101.components.ComboBox;
    import com.bit101.components.PushButton;
    import com.bit101.components.TextArea;
    import com.bit101.components.Window;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import nape.callbacks.BodyCallback;
    import nape.callbacks.BodyListener;
    import nape.callbacks.CbEvent;
    import nape.callbacks.CbType;
    import nape.callbacks.InteractionCallback;
    import nape.callbacks.InteractionListener;
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
            super({gravity: Vec2.weak(0, 600)});


        }

        private var targetHandler:Function;

        override protected function init():void
        {
            if (!rootUI)
            {
                rootUI = new Window(this, 200);
                createController(rootUI);
            }
            if (!tempContainer)
            {
                tempContainer = new Sprite();
                addChild(tempContainer);
                tempContainer.x = 300;
            }
            if (!targetHandler)
                targetHandler = testBodyCb;

            cleanTempUI();

            createBorder();

            targetHandler();
//            testBodyCb();
//            testCollisionCb();
//            testPreListenCb();
        }

        private function createController(rootUI:Window):void
        {
            new PushButton(rootUI, 0, 0, "testBodyCb",
                    function ():void
                    {
                        targetHandler = testBodyCb;
                        reset();
                    }
            )
            new PushButton(rootUI, 0, 20, "testCollisionCb",
                    function ():void
                    {
                        targetHandler = testCollisionCb;
                        reset();
                    }
            )
            new PushButton(rootUI, 0, 40, "testPreListenCb",
                    function ():void
                    {
                        targetHandler = testPreListenCb;
                        reset();
                    }
            )
            logArea = new TextArea(rootUI, 0, 60);
            logArea.width = rootUI.width;
            rootUI.height = 200;
            logArea.editable = false;

            new PushButton(rootUI, 0, 160, "clearLog",
                    function ():void
                    {
                        logArea.text = "";
                    }
            )
        }

        private var logArea:TextArea;

        private function log(str:Object):void
        {
            logArea.text += str.toString() + "\n";
            trace(str);
        }

        private function cleanTempUI():void
        {
            while (tempContainer.numChildren)
            {
                tempContainer.removeChildAt(0);
            }
        }

        private var tempContainer:Sprite;
        private var rootUI:Window;

        private function testPreListenCb():void
        {
            log("testPreListenCb")
            var type:CbType = new CbType();

            var circle1:Body = createBall(50, 50, 0);
            var circle2:Body = createBall(60, 50, 300);


            circle1.cbTypes.add(type);
            circle2.cbTypes.add(type);

            space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, type, type, interactionHandler));
            //如果嫌刷屏烦躁可以关闭此行代码
            space.listeners.add(new InteractionListener(CbEvent.ONGOING, InteractionType.COLLISION, type, type, interactionHandler));
            space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.COLLISION, type, type, interactionHandler));

            var preListener:PreListener = new PreListener(InteractionType.COLLISION, type, type, preHandler, 0, false);
            space.listeners.add(preListener);

            //pure设置为false可防止休眠
            var checkbox:CheckBox = new CheckBox(tempContainer, 0, 0, "pure",
                    function ():void
                    {
                        preListener.pure = checkbox.selected
                    }
            )

            //组合框用来选择不同的preflag
            var combox:ComboBox = new ComboBox(tempContainer, 0, 20, "ACCEPT_ONCE",
                    [
                        {label: "ACCEPT", data: PreFlag.ACCEPT},
                        {label: "IGNORE", data: PreFlag.IGNORE},
                        {label: "ACCEPT_ONCE", data: PreFlag.ACCEPT_ONCE},
                        {label: "IGNORE_ONCE", data: PreFlag.IGNORE_ONCE}
                    ]
            );
            combox.addEventListener(Event.SELECT, selectHandler);

            function interactionHandler(cb:InteractionCallback):void
            {
                log(cb.event);
            }

            var flag:PreFlag = PreFlag.ACCEPT_ONCE;

            function selectHandler(e:Event):void
            {
                flag = combox.selectedItem.data;
            }

            function preHandler(cb:PreCallback):PreFlag
            {
                return flag
            }

        }

        /**简单的刚体状态回调*/
        private function testBodyCb():void
        {
            log("testBodyCb")
            //创建一个特定的事件类型,可以理解为标签
            var circleType:CbType = new CbType();

            var circle:Body = createBall(50, 100, 100);
            //为这个刚体打上这个"标签"
            circle.cbTypes.add(circleType);

            //新增一个刚体休眠全局监听
            var sleepListener:Listener = new BodyListener(CbEvent.SLEEP, circle.cbTypes, circleHandler);
            //新增一个刚体激活全局监听
            var wakeListener:Listener = new BodyListener(CbEvent.WAKE, circle.cbTypes, circleHandler);


            //注册这些全局监听
            space.listeners.add(sleepListener);
            space.listeners.add(wakeListener);

            function circleHandler(cb:BodyCallback):void
            {
                log(cb.event);
            }
        }

        //刚体和四周的墙体(不可见)发生碰撞时触发
        private function testCollisionCb():void
        {

            log("testCollisionCb")
            var circleType:CbType = new CbType();

            var circle:Body = createBall(50, 100, 100, new Material(1));
            circle.shapes.at(0).filter.collisionMask = 1;
            circle.cbTypes.add(circleType);

            space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, circle.cbTypes, CbType.ANY_BODY, circleHandler));
            space.listeners.add(new InteractionListener(CbEvent.ONGOING, InteractionType.COLLISION, circle.cbTypes, CbType.ANY_BODY, circleHandler));
            space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.COLLISION, circle.cbTypes, CbType.ANY_BODY, circleHandler));


            function circleHandler(cb:InteractionCallback):void
            {
                log(cb.event)
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
