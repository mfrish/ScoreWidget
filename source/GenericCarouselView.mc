import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class GenericCarouselView extends WatchUi.View {
    var showCarousel as Boolean = false;
    var maxPagesInCarousel as Number = 8;
    var currentCarouselIndex as Number = 0;
    var currentPage as Number = 0;
    var numOfPages as Number;

    var pixelsFromRight as Number = 20;
    var iconLengthX as Number = 2;
    var iconLengthY as Number = 8;
    var iconSelectedLengthX as Number = 6;
    var iconSelectedLengthY as Number = 8;
    var spacing as Number = 6;

    function initialize(numOfPagesInput as Number) {
        View.initialize();

        numOfPages = numOfPagesInput;
    }

    function drawCarousel(dc as Dc) {
        if (showCarousel) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);

            var startX = dc.getWidth() - pixelsFromRight;

            var numIconsToDraw = numOfPages < maxPagesInCarousel ? numOfPages : maxPagesInCarousel;
            var startY = numIconsToDraw % 2 == 0 ?
            (dc.getHeight() / 2) - (spacing / 2) - Math.floor(numIconsToDraw / 2) * iconLengthY - (Math.floor(numOfPages / 2) - 1) * spacing
            : (dc.getHeight() / 2) - (iconLengthY / 2) - Math.floor(numIconsToDraw / 2) * Math.floor(iconLengthY + spacing);

            for (var i = 0; i < numIconsToDraw; i++) {
                if (i == currentCarouselIndex) {
                    dc.fillPolygon([[startX, startY], [startX - iconSelectedLengthX, startY], [startX - iconSelectedLengthX, startY + iconSelectedLengthY], [startX, startY + iconSelectedLengthY]]);
                } else {
                    dc.fillPolygon([[startX, startY], [startX - iconLengthX, startY], [startX - iconLengthX, startY + iconLengthY], [startX, startY + iconLengthY]]);
                }
                startY += spacing + iconLengthY;
            }
        }
    }

    function resetCarousel() {
        currentPage = 0;
        currentCarouselIndex = 0;
    }

    function canGoToNextCarouselPage() {
        return currentPage < numOfPages - 1;
    }

    function canGoToPreviousCarouselPage() {
        return currentPage > 0;
    }

    function goToNextCarouselPage() {
        if (currentCarouselIndex != maxPagesInCarousel - 2 || currentPage + 2 == numOfPages) {
            currentCarouselIndex++;
        }
        currentPage++;
    }

    function goToPreviousCarouselPage() {
        if (currentCarouselIndex != 1 || currentPage == 1) {
            currentCarouselIndex--;
        }
        currentPage--;
    }
}