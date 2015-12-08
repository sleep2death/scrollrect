package {
    import flash.display.*;
    import flash.events.Event;
    import flash.geom.*;

    public class BlitSprite {
        private var ats : Vector.<AtlasData>;
        private var atsLength : uint;

        public var oX: int;
        public var oY: int;

        private var frmIndex : uint = 0;

        public function BlitSprite(ats:Vector.<AtlasData>) {
            this.ats = ats;
            this.atsLength = ats.length;
        }

        public function update(source: BitmapData, target : BitmapData) : void {
            var data : AtlasData = ats[frmIndex];
            target.copyPixels(source, data.rect, new Point(oX - data.frame.x, oY - data.frame.y), null, null, true);

            frmIndex++;
            if(frmIndex == atsLength) frmIndex = 0;
        }
    }
}
