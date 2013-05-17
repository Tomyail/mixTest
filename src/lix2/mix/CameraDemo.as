package lix2.mix {
    import com.bit101.components.*;

    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class CameraDemo extends Sprite
    {
        private var myTextField:TextField;
        private var cam:Camera;
        private var t:Timer;
        private var cam_width:int = 800;
        private var cam_height:int = 600;
        private var cam_url:String = "rtmp://58.215.160.82/live";
        private var cam_quality:int = 100;
        private var cam_bandwidth:int = 0;
        private var cam_name:String = "test4";
        private var cam_fps:int = 24;
        private var cam_keyFrameInterval:int = 3;
        private var cam_compress:Boolean = false;
        private var cam_motionLevel:int = 50;
        private var cam_timeout:int = 2000;
        private var statusBtn:PushButton;
        private var microphone:Microphone;
        private var phone_rate:int = 8;
        private var phone_volume:Number = 10;
        private var phone_gain:Number = 50;
        private var phone_silenceLevel:Number = 6;
        private var nc:NetConnection;
        private var connected:Boolean = false;
        private var outStream:NetStream;

        public function CameraDemo()
        {
            this.t = new Timer(1000);
            this.cam_bandwidth = this.loaderInfo.parameters["bandwidth"] ? (this.loaderInfo.parameters["bandwidth"]) : (this.cam_bandwidth);
            this.cam_width = this.loaderInfo.parameters["width"] ? (this.loaderInfo.parameters["width"]) : (this.cam_width);
            this.cam_height = this.loaderInfo.parameters["height"] ? (this.loaderInfo.parameters["height"]) : (this.cam_height);
            this.cam_url = this.loaderInfo.parameters["url"] ? (this.loaderInfo.parameters["url"]) : (this.cam_url);
            this.cam_quality = this.loaderInfo.parameters["quality"] ? (this.loaderInfo.parameters["quality"]) : (this.cam_quality);
            this.cam_name = this.loaderInfo.parameters["name"] ? (this.loaderInfo.parameters["name"]) : (this.cam_name);
            this.cam_fps = this.loaderInfo.parameters["fps"] ? (this.loaderInfo.parameters["fps"]) : (this.cam_fps);
            this.cam_keyFrameInterval = this.loaderInfo.parameters["keyFrameInterval"] ? (this.loaderInfo.parameters["keyFrameInterval"]) : (this.cam_keyFrameInterval);
            this.cam_compress = this.loaderInfo.parameters["compress"] ? (this.loaderInfo.parameters["compress"]) : (this.cam_compress);
            this.cam_motionLevel = this.loaderInfo.parameters["motionLevel"] ? (this.loaderInfo.parameters["motionLevel"]) : (this.cam_motionLevel);
            this.cam_timeout = this.loaderInfo.parameters["timeout"] ? (this.loaderInfo.parameters["timeout"]) : (this.cam_timeout);
            this.phone_rate = this.loaderInfo.parameters["rate"] ? (this.loaderInfo.parameters["rate"]) : (this.phone_rate);
            this.phone_volume = this.loaderInfo.parameters["volume"] ? (this.loaderInfo.parameters["volume"]) : (this.phone_volume);
            this.phone_gain = this.loaderInfo.parameters["gain"] ? (this.loaderInfo.parameters["gain"]) : (this.phone_gain);
            this.phone_silenceLevel = this.loaderInfo.parameters["silenceLevel"] ? (this.loaderInfo.parameters["silenceLevel"]) : (this.phone_silenceLevel);

            this.myTextField = new TextField();
            this.myTextField.x = 10;
            this.myTextField.y = 30;
            this.myTextField.background = true;
            this.myTextField.selectable = false;
            this.myTextField.autoSize = TextFieldAutoSize.LEFT;
            this.statusBtn = new PushButton(this as DisplayObjectContainer, 0, 0, "Pause", this.statusBtnHandler);
            this.statusBtn.enabled = false;
            if (Camera.isSupported)
            {
            }
            if (Microphone.isSupported)
            {
                this.cam = Camera.getCamera();
                this.microphone = Microphone.getMicrophone();
                if (!this.cam)
                {
                    this.myTextField.text = "No camera is installed.";
                }
                else if (this.cam.muted)
                {
                    this.clickHandler();
                }
                else
                {
                    this.myTextField.text = "Connecting";
                    this.connectCamera();
                }
                addChild(this.myTextField);
                this.t.addEventListener(TimerEvent.TIMER, this.timerHandler);
            }
            else
            {
                this.myTextField.text = "The Camera class is not supported on this device.";
            }
            return;
        }// end function

        private function statusBtnHandler(event:MouseEvent) : void
        {
            if (this.connected)
            {
                this.nc.close();
                this.nc.removeEventListener(NetStatusEvent.NET_STATUS, this.ncHandler);
                this.connected = false;
                this.statusBtn.label = "Connect";
            }
            else
            {
                this.connectFMS();
            }
            return;
        }// end function

        private function clickHandler(event:MouseEvent = null) : void
        {
            Security.showSettings(SecurityPanel.PRIVACY);
            this.cam.addEventListener(StatusEvent.STATUS, this.statusHandler);
            this.microphone.addEventListener(StatusEvent.STATUS, this.statusHandler);
            this.myTextField.removeEventListener(MouseEvent.CLICK, this.clickHandler);
            return;
        }// end function

        private function statusHandler(event:StatusEvent) : void
        {
            trace(event.code);
            if (event.code == "Camera.Unmuted")
            {
                this.connectCamera();
                this.cam.removeEventListener(StatusEvent.STATUS, this.statusHandler);
            }
            return;
        }// end function

        private function connectCamera() : void
        {
            this.cam.setMode(this.cam_width, this.cam_height, this.cam_fps);
            this.cam.setQuality(this.cam_bandwidth, this.cam_quality);
            this.cam.setKeyFrameInterval(this.cam_keyFrameInterval);
            this.cam.setLoopback(this.cam_compress);
            this.cam.setMotionLevel(this.cam_motionLevel, this.cam_timeout);
            this.microphone.setLoopBack(false);
            this.microphone.setUseEchoSuppression(true);
            this.microphone.rate = this.phone_rate;
            this.microphone.setSilenceLevel(phone_silenceLevel);
            this.microphone.gain = phone_gain;
            var _loc_2:SoundTransform = new SoundTransform();
            _loc_2.volume = this.phone_volume;
            this.microphone.soundTransform = _loc_2;
            var _loc_1:* = new Video(this.cam.width, this.cam.height);
            _loc_1.x = 10;
            _loc_1.y = 10;
            _loc_1.attachCamera(this.cam);
            addChildAt(_loc_1, 0);
//            this.t.start();
            this.connectFMS();
            return;
        }// end function

        public function onBWDone(... args) : void
        {
            return;
        }// end function

        protected function connectFMS() : void
        {
            this.statusBtn.enabled = false;
            this.nc = new NetConnection();
            this.nc.client = this;
            this.nc.connect(this.cam_url);
            this.nc.addEventListener(NetStatusEvent.NET_STATUS, this.ncHandler);
            return;
        }// end function

        protected function ncHandler(event:NetStatusEvent) : void
        {
            trace(getTimer()+":"+event.info.code)
            this.myTextField.appendText(getTimer()+":"+event.info.code);
            if (event.info.code == "NetConnection.Connect.Success")
            {
                this.outStream = new NetStream(this.nc);
                this.outStream.client = this;
                this.outStream.attachCamera(this.cam);
                this.outStream.attachAudio(this.microphone);
                this.outStream.publish(this.cam_name, "live");
                this.statusBtn.enabled = true;
                this.connected = true;
                this.statusBtn.label = "Disconnect";
            }
            return;
        }// end function

        private function timerHandler(event:TimerEvent) : void
        {
            this.myTextField.y = this.cam.height + 20;
            this.myTextField.text = "";
            this.myTextField.appendText("bandwidth: " + this.cam.bandwidth + "\n");
            this.myTextField.appendText("currentFPS: " + Math.round(this.cam.currentFPS) + "\n");
            this.myTextField.appendText("fps: " + this.cam.fps + "\n");
            this.myTextField.appendText("keyFrameInterval: " + this.cam.keyFrameInterval + "\n");
            return;
        }// end function

    }
}
