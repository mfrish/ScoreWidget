import Toybox.Lang;
import Toybox.WatchUi;

class GenericBehaviorDelegate extends WatchUi.BehaviorDelegate {
    var currentViewArray as Array<View>;
    var currentIndex as Number;
    var showCarousel as Boolean;

    function initialize(viewArr) {
        BehaviorDelegate.initialize();
        currentViewArray = viewArr;
        currentIndex = 0;
        showCarousel = false;
    }

    function onNextPage() as Boolean {
        if (currentIndex + 1 < currentViewArray.size()) {
            currentViewArray[currentIndex].clearLayers();
            currentIndex++;
            WatchUi.switchToView(currentViewArray[currentIndex], self, WatchUi.SLIDE_IMMEDIATE);
            return true;
        }
        return false;
    }

    function onPreviousPage() as Boolean {
        if (currentIndex - 1 >= 0) {
            currentViewArray[currentIndex].clearLayers();
            currentIndex--;
            WatchUi.switchToView(currentViewArray[currentIndex], self, WatchUi.SLIDE_IMMEDIATE);
            return true;
        }
        return false;
    }

    function onBack() as Boolean {
        System.exit();
    }
}