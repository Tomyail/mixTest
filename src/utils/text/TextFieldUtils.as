/**
 * User: lixuexin
 * Date: 13-5-10
 * Time: 下午6:04
 */
package utils.text
{
    import flash.text.TextField;

    import org.as3commons.lang.StringUtils;

    import utils.ArrayExtUtils;

    /**
     * 利用setTextFormat而不是html标签为单个textfield插入多种格式的工具类,
     */
    public class TextFieldUtils
    {
        public function TextFieldUtils()
        {
        }

        /**
         * 按次序为tf增加指定格式
         * @param tf
         * @param data
         */
        public static function pushMultiFormat(tf:TextField, data:Vector.<TextUnit>):void
        {
            var l:int = data.length;
            var s:int = 0;
            for (var i:int = 0; i < l; i++)
            {
                tf
                s = tf.length;
                tf.appendText(data[i].txt);
                tf.setTextFormat(data[i].format, s, tf.length);
            }
        }

        /**
         * 将reg里的内容分别整个替换成data里面的内容,如果data长度大于*的长度,忽略多余的,否则用tf默认格式和空字符串代替.
         * @param tf
         * @param data
         * @reg 不用regexp的原因在于这个函数对动态匹配不支持
         */
        public static function replaceMultiFormat(tf:TextField, data:Vector.<TextUnit>,reg:String = "[$]"):void
        {
            var pattern:String  = tf.text;
            var i:int = 0;
            var startIndex:Array = [];
            while(pattern.indexOf(reg)>-1)
            {
                var inex:int = pattern.indexOf(reg);

                startIndex.push(inex);
                if(data.length>i)
                {
                    pattern = pattern.replace(reg,data[i].txt);
                }
                else
                {
                    data.push(new TextUnit("",tf.defaultTextFormat));
                    pattern = pattern.replace(reg,data[i].txt);
                }
                i++
            }
            tf.text = pattern;
            for(i = 0;i<startIndex.length;i++)
            {
                tf.setTextFormat(data[i].format,startIndex[i],startIndex[i]+data[i].txt.length);
            }
        }
    }
}
