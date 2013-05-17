/**
 * User: Tomyail
 * Date: 13-5-13
 * Time: 下午10:10
 */
package code
{
    import flash.utils.Dictionary;

    import org.as3commons.lang.ClassUtils;

    import utils.ClassExtUtils;
    import utils.ObjectExtUtils;

    public class ClassField
    {
        private var lines:Vector.<Line>;
        private var name:String;

        public function ClassField(name:String)
        {
            this.name = name;
            plcType = new Dictionary(true);
            plcValue = new Dictionary(true);
            lines = new <Line>[];
            lines.push(new Line("public class " + name));
            lines.push(new Line("{"));
//            lines.push(new Line("}"));
        }

        private var plcType:Dictionary;
        private var plcValue:Dictionary;

        /**
         * 已知缺陷(无法识别10进制以外的数字,比如rgb会被转成巨大的数字)
         * @param name
         * @param type
         * @param value complex type's value can't copy
         */
        public function addProperty(name:String, type:Class, value:Object = null):void
        {
            if (plcType[name])
                return;
            plcType[name] = type;
            plcValue[name] = value;
        }

        public function exportToLines():Vector.<Line>
        {
            var importLines:Vector.<Line> = new <Line>[];
            var propertyLines:Vector.<Line> = new <Line>[];
            var importNames:Vector.<String> = new <String>[];

            for (var k:String in plcType)
            {
                var fullName:String = org.as3commons.lang.ClassUtils.getFullyQualifiedName(plcType[k],true);
                if (importNames.indexOf(fullName) < 0 && !utils.ClassExtUtils.isTopClass(plcType[k]))
                {
                    importNames.push(fullName);
                    importLines.push(new Line("import " + fullName + ";"));
                }
                propertyLines.push(new Line("public var " + k + setPropertyTail(org.as3commons.lang.ClassUtils.getName(plcType[k]), plcValue[k]), 4));
            }

            return /*(new <Line>[]).concat*/(importLines).concat(lines).concat(propertyLines).concat(Vector.<Line>([new Line("}")]));
        }

        private function setPropertyTail(type:String, value:Object):String
        {
            if(type == "String")
            {
                if(value!=null)
                    value = "'"+value+"'";
            }
            if (value == null || !ObjectExtUtils.isPrimitiveType(value))
                return ":" + type + ";"
            return ":" + type + " = " + value + ";"
        }


    }
}
