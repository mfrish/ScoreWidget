import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class ScoreWidgetApp extends Application.AppBase {
    var scoreView;
    const watchWidth = 260;
    const watchHeight = 260;

    const fixtureSize as Number = 5;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        // first views
        var firstView = new ScoreWidgetView(watchWidth, watchHeight, fixtureSize);
        var thirdView = new PictureView(watchWidth, watchHeight);

        var firstViewDelegate;
        // only show the second view (next N fixtures) if there are fixtures
        if (firstView.allFixturesArray.size() > 0) {
            var secondView = new ScoreWidgetNextNView(watchWidth, watchHeight, firstView.allFixturesArray.slice(0, fixtureSize), firstView.crestBitmap);
            firstViewDelegate = new GenericCarouselDelegate([firstView, secondView, thirdView]);
        } else {
            firstViewDelegate = new GenericBehaviorDelegate([firstView, thirdView]);
        }

        return [ firstView, firstViewDelegate ];
    }

    (:glance)
    function getGlanceView() {
        return [ new ScoreWidgetGlanceView() ];
    }
}

function getApp() as ScoreWidgetApp {
    return Application.getApp() as ScoreWidgetApp;
}