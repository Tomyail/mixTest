/**
 * User: Tomyail
 * Date: 13-5-12
 * Time: 下午11:21
 */
package utils
{
    import org.hamcrest.assertThat;
    import org.hamcrest.collection.array;

    public class ArrayExtUtilsTest
    {
        public function ArrayExtUtilsTest()
        {
        }

        [Test]
        public function testSimpleMergeSame():void
        {
            assertThat(ArrayExtUtils.mergeSame([1,2,3,1,2]),array(1,2,3));
            assertThat(ArrayExtUtils.mergeSame([1,1,3,2,3,1,2]),array(1,3,2));
            assertThat(ArrayExtUtils.mergeSame(["1","2","2"]),array("1","2"));
        }

        [Test]
        public function testObjMergeSame():void
        {
            var a:Object = {};
            var b:Object = {};
            var c:Object = a;
            var test:Array = [a,b,c];
            assertThat(ArrayExtUtils.mergeSame(test),array(a,b));
        }
    }
}
