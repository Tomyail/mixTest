/**
 * User: lixuexin
 * Date: 13-5-17
 * Time: 下午4:09
 */
package utils
{
    import flash.display.Sprite;

    import org.as3commons.lang.ObjectUtils;
    import org.as3commons.reflect.Type;
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertNotNull;

    import testHelper.TargetType2;

    public class ObjectExtUtilsTest
    {
        public function ObjectExtUtilsTest()
        {
        }

        [Test]
        public function testConvertTo():void
        {
            var data:Object = {a:1,b:"2",c:false,d:0xffffff,
                e:{a:1,b:"2",c:false},
                f:[1,2,3],
                g:[{a:1,b:"2",c:1},{a:2,b:"3",c:1}]
            };
            var a:Vector.<Sprite> = null;
            trace(a is Vector.<*>);
//            var type:org.as3commons.reflect.Type = org.as3commons.reflect.Type.forInstance(Vector.<Sprite>([new Sprite()]));
            var type2:TargetType2 = ObjectExtUtils.recursionInstanceTo(data,TargetType2);
            assertEquals(type2.a,1);
            assertEquals(type2.e.a,1);
            assertNotNull(type2.g);
            assertEquals(type2.g[0].a,1);
        }
    }
}
