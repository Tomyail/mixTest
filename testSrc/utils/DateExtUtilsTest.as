/**
 * User: lixuexin
 * Date: 13-5-23
 * Time: 上午9:59
 */
package utils
{
    import flash.globalization.DateTimeFormatter;

    import org.as3commons.lang.DateUtils;
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class DateExtUtilsTest
    {
        private static const YEAR:int = 2005;
        private static const MONTH:int = 2;
        private static const DAY_OF_MONTH:int = 4;
        private static const HOUR:int = 1;
        private static const MINUTE:int = 0;
        private static const SECOND:int = 0;
        private static const MILLIS:int = 0;
        private static const CONTROL_DATE:Date = new Date(YEAR, MONTH, DAY_OF_MONTH, HOUR, MINUTE, SECOND, MILLIS);

        public function DateExtUtilsTest()
        {
        }

        [Test]
        public function testGetReadableDataString():void
        {
            assertEquals("1秒",DateExtUtils.getReadableDataString(DateUtils.MILLIS_PER_SECOND));
            assertEquals("刚刚",DateExtUtils.getReadableDataString(DateUtils.MILLIS_PER_SECOND-1));
            assertEquals("1小时",DateExtUtils.getReadableDataString(DateUtils.MILLIS_PER_HOUR+1));
            assertEquals("1天",DateExtUtils.getReadableDataString(DateUtils.MILLIS_PER_HOUR*24));
            assertEquals("23小时",DateExtUtils.getReadableDataString(DateUtils.MILLIS_PER_DAY-1));
            assertEquals("1星期",DateExtUtils.getReadableDataString(DateUtils.MILLIS_PER_DAY*7));
            assertEquals("很久",DateExtUtils.getReadableDataString(DateUtils.MILLIS_PER_DAY*14));
        }

        [Test]
        public function testShouldDailyReset():void
        {
            var d:DateTimeFormatter = new DateTimeFormatter("ZH_CN")
            var endDate:Date = new Date(YEAR, MONTH, DAY_OF_MONTH, HOUR + 22, MINUTE + 59, SECOND + 59, MILLIS + 1);

            trace(d.format(endDate));
            assertFalse(DateExtUtils.shouldDailyReset(endDate, CONTROL_DATE));

            endDate = new Date(YEAR, MONTH, DAY_OF_MONTH, HOUR + 24, MINUTE, SECOND, MILLIS);
            trace(d.format(endDate));
            assertTrue(DateExtUtils.shouldDailyReset(endDate, CONTROL_DATE));

            endDate = new Date(YEAR, MONTH, DAY_OF_MONTH + 1, HOUR, MINUTE, SECOND, MILLIS);
            trace(d.format(endDate));
            assertTrue(DateExtUtils.shouldDailyReset(endDate, CONTROL_DATE));
        }
    }
}
