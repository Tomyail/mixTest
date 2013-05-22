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

        public static function isTopClass(value:Object):Boolean
        {
            return ObjectUtils.getFullyQualifiedClassName(value,true).indexOf(".") < 0;
        }

        public static function isPrimitiveClass(value:Object):Boolean
        {
            return ["int","uint","Number","String","Boolean"].indexOf(ObjectUtils.getFullyQualifiedClassName(value,true)) > -1;
        }
    }
}
