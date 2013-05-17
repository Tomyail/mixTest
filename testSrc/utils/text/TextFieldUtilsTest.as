/**
 * User: Tomyail
 * Date: 13-5-12
 * Time: 上午1:26
 */
package utils.text
{
    import flash.text.TextField;
    import flash.text.TextFormat;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertTrue;

    public class TextFieldUtilsTest
    {
        public function TextFieldUtilsTest()
        {
        }

        [Test]
        public function testReplaceMultiFormat():void
        {
            var tf:TextField = new TextField();
            tf.text = "X[$][$][$]";
            var data:Vector.<TextUnit> = new <TextUnit>[
                new TextUnit("1",new TextFormat(null,null,0xff0000)),
                new TextUnit("2.",new TextFormat(null,null,0xff3300)),
                new TextUnit("2",new TextFormat(null,null,0xff3333))
                ];
            TextFieldUtils.replaceMultiFormat(tf,data);
            assertEquals(tf.getTextFormat(0,1).color,tf.defaultTextFormat.color);
            assertEquals(tf.getTextFormat(1,2).color,0xff0000);
            assertEquals(tf.getTextFormat(2,4).color,0xff3300);
            assertEquals(tf.getTextFormat(4,5).color,0xff3333);
            assertTrue(tf.text.charAt(1) == "1");
            assertTrue(tf.text.charAt(0) == "X");

        }

        [Test]
        public function testPushMultiFormat():void
        {
            var tf:TextField = new TextField();
            tf.text = "X"
            var data:Vector.<TextUnit> = new <TextUnit>[
                new TextUnit("1",new TextFormat(null,null,0xff0000)),
                new TextUnit("2.",new TextFormat(null,null,0xff3300)),
                new TextUnit("2",new TextFormat(null,null,0xff3333))
            ];
            TextFieldUtils.pushMultiFormat(tf,data);
            assertEquals(tf.getTextFormat(0,1).color,tf.defaultTextFormat.color);
            assertEquals(tf.getTextFormat(1,2).color,0xff0000);
            assertEquals(tf.getTextFormat(2,4).color,0xff3300);
            assertEquals(tf.getTextFormat(4,5).color,0xff3333);
            assertTrue(tf.text.charAt(1) == "1");
            assertTrue(tf.text.charAt(0) == "X");
        }
    }
}
