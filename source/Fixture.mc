import Toybox.Lang;
import Toybox.Time;

class Fixture {
    var home as Boolean;
    var team as String;
    var teamShort as String;
    var comp as Number;
    var dateShort;
    var dateMedium;
    var postponed as Boolean;
    var timeTbd as Boolean;
    private var timeString as String;

    function initialize(scheduleObject, competition as Number) {
        home = scheduleObject["home"];
        team = scheduleObject["team"];
        // length limit should be 6 characters
        teamShort = scheduleObject["teamShort"] != null ? scheduleObject["teamShort"] : team.substring(0, 6);
        comp = competition;
        postponed = scheduleObject["month"] == null;
        timeTbd = scheduleObject["hour"] == null;
        dateShort = TimeHelper.getTimeFromObject(scheduleObject, Time.FORMAT_SHORT);
        dateMedium = TimeHelper.getTimeFromObject(scheduleObject, Time.FORMAT_MEDIUM);
        timeString = "";
    }

    function getHomeString() {
        return home ? "" : "@";
    }

    function getDayString() {
        var day = dateShort.day;
        if (day == 1) {
            return "1st";
        } else if (day == 2) {
            return "2nd";
        } else if (day == 3) {
            return "3rd";
        }
        return day + "th";
    }

    function getTimeString() {
        if (timeString != null && !timeString.equals("")) {
            return timeString;
        }

        if (timeTbd) {
            return "TBD";
        }

        var hour = dateShort.hour;
        var minute = dateShort.min;
        var is24Hour = System.getDeviceSettings().is24Hour;
        var finalString = "";
        var isAm = true;

        if (is24Hour) {
            finalString += hour.format("%02u");
        } else {
            if (hour > 11) {
                isAm = false;
            }

            hour = hour % 12;
            if (hour == 0) {
                hour = 12;
            }
            finalString += hour;
        }

        if (is24Hour || minute != 0) {
            finalString += ":";
            finalString += minute.format("%02u");
        }

        if (!is24Hour) {
            if (isAm) {
                finalString += "am";
            } else {
                finalString += "pm";
            }
        }

        timeString = finalString;
        return finalString;
    }

    static function getNextFixtures(
        competitionArray as Array<Array<Fixture>>,
        compEnumArray as Array<Number>,
        nicknames
        ) as Array<Fixture> {
        var nextN = [] as Array<Fixture>;

        var nextIndexArray = [] as Array<Number>;
        var now = Time.today();
        for (var i = 0; i < competitionArray.size(); i++) {
            nextIndexArray.add(getNextFixtureIndex(competitionArray[i], now));
        }

        while (true) {
            var nextFixture = null;
            var nextMoment = null;
            var nextComp = null;
            var nextCompIndex = null;

            for (var j=0; j < competitionArray.size(); j++) {
                var competition = competitionArray[j];
                var nextIndex = nextIndexArray[j];
                if (nextIndex != -1 && nextIndex < competition.size()) {
                    var nextCompFixture = competition[nextIndex];
                    var newMoment = TimeHelper.getMomentFromObject(nextCompFixture);
                    if (nextMoment == null || newMoment.lessThan(nextMoment)) {
                        nextFixture = nextCompFixture;
                        nextMoment = newMoment;
                        nextComp = compEnumArray[j];
                        nextCompIndex = j;

                        // short name should be 6 characters max
                        if (nicknames[nextFixture["team"]] != null) {
                            nextFixture["teamShort"] = nicknames[nextFixture["team"]];
                        }
                    }
                }
            }
            
            if (nextMoment == null) {
                return nextN;
            }

            nextIndexArray[nextCompIndex]++;
            nextN.add(new Fixture(nextFixture, nextComp));
        }

        return nextN;
    }

    static function getNextFixtureIndex(scheduleArray as Array<Fixture>, timeComparison as Moment) as Integer {
        var i = 0;
        var j = scheduleArray.size() - 1;

        if (j == - 1 || timeComparison.greaterThan(TimeHelper.getMomentFromObject(scheduleArray[j]))) {
            return -1;
        }

        var m = 0;
        while (i < j) {
            m = (j + i)/2;
            var mTime = TimeHelper.getMomentFromObject(scheduleArray[m]);
            if (timeComparison.greaterThan(mTime)) {
                i = m + 1;
            } else {
                j = m;
            }
        }

        return i;
    }
}