/**
 * User: Tomyail
 * Date: 13-5-12
 * Time: 下午11:11
 */
package utils
{
    import flash.utils.Dictionary;

    public class ArrayExtUtils
    {
        public function ArrayExtUtils()
        {
        }

        /**
         * 将数组中相同的元素合并成一个
         * 比如[1,2,3,3]会合并成[1,2,3]
         * @param arr
         * @return
         */
        public static function mergeSame(arr:Array):Array
        {
            var valueDic:Dictionary = new Dictionary(true);
            for(var i:int = 0;i<arr.length;i++)
            {
                if(!valueDic[arr[i]])
                {
                    valueDic[arr[i]] = true;
                }
                else
                {
                    arr.splice(i,1);
                    i--;
                }
            }
            return arr;
        }
    }
}
