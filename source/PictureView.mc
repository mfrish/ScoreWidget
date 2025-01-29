import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class PictureView extends WatchUi.View {
    var _backgroundLayer;
    var pictureBitmap as BitmapResource;

    function initialize(watchWidth as Number, watchHeight as Number) {
        View.initialize();

        _backgroundLayer = new WatchUi.Layer({:x=>0, :y=>0, :width=>watchWidth, :height=>watchHeight});
        pictureBitmap = Application.loadResource($.Rez.Drawables.LargeImage);
    }

    function onShow() as Void {
        addLayer(_backgroundLayer);
    }

    function onUpdate(dc as Dc) as Void {
        var backgroundDc = _backgroundLayer.getDc();
        backgroundDc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        backgroundDc.clear();
        backgroundDc.drawBitmap(0, 0, pictureBitmap);
    }
}