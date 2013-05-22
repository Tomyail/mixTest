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
                g:[{a:1,b:"2"},{a:1,b:"2"}]
            };
            var a:Vector.<Sprite> = null;
            trace(a is Vector.<*>);
//            var type:org.as3commons.reflect.Type = org.as3commons.reflect.Type.forInstance(Vector.<Sprite>([new Sprite()]));
            var type2:TargetType2 = ObjectExtUtils.recursionInstanceTo(data,TargetType2);
        }
    }
}
