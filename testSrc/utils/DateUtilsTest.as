/**
 * User: lixuexin
 * Date: 13-5-15
 * Time: 上午11:42
 */
package utils
{
    import flash.globalization.DateTimeFormatter;

    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class DateUtilsTest
    {
        private static const YEAR:int = 2005;
        private static const MONTH:int = 2;
        private static const DAY_OF_MONTH:int = 4;
        private static const HOUR:int = 1;
        private static const MINUTE:int = 0;
        private static const SECOND:int = 0;
        private static const MILLIS:int = 0;
        private static const CONTROL_DATE:Date = new Date(YEAR, MONTH, DAY_OF_MONTH, HOUR, MINUTE, SECOND, MILLIS);

        public function DateUtilsTest()
        {
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
