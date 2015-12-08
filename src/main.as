package {
    import flash.display.*;
    import com.bit101.components.*;

    import flash.events.Event;
    import flash.geom.Rectangle;

    import flash.net.URLLoader;
    import flash.net.URLRequest;

    [SWF(width=1024, height=768, backgroundColor=0x00, frameRate=60)] 

    public class main extends Sprite {
        private var info : Label;

        private static const BASE_URL : String = "../";

        public function main() {
            this.stage.scaleMode = StageScaleMode.NO_SCALE;

            var meter : FPSMeter = new FPSMeter(this);

            //testing sprites container
            addChild(container);

            //create info label
            info = new Label(this);
            info.text = "LOADING TEXTURE>>>";
            info.y = 12;

            loadSpriteSheet();
        }

        //load atlas xml from external
        private function loadSpriteSheet() : void {
            var ldr : URLLoader = new URLLoader();
            //just a test without io error handling
            ldr.addEventListener(Event.COMPLETE, onXMLLoaded);
            ldr.load(new URLRequest(BASE_URL + "texture.xml"));
        }

        //create the AtlasSprite Object
        private var xml : XML;//the atlas sprite data source
        private var bd : BitmapData;//the bitmapdata contains all the sub textures;

        private function onXMLLoaded(evt) : void {
            info.text="XML LOADED";

            xml = new XML(evt.target.data);

            //load the sprite image from the given URL
            var ldr : Loader = new Loader();
            ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
            ldr.load(new URLRequest(BASE_URL + xml.attribute('imagePath')));
        }

        private function onImageLoaded(evt) : void {
            bd = evt.target.content.bitmapData;
            info.text="TEXTURE LOADED";

            data = AtlasSprite.createData(xml);


            createUI();
        }

        private var aButton : PushButton;
        private var bButton : PushButton;
        private var cButton : PushButton;

        private function createUI() : void {
            aButton = new PushButton(this, 100, 4, 'SCROLL RECT', onAClick);
            aButton.toggle = true;

            bButton = new PushButton(this, 220, 4, 'BITMAPDATA SWAP', onBClick);
            bButton.toggle = true;

            cButton = new PushButton(this, 330, 4, 'BITTING', onCClick);
            cButton.toggle = true;
        }

        private function reset() : void {
            while(container.numChildren > 0){
                container.removeChildAt(0);
            }

            aSprites = new Vector.<AtlasSprite>();
            bSprites = new Vector.<BitmapDataSprite>();
            cSprites = new Vector.<BlitSprite>();

            this.removeEventListener(Event.ENTER_FRAME, aUpdate);
            this.removeEventListener(Event.ENTER_FRAME, bUpdate);
            this.removeEventListener(Event.ENTER_FRAME, cUpdate);

            if(canvas){
                canvas.bitmapData.dispose();
                canvas = null;
            }
        }

        private function onAClick(e:Event) : void {
            reset();
            if(aButton.selected == true){
                createAtlasSprites();
                bButton.selected = false;
                cButton.selected = false;
            }
        }

        private function onBClick(e:Event) : void {
            reset();
            if(bButton.selected == true){
                createBitmapDataSprites();
                aButton.selected = false;
                cButton.selected = false;
            }
        }

        private function onCClick(e:Event) : void {
            reset();
            if(cButton.selected == true){
                createBlitting();
                aButton.selected = false;
                bButton.selected = false;
            }
        }

        private var container : Sprite = new Sprite();

        private var aSprites : Vector.<AtlasSprite> = new Vector.<AtlasSprite>();
        private var spritesNum : uint = 200;
        private var data : Vector.<AtlasData>;

        private function createAtlasSprites() : void {
            for(var i : int = 0; i < spritesNum; i++){
                var atlas : AtlasSprite = new AtlasSprite(bd, data);
                atlas.oX = Math.random()* 1024 - 256;
                atlas.oY = Math.random()* 768 - 256;
                container.addChild(atlas);
                aSprites.push(atlas);
            }

            this.addEventListener(Event.ENTER_FRAME, aUpdate);
        }

        private function aUpdate(evt : Event) : void {
            for(var i : int = 0; i < spritesNum; i++){
                var atlas : AtlasSprite = aSprites[i];
                atlas.update();
            }
        }

        private var bSprites : Vector.<BitmapDataSprite> = new Vector.<BitmapDataSprite>();
        private function createBitmapDataSprites() : void {
            var bds : Vector.<BitmapData> = BitmapDataSprite.createBDs(bd, xml);

            for(var i : int = 0; i < spritesNum; i++){
                var sprite : BitmapDataSprite = new BitmapDataSprite(bds, data);

                sprite.oX = Math.random()* 1024 - 256;
                sprite.oY = Math.random()* 768 - 256;
                container.addChild(sprite);
                bSprites.push(sprite);
            }

            this.addEventListener(Event.ENTER_FRAME, bUpdate);
        }

        private function bUpdate(evt:Event) : void {
            for(var i : int = 0; i < spritesNum; i++){
                var sprite : BitmapDataSprite = bSprites[i];
                sprite.update();
            }
        }

        private var canvas : Bitmap;
        private var cSprites : Vector.<BlitSprite> = new Vector.<BlitSprite>();

        private function createBlitting() : void {
            canvas = new Bitmap(new BitmapData(1024, 768, true, 0x00000000));
            container.addChild(canvas);

            for(var i : int = 0; i < spritesNum; i++){
                var sprite : BlitSprite = new BlitSprite(data);
                sprite.oX = Math.random()* 1024 - 256;
                sprite.oY = Math.random()* 768 - 256;
                cSprites.push(sprite);
            }

            this.addEventListener(Event.ENTER_FRAME, cUpdate);
        }

        private function cUpdate(evt : Event) : void {
            canvas.bitmapData.lock();
            canvas.bitmapData.fillRect(new Rectangle(0, 0, 1024, 768), 0);

            for(var i : int = 0; i < spritesNum; i++){
                var sprite : BlitSprite = cSprites[i];
                sprite.update(bd, canvas.bitmapData);
            }

            canvas.bitmapData.unlock();
        }
    }
}
