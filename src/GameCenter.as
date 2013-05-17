package
{

    import flash.display.Sprite;
    import flash.text.TextField;

    public class GameCenter extends Sprite
    {
        public function GameCenter()
        {
            var textField:TextField = new TextField();
            textField.text = "Hello, World";
            addChild(textField);

            Log.logger.info("helloWorld");

        }
    }
}
