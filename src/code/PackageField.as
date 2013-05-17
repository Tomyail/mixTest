/**
 * User: Tomyail
 * Date: 13-5-13
 * Time: 下午10:09
 */
package code
{
    public class PackageField
    {
        public var name:String;
        private var lines:Vector.<Line>;
        public function PackageField(name:String)
        {
            this.name = name;
            lines = new <Line>[];
            lines.push(new Line("package " + name));
            lines.push(new Line("{"));

        }

        private var clzField:ClassField;
        public function addClassField(clzField:ClassField):void
        {
            this.clzField = clzField;
        }

        public function exportLines():Vector.<Line>
        {
            var clzFieldLines:Vector.<Line> = clzField.exportToLines();
            for(var i:int = 0;i< clzFieldLines.length;i++)
            {
                clzFieldLines[i].shiftSpace(4);
            }
            return lines.concat(clzFieldLines).concat(Vector.<Line>([new Line("}")]))
        }

    }
}
