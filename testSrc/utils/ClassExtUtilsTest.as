/**
 * User: lixuexin
 * Date: 13-5-22
 * Time: 下午4:38
 */
package utils
{
    import flash.display.Sprite;

    import org.as3commons.lang.ObjectUtils;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class ClassExtUtilsTest
    {
        public function ClassExtUtilsTest()
        {
        }

        [Test]
        public function testGetFullyQualifiedClassName():void
        {
            assertTrue("flash.display.Sprite",ObjectUtils.getFullyQualifiedClassName(Sprite,true));
            assertTrue("flash.display.Sprite",ObjectUtils.getFullyQualifiedClassName(new Sprite,true));
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

            assertTrue(ClassExtUtils.isPrimitiveClass(Number));
            assertFalse(ClassExtUtils.isPrimitiveClass(Object));

        }
    }
}
