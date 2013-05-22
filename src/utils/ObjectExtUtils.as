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


        /**
         * 递归的将一个obj转换成对应的类型,支持将obj里面的数组自动转成指定的的vector类型
         * <b>该警觉错误:ReferenceError: Error #1056 无法为 某类 创建某属性,这种情况说明obj的数据结构和指定类有区别!!</b>
         * 可忽略错误:将obj的复杂类型转换成指定类型会报TypeError: Error #1034: 强制转换类型失败
         * @param object
         * @param clazz
         * @return
         */
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
                            rst[k.name].push(recursionInstanceTo(object[k.name][i],VectorExtUtils.getVectorContentType(k.type.clazz)))
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
