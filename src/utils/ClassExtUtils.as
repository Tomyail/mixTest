/**
 * User: Tomyail
 * Date: 13-5-13
 * Time: 下午11:17
 */
package utils
{
    import org.as3commons.lang.ClassUtils;
    import org.as3commons.lang.ObjectUtils;

    public class ClassExtUtils
    {
        public function ClassExtUtils()
        {
        }

        /**
         * 是否是顶级类(没有子包结构)
         * @param objOrClz
         * @return
         */
        public static function isTopClass(objOrClz:Object):Boolean
        {
            return ObjectUtils.getFullyQualifiedClassName(objOrClz,true).indexOf(".") < 0;
        }

        /**
         * 判断对象是否是简单类型
         * @param objOrClz 可以是实例也可以是类
         * @return
         */
        public static function isPrimitiveClass(objOrClz:Object):Boolean
        {
            return ["int","uint","Number","String","Boolean"].indexOf(ObjectUtils.getFullyQualifiedClassName(objOrClz,true)) > -1;
        }
    }
}
