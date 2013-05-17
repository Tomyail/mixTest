/**
 * User: lixuexin
 * Date: 13-5-9
 * Time: 下午5:14
 */
package
{
    import flash.events.NetStatusEvent;
    import flash.net.SharedObject;

    public class LocalCookie
    {
        private var _so:SharedObject;

        public function LocalCookie(_arg1:String)
        {
            if (_arg1 == ""){
                throw (new Error("name must not be empty!"));
            };
            this._so = SharedObject.getLocal(_arg1);
            this._so.addEventListener(NetStatusEvent.NET_STATUS, this.handler);
        }

        private function handler(_arg1:NetStatusEvent):void
        {
        }

        public function setCookie(key:String, data:Object):void
        {
            try {
                this._so.data[key] = data;
                this._so.flush();
            }
            catch(e) {
            };
        }

        public function getCookie(key:String):Object
        {
            return (this._so.data[key]);
        }

        public function clear(key:String=""):void
        {
            if (key){
                this._so.data[key] = "";
            }
            else {
                this._so.clear();
            };
        }


    }
}
