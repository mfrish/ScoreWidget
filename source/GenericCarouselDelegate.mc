import Toybox.Lang;
import Toybox.WatchUi;

class GenericCarouselDelegate extends GenericBehaviorDelegate {
    var carouselVisible;
    var currentView;
    var carouselStackHeight = 0;

    function initialize(currView, nextView, hasPrevView) {
        GenericBehaviorDelegate.initialize(currView, nextView, hasPrevView);
        carouselVisible = false;
        currentView = currView;
    }

    function onSelect() as Boolean {
        // toggle carousel on select
        if (carouselVisible) {
            carouselVisible = false;
            currentView.showCarousel = false;
            currentView.resetCarousel();
            currentView.clearLayers();
            for (var i = 0; i < carouselStackHeight; i++) {
                WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            }
            carouselStackHeight = 0;
            return true;
        }

        carouselVisible = true;
        currentView.showCarousel = true;
        currentView.clearLayers();
        carouselStackHeight++;
        WatchUi.pushView(currentView, self, WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    function onNextPage() as Boolean {
        if (carouselVisible) {
            if (!currentView.canGoToNextCarouselPage()) {
                return false;
            }

            currentView.goToNextCarouselPage();

            currentView.clearLayers();
            carouselStackHeight++;
            WatchUi.pushView(currentView, self, WatchUi.SLIDE_IMMEDIATE);
            return true;
        }

        return GenericBehaviorDelegate.onNextPage();
    }

    function onPreviousPage() as Boolean {
        if (carouselVisible) {
            if (!currentView.canGoToPreviousCarouselPage()) {
                return false;
            }

            currentView.goToPreviousCarouselPage();

            currentView.clearLayers();
            carouselStackHeight--;
            WatchUi.popView(SLIDE_IMMEDIATE);
            return true;
        }

        return GenericBehaviorDelegate.onPreviousPage();
    }

    function onBack() as Boolean {
        if (carouselVisible) {
            // toggle off
            self.onSelect();
        } else {
            GenericBehaviorDelegate.onBack();
        }
        return true;
    }
}