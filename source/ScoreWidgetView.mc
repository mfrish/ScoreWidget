import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class ScoreWidgetView extends GenericCarouselView {

    var _backgroundLayer;
    var _foregroundLayer;

    const fixtureSize as Number = 5;

    var crestBitmap as BitmapResource;
    var leagueBitmap as BitmapResource;
    var cupComp1Bitmap as BitmapResource;
    var cupComp2Bitmap as BitmapResource;
    var allFixturesArray as Array<Fixture>;

    function initialize(watchWidth as Number, watchHeight as Number) {
        _backgroundLayer = new WatchUi.Layer({:x=>0, :y=>0, :width=>watchWidth, :height=>watchHeight});
        _foregroundLayer = new WatchUi.Layer({:x=>0, :y=>0, :width=>watchWidth, :height=>watchHeight});

        crestBitmap = Application.loadResource($.Rez.Drawables.Crest);
        leagueBitmap = Application.loadResource($.Rez.Drawables.League);
        cupComp1Bitmap = Application.loadResource($.Rez.Drawables.CupComp1);
        cupComp2Bitmap= Application.loadResource($.Rez.Drawables.CupComp2);
        var leagueScheduleArray = Application.loadResource($.Rez.JsonData.leagueScheduleFile);
        var cupComp1ScheduleArray = Application.loadResource($.Rez.JsonData.cupComp1ScheduleFile);
        var cupComp2ScheduleArray = Application.loadResource($.Rez.JsonData.cupComp2ScheduleFile);
        var nicknames = Application.loadResource($.Rez.JsonData.nicknames);
        allFixturesArray = Fixture.getNextFixtures(
            [leagueScheduleArray, cupComp1ScheduleArray, cupComp2ScheduleArray],
            [LEAGUE, CUPCOMP1, CUPCOMP2],
            nicknames);

        GenericCarouselView.initialize(allFixturesArray.size() < fixtureSize ? allFixturesArray.size() : fixtureSize);
    }

    function onLayout(dc as Dc) as Void {
    }

    function onShow() as Void {
        addLayer(_backgroundLayer);
        addLayer(_foregroundLayer);
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        var backgroundDc = _backgroundLayer.getDc();
        var foregroundDc = _foregroundLayer.getDc();

        if (allFixturesArray.size() == 0) {
            backgroundDc.clear();
            foregroundDc.clear();
            foregroundDc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            foregroundDc.drawText(foregroundDc.getWidth() / 2, foregroundDc.getHeight() / 2, Graphics.FONT_MEDIUM, "No new fixtures", Graphics.TEXT_JUSTIFY_CENTER |  Graphics.TEXT_JUSTIFY_VCENTER);
            return;
        }

        var nextFixture = allFixturesArray[currentPage] as Fixture;

        // draw competition in background
        var compBitmap = getCompetitionBitmap(nextFixture);
        if (compBitmap != null) {
            backgroundDc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            backgroundDc.clear();
            backgroundDc.drawBitmap(0, 0, compBitmap);
        }

        // draw crest
        foregroundDc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        foregroundDc.clear();
        foregroundDc.drawBitmap(
            foregroundDc.getWidth() / 2 - (crestBitmap.getWidth() / 2),
            foregroundDc.getHeight() / 10,
            crestBitmap
        );

        var timeString;
        if (nextFixture.postponed) {
            timeString = Lang.format(
                "$1$$2$\nPostponed\n$3$",
                [
                    nextFixture.getHomeString(),
                    nextFixture.team,
                    nextFixture.getTimeString()
                ]
            );
        } else {
            timeString = Lang.format(
                "$1$$2$\n$3$, $4$ $5$\n$6$",
                [
                    nextFixture.getHomeString(),
                    nextFixture.team,
                    nextFixture.dateMedium.day_of_week,
                    nextFixture.dateMedium.month,
                    nextFixture.getDayString(),
                    nextFixture.getTimeString()
                ]
            );
        }

        foregroundDc.drawText(foregroundDc.getWidth() / 2, foregroundDc.getHeight() / 2, Graphics.FONT_SMALL, timeString, Graphics.TEXT_JUSTIFY_CENTER);

        self.drawCarousel(foregroundDc);
    }

    function onHide() as Void {
    }

    private function getCompetitionBitmap(fixtureObject) {
        if (fixtureObject.comp.equals(LEAGUE)) {
            return leagueBitmap;
        } else if (fixtureObject.comp.equals(CUPCOMP1)) {
            return cupComp1Bitmap;
        } else if (fixtureObject.comp.equals(CUPCOMP2)) {
            return cupComp2Bitmap;
        } else {
            return null;
        }
    }
}

