/**
 * User: lixuexin
 * Date: 13-5-13
 * Time: 下午5:56
 */
package code
{
    import org.as3commons.reflect.Accessor;
    import org.as3commons.reflect.Type;

    public class ClassDefine
    {
        public function ClassDefine(clzName:String, packageName:String)
        {
            classField = new ClassField(clzName);
            packageField = new PackageField(packageName);
            packageField.addClassField(classField);
        }

        private var packageField:PackageField;
        private var classField:ClassField;


        public function definePublicProperty(name:String, type:Class, value:* = null):void
        {
            classField.addProperty(name, type, value);
        }

        public static function converObj(obj:Object):ClassDefine
        {
            var type:org.as3commons.reflect.Type = org.as3commons.reflect.Type.forInstance(obj);
            var clz:ClassDefine = new ClassDefine(type.name,type.fullName.indexOf("::")!= -1 ?type.fullName.split("::")[0]:"");
            var fields:Array = type.fields;
            for(var i:int = 0;i<fields.length;i++)
            {
                var access:Accessor = Accessor(fields[i])
                if(access.readable &&access.writeable)
                {
                    clz.definePublicProperty(access.name,access.type.clazz,obj[access.name]);
                }
            }
            return clz;
        }

        public function debug():void
        {
            var lines:Vector.<Line> = packageField.exportLines();
            for(var i:int = 0;i< lines.length;i++)
            {
                trace(lines[i].print());
            }
        }
    }
}
