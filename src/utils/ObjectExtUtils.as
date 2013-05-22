/**
 * User: Tomyail
 * Date: 13-5-15
 * Time: 下午10:59
 */
package utils
{
    import flash.utils.getQualifiedClassName;

    import org.as3commons.lang.ClassUtils;

    import org.as3commons.lang.ObjectUtils;
    import org.as3commons.reflect.Type;
    import org.as3commons.reflect.Variable;

    public class ObjectExtUtils
    {
        public function ObjectExtUtils()
        {
        }


        public static function recursionInstanceTo(object:Object, clazz:Class):*
        {
            var rst:Object = ObjectUtils.toInstance(object, clazz);
            var a:Array = org.as3commons.reflect.Type.forInstance(rst).variables;
            for each (var k:Variable in a)
            {
                if (!ObjectUtils.isSimple(rst[k.name]) && !rst[k.name])
                {

                    if(object[k.name] is Array && VectorExtUtils.isVector(k.type.clazz))
                    {
                        rst[k.name] = ClassUtils.newInstance(k.type.clazz);
                        for(var i:int = 0;i<object[k.name].length;i++)
                        {
                            //rst[k.name].push(recursionInstanceTo(object[k.name][i],ClassUtils.forName("")))
                        }
                    }
                    else
                    {
                        rst[k.name] = recursionInstanceTo(object[k.name], k.type.clazz);
                    }
                }
            }
            return rst;
        }
    }
}
