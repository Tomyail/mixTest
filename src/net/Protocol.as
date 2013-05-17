/**
 * User: lixuexin
 * Date: 13-5-7
 * Time: 下午3:54
 */
package net
{
    import org.as3commons.reflect.Type;

    public class Protocol
    {
        private static var id:int = 0;
        public function Protocol()
        {
            requests = new <Class>[
            ]
        }

        public var requests:Vector.<Class>;

        public function push(req:Class):void
        {
            requests.push(req);
        }

        public function build():void
        {
            for (var i:int = 0; i < requests.length; i++)
            {
                var type:Type = Type.forClass(requests[i])
                var sv:Array = type.staticVariables;
                var l:int = sv.length;
                if (l)
                {
                    for (var j:int = 0; j < l; j++)
                    {
                        requests[i][sv[j].name] = id+"::"+ type.name + "::" + sv[j].name;
                    }
                }
                else
                {
                    trace(type.fullName + "has no static variables");
                }
            }
        }
    }
}
