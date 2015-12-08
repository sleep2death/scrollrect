package {
    import flash.geom.Rectangle;

    public class AtlasData {
        public var rect : Rectangle;
        public var frame : Rectangle;

        public function AtlasData(x: int, y: int, w : int, h : int, fx: int, fy : int, fw: int, fh : int) {
            this.rect = new Rectangle(x, y, w, h);
            this.frame = new Rectangle(fx, fy, fw, fh);
        }
    }
}
