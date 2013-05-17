/**
 * User: lixuexin
 * Date: 13-4-8
 * Time: 上午11:12
 */
package lix2.utils
{
    import flash.utils.Dictionary;

    /**
     *
     * @author zhangxun
     *
     * a resourcePool (the 'resource' maybe create, remove frequently, so use the pool to improve performance)
     *
     */
    public class ResourcePool
    {
        public function ResourcePool()
        {
        }

        /**
         *
         */
        public static const instance:ResourcePool = new ResourcePool();

        /**
         *
         */
        private static const poolDict:Dictionary = new Dictionary();

        /**
         * get pool with specfied type (the type is class or object)
         */
        public function getPool(c:Class):Dictionary
        {
            return c in poolDict ? poolDict[c] as Dictionary : poolDict[c] = new Dictionary();
        }

        /**
         * get specfied type's object
         */
        public function getResource(d:Class, ...args):*
        {
            var k:Dictionary = getPool(d);
            if (k.getLen() > 0)
            {
                var t:* = k.getContent(k.getLen() - 1);
                if (ObjectUtil.checkIsImplementsInterface(getClass(t), IResourcePoolSetter))
                {
                    IResourcePoolSetter(t).reset.apply(t, args);
                }
                k.remove(t);
                return t;
            }
            var c:Class = getType(d);
            return construct(c, args);
        }

        /**
         * this construct method maybe look bad smell,
         * but now I could't found a better way to 'dynamic' construct a class
         *
         * construct method couldn't use function's method 'apply' or 'call'
         *
         */
        private function construct(c:Class, args:Array):*
        {
            var d:*;
            switch (args.length)
            {
                case 0:
                    d = new c();
                    break;
                case 1:
                    d = new c(args[0]);
                    break;
                case 2:
                    d = new c(args[0], args[1]);
                    break;
                case 3:
                    d = new c(args[0], args[1], args[2]);
                    break;
                case 4:
                    d = new c(args[0], args[1], args[2], args[3]);
                    break;
                case 5:
                    d = new c(args[0], args[1], args[2], args[3], args[4]);
                    break;
                case 6:
                    d = new c(args[0], args[1], args[2], args[3], args[4], args[5]);
                    break;
                case 7:
                    d = new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
                    break;
                case 8:
                    d = new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
                    break;
                case 9:
                    d = new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
                    break;
                case 10:
                    d = new c(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
                    break;
                default:
                    trace("you specfied class's construct's method's arguments length more than 10, so check 'construct' method in ResourcePool");
                    break;
            }
            return d;
        }


        /**
         * dispose a object to specfied pool （the lastIndexOf method maybe bring a performance issue）
         */
        public function dispose(d:*, fun:Function = null):void
        {
            if (!d)
            {
                return;
            }
            var k:VectorMap = getPool(d);
            if (!k.contain(d))
            {
                k.add(d);
            }
        }
    }

}
