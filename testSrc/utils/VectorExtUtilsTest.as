/**
 * User: lixuexin
 * Date: 13-5-22
 * Time: 下午4:33
 */
package utils
{
    import flash.display.Sprite;

    import org.flexunit.asserts.assertEquals;

    import org.flexunit.asserts.assertFalse;

    import org.flexunit.asserts.assertTrue;

    public class VectorExtUtilsTest
    {
        public function VectorExtUtilsTest()
        {
        }

        [Test]
        public function testIsVector():void
        {
            assertTrue(VectorExtUtils.isVector(Vector.<Sprite>));
            var obj:Vector.<Sprite> = new <Sprite>[];
            assertTrue(VectorExtUtils.isVector(obj));
            assertFalse(VectorExtUtils.isVector(Object));
            assertFalse(VectorExtUtils.isVector({}));
        }

        [Test]
        public function testGetVectorContentType():void
        {
            assertEquals(VectorExtUtils.getVectorContentType(Vector.<Sprite>),Sprite);
            assertEquals(VectorExtUtils.getVectorContentType(Vector.<Vector.<Sprite>>),Vector.<Sprite>);
        }
    }
}
