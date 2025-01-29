import Toybox.Lang;
import Toybox.WatchUi;

class GenericBehaviorDelegate extends WatchUi.BehaviorDelegate {
    var currentView;
    var nextViewArray;
    var hasPreviousView as Boolean;
    var showCarousel as Boolean;

    function initialize(currView, nextView, hasPrevView) {
        BehaviorDelegate.initialize();
        currentView = currView;
        nextViewArray = nextView;
        hasPreviousView = hasPrevView;
        showCarousel = false;
    }

    function onNextPage() as Boolean {
        if (nextViewArray != null) {
            currentView.clearLayers();
            WatchUi.pushView(nextViewArray[0], nextViewArray[1], WatchUi.SLIDE_IMMEDIATE);
            return true;
        }
        return false;
    }

    function onPreviousPage() as Boolean {
        if (hasPreviousView) {
            currentView.clearLayers();
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            return true;
        }
        return false;
    }

    function onBack() as Boolean {
        System.exit();
    }
}