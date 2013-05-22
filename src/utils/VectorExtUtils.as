/**
 * User: lixuexin
 * Date: 13-5-22
 * Time: 下午4:09
 */
package utils
{
    import flash.utils.getQualifiedClassName;

    import org.as3commons.lang.ClassUtils;

    public class VectorExtUtils
    {
        public function VectorExtUtils()
        {
        }

        public static function getVectorContentType(value:Object):Class
        {
            if(isVector(value))
            {
                var str:String = getQualifiedClassName(value);
                var fullName:String = str.slice(str.indexOf(".<")+2,str.length-1);
                return ClassUtils.forName(fullName);
            }
            return null;
        }

        private static const VECTOR_PREFIX:String = getQualifiedClassName(Vector);
        public static function isVector(value:Object):Boolean
        {
            return getQualifiedClassName(value).indexOf(VECTOR_PREFIX) != -1
        }
    }
}
