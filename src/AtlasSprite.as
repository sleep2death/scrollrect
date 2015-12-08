package {
    import flash.display.*;
    import flash.events.Event;
    import flash.geom.Rectangle;

    public class AtlasSprite extends Bitmap {
        private var ats : Vector.<AtlasData>;
        private var atsLength : uint;

        private var frmIndex : uint = 0;

        public var oX : int = 0;
        public var oY : int = 0;

        public function AtlasSprite(bd : BitmapData, ats:Vector.<AtlasData>) {
            super(bd);

            this.ats = ats;
            this.atsLength = ats.length;

            init();
        }

        private function init() : void {
            this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
        }

        private function onAdded(evt : Event) : void {
            //update immediatly when added to stage
            this.update();

            this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
        }

        public function update(evt : Event = null) : void {
            this.scrollRect = ats[frmIndex].rect;
            this.x = oX + -ats[frmIndex].frame.x;
            this.y = oY + -ats[frmIndex].frame.y;

            frmIndex++;
            if(frmIndex == atsLength) frmIndex = 0;
        }

        //helpful function for creating the data
        public static function createData(xml : XML) : Vector.<AtlasData> {
            var ats : Vector.<AtlasData> = new Vector.<AtlasData>();
            for each(var sub : XML in xml.SubTexture){
                var data : AtlasData = new AtlasData(sub.@x, sub.@y, sub.@width, sub.@height, sub.@frameX, sub.@frameY, sub.@frameWidth, sub.@frameHeight);
                ats.push(data);
            }
            return ats;
        }
    }
}
