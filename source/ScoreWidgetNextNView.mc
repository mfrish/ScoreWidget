import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Time;
import Toybox.WatchUi;

class ScoreWidgetNextNView extends GenericCarouselView {
    var _backgroundLayer;
    var _foregroundLayer;
    var watchWidth as Number;
    var watchHeight as Number;

    // some magic numbers here with bitmap of 20 pixels high determined by trial and error
    const backgroundBitmapWidthRatio = 40;
    const initialTextBackgroundYEven = 73;
    const initialTextBackgroundYOdd = 57;
    const yIncrement = 32;

    var crestBitmap as BitmapResource;
    var leagueTextBackgroundBitmap as BitmapResource;
    var cupComp1TextBackgroundBitmap as BitmapResource;
    var cupComp2TextBackgroundBitmap as BitmapResource;
    var fixtureList as Array<Fixture>;
    var numOfPages as Number;

    const maxFixturesPerPage = 5;
    const leftJustified = false;

    function initialize(watchWidthInput as Number, watchHeightInput as Number, fixtureListInput as Array<Fixture>, crestBitmapInput as BitmapResource) {
        watchWidth = watchWidthInput;
        watchHeight = watchHeightInput;
        numOfPages = Math.ceil(fixtureListInput.size() / maxFixturesPerPage.toFloat()).toNumber();
        GenericCarouselView.initialize(numOfPages);

        _backgroundLayer = new WatchUi.Layer({:x=>0, :y=>0, :width=>watchWidth, :height=>watchHeight});
        _foregroundLayer = new WatchUi.Layer({:x=>0, :y=>0, :width=>watchWidth, :height=>watchHeight});

        fixtureList = fixtureListInput;
        crestBitmap = crestBitmapInput;
        leagueTextBackgroundBitmap = Application.loadResource($.Rez.Drawables.LeagueTextBackground);
        cupComp1TextBackgroundBitmap = Application.loadResource($.Rez.Drawables.CupComp1TextBackground);
        cupComp2TextBackgroundBitmap = Application.loadResource($.Rez.Drawables.CupComp2TextBackground);

        currentPage = 0;
    }

    function onLayout(dc) {
    }

    function onShow() {
        addLayer(_backgroundLayer);
        addLayer(_foregroundLayer);
    }

    function onUpdate(dc) {
        View.onUpdate(dc);

        var backgroundDc = _backgroundLayer.getDc();
        var foregroundDc = _foregroundLayer.getDc();

        if (fixtureList.size() == 0) {
            backgroundDc.clear();
            foregroundDc.clear();
            foregroundDc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            foregroundDc.drawText(foregroundDc.getWidth() / 2, foregroundDc.getHeight() / 2, Graphics.FONT_SMALL, "No new fixtures", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            return;
        }

        // draw crest in background
        backgroundDc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        backgroundDc.clear();
        backgroundDc.drawBitmap(backgroundDc.getWidth() / backgroundBitmapWidthRatio, (backgroundDc.getHeight() / 2) - (crestBitmap.getHeight() / 2), crestBitmap);

        // get initial textBackground coordinates
        var startFixtureIndex = currentPage * maxFixturesPerPage;
        var endFixtureIndex = startFixtureIndex + maxFixturesPerPage < fixtureList.size() ? startFixtureIndex + maxFixturesPerPage : fixtureList.size();
        var fixturePageSize = endFixtureIndex - startFixtureIndex;
        var textBackgroundX = watchWidth - leagueTextBackgroundBitmap.getWidth() - (foregroundDc.getWidth() / 10);
        var initialTextBackgroundY = (fixturePageSize % 2 == 0 ? initialTextBackgroundYEven : initialTextBackgroundYOdd) + Math.floor((maxFixturesPerPage - fixturePageSize) / 2) * yIncrement;

        var timeString = "";
        var currTextBackgroundY = initialTextBackgroundY;
        for (var i = startFixtureIndex; i < endFixtureIndex; i++) {
            if (i != startFixtureIndex) {
                timeString += "\n";
            }
            var nextFixture = fixtureList[i] as Fixture;
            if (nextFixture.postponed) {
                timeString += Lang.format(
                    "$1$$2$, PP",
                    [
                        nextFixture.getHomeString(),
                        nextFixture.teamShort != null ? nextFixture.teamShort : nextFixture.team
                    ]
                );
            } else {
                timeString += Lang.format(
                    "$1$$2$, $3$ $4$/$5$",
                    [
                        nextFixture.getHomeString(),
                        nextFixture.teamShort != null ? nextFixture.teamShort : nextFixture.team,
                        TimeHelper.getAbbrevDayOfWeek(nextFixture.dateShort.day_of_week),
                        nextFixture.dateShort.month,
                        nextFixture.dateShort.day,
                    ]
                );
            }

            // draw fixture textBackground
            backgroundDc.drawBitmap(textBackgroundX, currTextBackgroundY, getCompetitionTextBackgroundBitmap(nextFixture));
            currTextBackgroundY += yIncrement;
        }

        // draw fixture list
        foregroundDc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        foregroundDc.clear();
        // used if left justified text is wanted
        if (leftJustified)
        {
            foregroundDc.drawText(foregroundDc.getWidth() / 3, foregroundDc.getHeight() / 2, Graphics.FONT_TINY, timeString, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        } else {
            foregroundDc.drawText(9 * foregroundDc.getWidth() / 10, foregroundDc.getHeight() / 2, Graphics.FONT_TINY, timeString, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        drawCarousel(foregroundDc);
    }

    function onHide() {
    }

    private function getCompetitionTextBackgroundBitmap(fixtureObject) {
        if (fixtureObject.comp.equals(LEAGUE)) {
            return leagueTextBackgroundBitmap;
        } else if (fixtureObject.comp.equals(CUPCOMP1)) {
            return cupComp1TextBackgroundBitmap;
        } else if (fixtureObject.comp.equals(CUPCOMP2)) {
            return cupComp2TextBackgroundBitmap;
        } else {
            return null;
        }
    }
}
