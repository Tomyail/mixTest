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
            return getFullyQualifiedClassName(value).indexOf(".") < 0;
        }

        public static function getFullyQualifiedClassName(value:Object):String
        {
            if(value is Class)
            {
                return org.as3commons.lang.ClassUtils.getFullyQualifiedName(value as Class,true);
            }
            else
            {
                return ObjectUtils.getFullyQualifiedClassName(value,true);
            }
        }

        public static function isPrimitiveClass(value:Object):Boolean
        {
            return ["int","uint","Number","String","Boolean"].indexOf(getFullyQualifiedClassName(value)) > -1;
        }
    }
}
