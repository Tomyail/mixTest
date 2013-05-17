/**
 * User: Tomyail
 * Date: 13-5-13
 * Time: 下午11:23
 */
package utils
{
    import flash.display.Sprite;

    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class ClassUtilsTest
    {
        public function ClassUtilsTest()
        {
        }

        [Test]
        public function testClassIsTopClz():void
        {
            assertTrue(ClassExtUtils.isTopClass(String));
            assertTrue(ClassExtUtils.isTopClass(Math));
            assertFalse(ClassExtUtils.isTopClass(Sprite));
        }

        [Test]
        public function testInstanceIsTopClz():void
        {
            assertTrue(ClassExtUtils.isTopClass("1"));
            assertTrue(ClassExtUtils.isTopClass(2));
            assertFalse(ClassExtUtils.isTopClass(new Sprite()));
        }

        [Test]
        public function testIsPrimitiveClass():void
        {
            assertTrue(ClassExtUtils.isPrimitiveClass(0xffffff)); //int ??
            assertTrue(ClassExtUtils.isPrimitiveClass(-1));
            assertTrue(ClassExtUtils.isPrimitiveClass(1.1));
            assertTrue(ClassExtUtils.isPrimitiveClass("1"));
            assertTrue(ClassExtUtils.isPrimitiveClass(true));

            assertFalse(ClassExtUtils.isPrimitiveClass(Object));

        }
    }

}
