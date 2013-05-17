/**
 * User: lixuexin
 * Date: 13-5-8
 * Time: 下午6:08
 */
package net
{
    public class RequestSign
    {
        public function RequestSign(clz:String,method:String,callback:Function)
        {
            this.clz = clz;
            this.method = method;
            this.callback = callback;
        }

        public var callback:Function;
        public var method:String;
        public var clz:String;
    }
}
