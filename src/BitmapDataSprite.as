package {
    import flash.display.*;
    import flash.events.Event;
    import flash.geom.*;

    public class BitmapDataSprite extends Bitmap {
        private var ats : Vector.<AtlasData>;
        private var atsLength : uint;
        private var bds : Vector.<BitmapData>

        public var oX: int;
        public var oY: int;

        private var frmIndex : uint = 0;

        public function BitmapDataSprite(bds : Vector.<BitmapData>, ats:Vector.<AtlasData>) {
            super(bds[0]);

            this.ats = ats;
            this.bds = bds;
            this.atsLength = ats.length;
        }

        public function update(evt : Event = null) : void {
            this.bitmapData = bds[frmIndex];
            this.x = oX + -ats[frmIndex].frame.x;
            this.y = oY + -ats[frmIndex].frame.y;

            frmIndex++;
            if(frmIndex == atsLength) frmIndex = 0;
        }
        //helpful function for creating the bitmapdatas
        public static function createBDs(source : BitmapData, xml : XML) : Vector.<BitmapData> {
            var bds : Vector.<BitmapData> = new Vector.<BitmapData>();
            for each(var sub : XML in xml.SubTexture){
                var data : AtlasData = new AtlasData(sub.@x, sub.@y, sub.@width, sub.@height, sub.@frameX, sub.@frameY, sub.@frameWidth, sub.@frameHeight);
                var bd : BitmapData = new BitmapData(sub.@width, sub.@height, true, 0x00000000);
                bd.copyPixels(source, data.rect, new Point(0, 0), null, null, true);
                bds.push(bd);
            }
            return bds;
        }
    }
}
