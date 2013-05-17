/**
 * User: lixuexin
 * Date: 13-5-8
 * Time: 下午6:43
 */
package net
{
    import flash.utils.setTimeout;

    public class TimeOutBusiness implements IBusiness
    {
        public function TimeOutBusiness()
        {
        }

        public function exec(req:RequestSign)
        {
            setTimeout(req.callback,5000);
        }
    }
}
