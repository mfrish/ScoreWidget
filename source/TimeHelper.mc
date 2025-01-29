import Toybox.Lang;
import Toybox.System;
import Toybox.Time;

class TimeHelper {
    static function getTimeFromObject(fixtureObject, timeFormat) {
        return Gregorian.info(getMomentFromObject(fixtureObject), timeFormat);
    }

    static function getMomentFromObject(fixtureObject) {
        var dayValue = fixtureObject["day"] as Number;
        var hourValue = fixtureObject["hour"] as Number;
        if (hourValue == null) {
            // make sure TBD sets to the correct day due to time zone
            var hourOffset = System.getClockTime().timeZoneOffset / 3600;
            if (hourOffset > 0) {
                dayValue--;
            }
            hourValue = hourOffset.abs();
        }

        var time = {
            :year => fixtureObject["year"] as Number,
            :month => fixtureObject["month"] as Number,
            :day => dayValue,
            :hour => hourValue,
            :minute => fixtureObject["min"] as Number,
        };

        return Gregorian.moment(time);
    }

    static function getAbbrevDayOfWeek(day as Number) {
        if (day.equals(7)) {
            return "Sa";
        } else if (day.equals(1)) {
            return "Su";
        } else if (day.equals(2)) {
            return "M";
        } else if (day.equals(3)) {
            return "T";
        } else if (day.equals(4)) {
            return "W";
        } else if (day.equals(5)) {
            return "Th";
        } else if (day.equals(6)) {
            return "F";
        }
        return day;
    }
}