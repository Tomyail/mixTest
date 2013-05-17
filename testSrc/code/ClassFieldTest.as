/**
 * User: Tomyail
 * Date: 13-5-14
 * Time: 上午12:16
 */
package code
{
    import flash.display.Sprite;

    import org.as3commons.lang.StringUtils;
    import org.flexunit.asserts.assertTrue;

    public class ClassFieldTest
    {
        public function ClassFieldTest()
        {
        }


        [Test]
        public function simpleTest():void
        {
            var field:ClassField = new ClassField("Test");
            field.addProperty("name3",Sprite);
            field.addProperty("name1",String,"0");
            field.addProperty("name2",int,0);
            field.addProperty("name4",Boolean,false);
            field.addProperty("name5",uint,0xffffffff);


            var lines:Vector.<Line> = field.exportToLines();
            assertTrue(lineContainsValue(lines,"public var name1:String = '0';"));

            assertTrue(lineContainsValue(lines,"import flash.display.Sprite;"));
            assertTrue(lineContainsValue(lines,"public var name3:Sprite;"));
            //TODO not pass 0xfffffff will convert to a big number
            assertTrue(lineContainsValue(lines,"public var name5:uint = 4294967295;"));
            //todo
            assertTrue(lineContainsValue(lines,"public var name4:Boolean = false;"));

        }

        private function lineContainsValue(lines:Vector.<Line>,value:String):Boolean
        {
            value = value.replace(/ +/g,"");
            for(var i:int = 0;i<lines.length;i++)
            {
                if(StringUtils.contains(lines[i].value.replace(/ +/g,""), value))
                    return true;
            }
            return false;
        }
    }
}
