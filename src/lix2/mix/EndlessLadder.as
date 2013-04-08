/**
 * User: lixuexin
 * Date: 13-4-8
 * Time: 上午11:06
 */
package lix2.mix
{
    import flash.display.Sprite;

    public class EndlessLadder extends Sprite
    {
        public function EndlessLadder()
        {
            super();
        }
    }
}

import flash.display.Sprite;

class Border extends Sprite
{
    public function Border()
    {
        this.graphics.beginFill(Math.random()*0xffffff);
        this.graphics.drawRect(0,0,80+Math.random()*50,20);
    }
}
