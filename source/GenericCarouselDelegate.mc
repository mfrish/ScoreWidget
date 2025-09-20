import Toybox.Lang;
import Toybox.WatchUi;

class GenericCarouselDelegate extends GenericBehaviorDelegate {
    var carouselVisible;
    var currentViewArray as Array<View or GenericCarouselView>;
    var currentIndex as Number;

    function initialize(viewArray as Array<View or GenericCarouselView>) {
        GenericBehaviorDelegate.initialize(viewArray);
        carouselVisible = false;
        currentViewArray = viewArray;
        currentIndex = 0;
    }

    function onSelect() as Boolean {
        // toggle carousel on select
        if (currentViewArray[currentIndex].isCarouselView) {
            if (carouselVisible) {
                carouselVisible = false;
                currentViewArray[currentIndex].showCarousel = false;
                currentViewArray[currentIndex].resetCarousel();
                currentViewArray[currentIndex].clearLayers();
                WatchUi.switchToView(currentViewArray[currentIndex], self, WatchUi.SLIDE_IMMEDIATE);
            } else {
                carouselVisible = true;
                currentViewArray[currentIndex].showCarousel = true;
                currentViewArray[currentIndex].clearLayers();
                WatchUi.switchToView(currentViewArray[currentIndex], self, WatchUi.SLIDE_IMMEDIATE);
            }
        }

        return true;
    }

    function onNextPage() as Boolean {
        if (carouselVisible) {
            if (!currentViewArray[currentIndex].canGoToNextCarouselPage()) {
                return false;
            }

            currentViewArray[currentIndex].goToNextCarouselPage();

            currentViewArray[currentIndex].clearLayers();

            WatchUi.switchToView(currentViewArray[currentIndex], self, WatchUi.SLIDE_IMMEDIATE);
            return true;
        }

        return GenericBehaviorDelegate.onNextPage();
    }

    function onPreviousPage() as Boolean {
        if (carouselVisible) {
            if (!currentViewArray[currentIndex].canGoToPreviousCarouselPage()) {
                return false;
            }

            currentViewArray[currentIndex].goToPreviousCarouselPage();

            currentViewArray[currentIndex].clearLayers();
            WatchUi.switchToView(currentViewArray[currentIndex], self, SLIDE_IMMEDIATE);
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