/**
 * User: Tomyail
 * Date: 13-5-12
 * Time: 上午1:33
 */
package
{
    import flash.text.TextField;
    import flash.text.TextFormat;

    import org.as3commons.lang.ObjectUtils;
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.fail;

    public class TypeCloneTest
    {
        public function TypeCloneTest()
        {
        }

        [Test]
        public function testCloneObj():void
        {
            var tf:TextField = new TextField();

            assertFalse(tf.defaultTextFormat == tf.defaultTextFormat);
            var format:TextFormat = tf.defaultTextFormat;//new TextFormat("宋体",20,0xff3333);
            format.color = 0xff0000;

            for (var k:String in format)
            {
                fail("can't get k")
            }

            tf.defaultTextFormat = format;
            var tft:TextFormat = ObjectUtils.toInstance(format,TextFormat);

            assertEquals(0xff0000,tft.color,tf.defaultTextFormat.color);
            //error
//            assertEquals(0xff0000,ObjectUtils.toInstance(format,TextFormat).color,tf.defaultTextFormat.color);
        }
    }
}
