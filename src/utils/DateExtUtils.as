/**
 * User: lixuexin
 * Date: 13-5-15
 * Time: 上午11:34
 */
package utils
{
    import org.as3commons.lang.DateUtils;

    public class DateExtUtils
    {
        public function DateExtUtils()
        {
        }

        /**
         * 是否是新的一天(过了超过24小时算一天,0点之后也算一天)
         * @param date
         * @return
         */
        public static function shouldDailyReset(data1:Date,data2:Date):Boolean
        {
            var startDate:Date;
            var endDate:Date;
            if(data1.getTime() > data2.getTime())
            {
                startDate = data2;
                endDate = data1;
            }
            else
            {
                startDate = data1;
                endDate = data2;
            }
            if(getVariableDiff(startDate,endDate) > org.as3commons.lang.DateUtils.MILLIS_PER_DAY)
            {
                return true;
            }
            else
            {
                return endDate.getDay() != startDate.getDay();
            }
        }

        private static var defaultRuler:Array = [

        ]
        /**
         * 将时差毫秒数转成可读性文字
         * @param mills
         * @param ruler[{10:},{}]
         * @return
         */
        public static function getReadableDataString(mills:Number,nameRuler:Array=null,timeRuler:Array=null):String
        {

        }

        private static function getVariableDiff (startDate:Date, endDate:Date) : Number {
            var startMillis:Number = startDate.getTime();
            var endMillis:Number = endDate.getTime();
            var dstOffset:Number = (startDate.getTimezoneOffset() - endDate.getTimezoneOffset()) * org.as3commons.lang.DateUtils.MILLIS_PER_MINUTE;
            return (endMillis - startMillis + dstOffset);
        }
    }
}
