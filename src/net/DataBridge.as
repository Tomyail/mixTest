package net
{
    import flash.utils.Dictionary;

    public class DataBridge
    {

        private var business:IBusiness;
        public function DataBridge(business:IBusiness)
        {
            this.business = business;
            dic = new Dictionary();
        }

        private var dic:Dictionary;

        public function bind(reqSign:String, callback:Function):void
        {
            if(verfity(reqSign))
            {
                dic[0] = new RequestSign("1","s",callback);
            }
        }

        public function call(reqSign:String, params:Object):void
        {
            if(verfity(reqSign))
            {
                //todo
//                sendToServer(method,callback) callback is passed by bind
                business.exec(dic[0]);
            }
        }

        private function verfity(str:String):RequestSign
        {
            var arr:Array = str.split("::");
            if(arr.length != 3)
                throw new Error();
        }

    }


}
