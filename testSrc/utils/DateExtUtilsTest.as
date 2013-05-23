/**
 * User: lixuexin
 * Date: 13-5-23
 * Time: 上午9:59
 */
package utils
{
    import org.as3commons.lang.DateUtils;
    import org.flexunit.asserts.assertEquals;

    public class DateExtUtilsTest
    {
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
    }
}
