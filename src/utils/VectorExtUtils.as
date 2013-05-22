/**
 * User: lixuexin
 * Date: 13-5-22
 * Time: 下午4:09
 */
package utils
{
    import flash.utils.getQualifiedClassName;

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
