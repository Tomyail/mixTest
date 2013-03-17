/**
 * Created with IntelliJ IDEA.
 * User: Tomyail
 * Date: 13-3-17
 * Time: 下午10:45
 * To change this template use File | Settings | File Templates.
 */
package nape
{
import nape.callbacks.BodyCallback;
import nape.callbacks.BodyListener;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.Listener;
import nape.phys.Body;

public class CallbackTest extends Template
{
    public function CallbackTest()
    {
        super({});
    }

    override protected function init():void
    {
        createBorder();
        testBodyCb();
    }

    private function testBodyCb():void
    {
        var circleType:CbType = new CbType();
        var circle:Body = createBall(50,100,100);
        circle.cbTypes.add(circleType);

        var circleListener:Listener = new BodyListener(CbEvent.SLEEP,circleType,circleHandler);

        space.listeners.add(circleListener);

        function circleHandler(cb:BodyCallback):void
        {
            trace("circle sleep")
        }
    }

    private function clearAll():void
    {
        space.listeners.
    }
}
}
