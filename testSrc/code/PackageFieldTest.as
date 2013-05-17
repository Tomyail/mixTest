/**
 * User: lixuexin
 * Date: 13-5-14
 * Time: 上午9:35
 */
package code
{
    import flash.display.Sprite;

    import org.as3commons.lang.StringUtils;
    import org.flexunit.asserts.assertTrue;

    public class PackageFieldTest
    {
        public function PackageFieldTest()
        {
        }

        [Test]
        public function testExportLines():void
        {

            var classField:ClassField = new ClassField("Test");
            classField.addProperty("name3",Sprite);
            classField.addProperty("name1",String,"0");
            classField.addProperty("name2",int,0);
            classField.addProperty("name4",Boolean,false);

            var packageField:PackageField = new PackageField("lix2.test")
            packageField.addClassField(classField);

            var lines:Vector.<Line> = packageField.exportLines();

            assertTrue(lineContainsValue(lines,"package lix2.test"));
//            for(var i:int = 0;i<lines.length;i++)
//            {
//                trace(lines[i].print());
//            }

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
