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
        public static function shouldDailyReset(data1:Date, data2:Date):Boolean
        {
            var startDate:Date;
            var endDate:Date;
            if (data1.getTime() > data2.getTime())
            {
                startDate = data2;
                endDate = data1;
            }
            else
            {
                startDate = data1;
                endDate = data2;
            }
            if (getVariableDiff(startDate, endDate) > org.as3commons.lang.DateUtils.MILLIS_PER_DAY)
            {
                return true;
            }
            else
            {
                return endDate.getDay() != startDate.getDay();
            }
        }

        private static var defaultNameRuler:Array = [
            "刚刚",
            "秒",
            "分",
            "小时",
            "天",
            "星期",
            "很久"
        ]

        private static var defaultTimeRuler:Array = [
            0,
            org.as3commons.lang.DateUtils.MILLIS_PER_SECOND,
            org.as3commons.lang.DateUtils.MILLIS_PER_MINUTE,
            org.as3commons.lang.DateUtils.MILLIS_PER_HOUR,
            org.as3commons.lang.DateUtils.MILLIS_PER_DAY,
            org.as3commons.lang.DateUtils.MILLIS_PER_DAY*7,
            org.as3commons.lang.DateUtils.MILLIS_PER_DAY*14,
        ]

        /**
         * 将时差毫秒数转成可读性文字
         * @param mills
         * @param ruler[{10:},{}]
         * @return
         */
        public static function getReadableDataString(mills:Number, nameRuler:Array = null, timeRuler:Array = null):String
        {
            if (!nameRuler)
                nameRuler = defaultNameRuler;
            if (!timeRuler)
                timeRuler = defaultTimeRuler;
            var result:Number;
            for (var i:int = timeRuler.length-1; i > -1; i--)
            {
                if(mills >= timeRuler[i])
                {
                    result = mills/timeRuler[i];
                    break;
                }
            }
            if(i == timeRuler.length-1 || i == 0)
                return nameRuler[i];
            return Math.floor(result).toString()+nameRuler[i];
        }

        private static function getVariableDiff(startDate:Date, endDate:Date):Number
        {
            var startMillis:Number = startDate.getTime();
            var endMillis:Number = endDate.getTime();
            var dstOffset:Number = (startDate.getTimezoneOffset() - endDate.getTimezoneOffset()) * org.as3commons.lang.DateUtils.MILLIS_PER_MINUTE;
            return (endMillis - startMillis + dstOffset);
        }
    }
}
