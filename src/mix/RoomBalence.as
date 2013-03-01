/**
 * Created with IntelliJ IDEA.
 * User: lixuexin
 * Date: 13-2-27
 * Time: 下午2:33
 * To change this template use File | Settings | File Templates.
 */
package mix
{
    import flash.display.Sprite;

    public class RoomBalence extends Sprite
    {
        private var roomList:Vector.<Array>;
        private const ROOM_LENGTH:int = 5;
        private const ROOM_MAX:int = 10;
        public function RoomBalence()
        {
            roomList = new <Array>[];
            for(var i:uint = 0;i<ROOM_LENGTH;i++)
            {
                roomList[i] = [];
            }
            for(var j:uint = 0;j< 200;j++)
            {
                var index:int  = autoSelect();
                if(index>-1)
                {
                    roomList[index].push(1);
                }
                else
                {
                    trace("NO")
                    break;
                }
                trace(roomList.join("======="))
            }
        }

        private const RATES:Array = [0.5,0.75,.99]
        private function autoSelect():int
        {
            for(var i:int = 0;i< RATES.length;i++)
            {
                var index:int = select(RATES[i]);
                if(index>-1)
                {
                    return index;
                }
            }
            return -1;
        }

        private function select(rate:Number):int
        {
            var list:Vector.<Array> = roomList
            list.sort(sortFun);
            for(var i:int = 0;i< list.length;i++)
            {
                if(list[i].length / ROOM_MAX <rate)
                {
                    return i;
                }
            }
            return -1;

            function sortFun(a:Array,b:Array):Number
            {
                return b.length - a.length;
            }
        }
    }
}
