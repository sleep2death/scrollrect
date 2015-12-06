package {
    import flash.display.*;
    import com.bit101.components.FPSMeter;

    [SWF(width=800, height=600, backgroundColor=0xffffff, frameRate=60)] 

    public class main extends Sprite {
        public function main() {
            new FPSMeter(this);
        }
    }
}
