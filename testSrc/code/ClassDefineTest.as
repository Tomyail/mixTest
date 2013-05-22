/**
 * User: Tomyail
 * Date: 13-5-15
 * Time: 下午10:24
 */
package code
{
    import code.ClassDefine;

    import flash.display.Sprite;

    public class ClassDefineTest
    {
        public function ClassDefineTest()
        {
        }

        [Test]
        public function testConverObj():void
        {
            var clz:ClassDefine = ClassDefine.converObj(new Sprite());
//            clz.debug();
        }
    }
}
