import Toybox.Lang;
import Toybox.WatchUi;

(:glance)
class ScoreWidgetGlanceView extends WatchUi.GlanceView {
    var nextFixture;

    function initialize() {
        GlanceView.initialize();
    }

    function onShow() {
    }

    function onUpdate(dc) {
        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var glanceText = Application.loadResource($.Rez.Strings.GlanceText) as String;
        dc.drawText(dc.getWidth() / 3, dc.getHeight() / 2, Graphics.FONT_MEDIUM, glanceText, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function onHide() {
    }
}
