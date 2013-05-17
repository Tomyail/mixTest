/**
 * User: Tomyail
 * Date: 13-5-15
 * Time: 下午10:59
 */
package utils
{
    public class ObjectExtUtils
    {
        public function ObjectExtUtils()
        {
        }

        public static function isPrimitiveType(obj:Object):Boolean
        {
            if (obj is int ||
                    obj is String ||
                    obj is uint ||
                    obj is Number ||
                    obj is Boolean
                    )
                return true;
            return false;
        }
    }
}
