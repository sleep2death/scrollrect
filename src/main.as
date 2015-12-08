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

            //createAtlasSprites();
            //createBitmapDataSprites();
            createBlitting();
        }

        private var aSprites : Vector.<AtlasSprite> = new Vector.<AtlasSprite>();
        private var spritesNum : uint = 200;
        private var data : Vector.<AtlasData>;

        private function createAtlasSprites() : void {
            for(var i : int = 0; i < spritesNum; i++){
                var atlas : AtlasSprite = new AtlasSprite(bd, data);
                atlas.oX = Math.random()* 1024 - 256;
                atlas.oY = Math.random()* 768 - 256;
                this.addChild(atlas);
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
                this.addChild(sprite);
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
            this.addChild(canvas);

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
