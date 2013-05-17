/**
 * User: lixuexin
 * Date: 13-5-3
 * Time: 上午9:54
 */
package temp
{
    import flash.display.BitmapData;
    import flash.display.Sprite;

    public class BitmapTest extends Sprite
    {
        public function BitmapTest()
        {
            super();
            var bmpd:BitmapData = new BitmapData(500,500,true,0xff112233);
//            trace(bmpd.getPixel32(0,0)>>24);
            trace(uint(0xff112233).toString(2))
            trace(0xffffffff>>32);
            trace(uint(0xff112233>>>56).toString(2));
//            trace(0xffffffff.toString(2));
//            trace(uint(0xffffffff>>24).toString(2));
//            trace(uint(0xffffffff>>24).toString(16));
        }
    }
}
