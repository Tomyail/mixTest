/**
 * User: lixuexin
 * Date: 13-5-9
 * Time: 下午2:59
 */
package
{
    import org.as3commons.logging.api.ILogger;
    import org.as3commons.logging.api.LOGGER_FACTORY;
    import org.as3commons.logging.api.getLogger;
    import org.as3commons.logging.setup.SimpleTargetSetup;
    import org.as3commons.logging.setup.target.TraceTarget;

    use namespace LOGGER_FACTORY;

    public class Log
    {

        LOGGER_FACTORY.setup = new SimpleTargetSetup( new TraceTarget());
        public static const logger:ILogger = getLogger(Log,"lxx");
        public function Log()
        {
        }
    }
}
