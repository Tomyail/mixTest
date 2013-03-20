/**
 * Created with IntelliJ IDEA.
 * User: lixuexin
 * Date: 13-3-19
 * Time: 下午3:55
 * To change this template use File | Settings | File Templates.
 */
package nape
{
    import flash.utils.getTimer;

    import nape.callbacks.CbEvent;
    import nape.callbacks.CbType;
    import nape.callbacks.InteractionCallback;
    import nape.callbacks.InteractionListener;
    import nape.callbacks.InteractionType;
    import nape.dynamics.Arbiter;
    import nape.dynamics.CollisionArbiter;
    import nape.phys.Body;

    public class ArbitersTest extends Template
    {
        public function ArbitersTest()
        {
            super({});
        }

        private var _ball2:Body;

        override protected function init():void
        {
            space.worldAngularDrag = 6;
            space.worldLinearDrag = 6;

            var body:Body;
            for(var i:int = 0;i< 10;i++)
            {
//                body = createBall(20,Math.random()*stage.stageWidth,Math.random()*stage.stageHeight);
                body = createBall(20,100,100);
                body.shapes.at(0).sensorEnabled = true;
            }
            _ball2 = createBall(10, 200, 200);
            _ball2.shapes.at(0).sensorEnabled = true;

            var ball2Tag:CbType = new CbType();
            _ball2.cbTypes.add(ball2Tag);

            var listener:InteractionListener = new InteractionListener(CbEvent.BEGIN,InteractionType.SENSOR,_ball2.cbTypes,CbType.ANY_BODY,handler);

            this.space.listeners.add(listener);

            function handler(cb:InteractionCallback):void
            {
                trace(cb.arbiters.length,body.arbiters.length)
//                var arb:Arbiter = cb.arbiters.at(0)
//                if(arb)
//                {
//                    trace(arb.collisionArbiter,arb.fluidArbiter);
////                    trace(cb.int1,arb.body1)
//                }
            }
        }
    }
}
