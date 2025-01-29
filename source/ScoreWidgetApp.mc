import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class ScoreWidgetApp extends Application.AppBase {
    var scoreView;
    const watchWidth = 260;
    const watchHeight = 260;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as Array<Views or InputDelegates>? {
        // first views
        var firstView = new ScoreWidgetView(watchWidth, watchHeight);
        var thirdView = new PictureView(watchWidth, watchHeight);
        var thirdViewDelegate = new GenericBehaviorDelegate(thirdView, null, thirdView);

        var firstViewDelegate;
        // only show the second view (next N fixtures) if there are fixtures
        if (firstView.allFixturesArray.size() > 0) {
            var secondView = new ScoreWidgetNextNView(watchWidth, watchHeight, firstView.allFixturesArray, firstView.crestBitmap);
            var secondViewDelegate = new GenericCarouselDelegate(secondView, [thirdView, thirdViewDelegate], firstView);
            firstViewDelegate = new GenericCarouselDelegate(firstView, [secondView, secondViewDelegate], null);
        } else {
            firstViewDelegate = new GenericBehaviorDelegate(firstView, [thirdView, thirdViewDelegate], null);
        }

        return [ firstView, firstViewDelegate ] as Array<Views or InputDelegates>?;
    }

    (:glance)
    function getGlanceView() {
        return [ new ScoreWidgetGlanceView() ];
    }
}

function getApp() as ScoreWidgetApp {
    return Application.getApp() as ScoreWidgetApp;
}