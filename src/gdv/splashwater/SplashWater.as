/**
 * User: Tomyail
 * Date: 13-5-16
 * Time: 下午11:33
 */
package gdv.splashwater
{
    import nape.Template;
    import nape.constraint.WeldJoint;
    import nape.phys.Body;

    public class SplashWater extends Template
    {
        public function SplashWater()
        {
            super({});
        }

        override protected function init():void
        {
            super.init();

            var body1:Body = new Body();
            var body2:Body = new Body();
//            var joint:WeldJoint = new WeldJoint(body1,body2,)
        }
    }
}
