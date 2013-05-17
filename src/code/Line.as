/**
 * User: Tomyail
 * Date: 13-5-13
 * Time: 下午10:52
 */
package code
{
    public class Line
    {
        private var spaceNum:int;
        private var _value:String;
        public function Line(value:String,spaceNum:int = 0)
        {
            this._value = value;
            this.spaceNum = spaceNum;
        }

        public function shiftSpace(spaceNum:int = 1):void
        {
            this.spaceNum += spaceNum;
        }

        public function print():String
        {
            return getSpaceString()+_value;
        }

        private function getSpaceString():String
        {
            var str:String = "";
            for(var i:int = 0;i< spaceNum;i++)
            {
                str += " ";
            }
            return str;
        }

        public function get value():String
        {
            return _value;
        }
    }
}
