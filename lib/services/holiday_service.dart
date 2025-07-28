import 'dart:convert';
import 'dart:ui';
import 'package:calendar_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HolidayService {
  static String get _calendarId => getCalendarIdFromLocale();
  static const String _apiKey = 'Your_API_KEY';

  static Future<List<Event>> loadHolidays(int year) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cached_holidays_$year';

    final cached = prefs.getString(cacheKey);
    if (cached != null) {
      return _parseHolidayJson(jsonDecode(cached));
    }
    prefs.remove('cached_holidays_${year - 1}');

    final fallbackUrl =
        'https://www.googleapis.com/calendar/v3/calendars/en.us%23holiday@group.v.calendar.google.com/events'
        '?key=$_apiKey'
        '&timeMin=$year-01-01T00:00:00Z'
        '&timeMax=$year-12-31T23:59:59Z'
        '&singleEvents=true'
        '&orderBy=startTime';
    final url =
        'https://www.googleapis.com/calendar/v3/calendars/$_calendarId/events'
        '?key=$_apiKey'
        '&timeMin=$year-01-01T00:00:00Z'
        '&timeMax=$year-12-31T23:59:59Z'
        '&singleEvents=true'
        '&orderBy=startTime';
    
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      await prefs.setString(cacheKey, response.body);
      return _parseHolidayJson(jsonDecode(response.body));
    } else {
      response = await http.get(Uri.parse(fallbackUrl));

      if (response.statusCode == 200) {
        await prefs.setString(cacheKey, response.body);
        return _parseHolidayJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch holidays for $year');
      }
    }
  }

  static List<Event> _parseHolidayJson(Map<String, dynamic> json) {
    final items = json['items'] as List;
    final List<Event> holidays = [];

    for (var item in items) {
      final startDateStr = item['start']['date'];
      final endDateStr = item['end']['date'];
      final summary = item['summary'];
      final startDate = (DateTime.parse(startDateStr));
      final endDate = (DateTime.parse(endDateStr));
      holidays.add(Event(
        title: summary,
        isHoliday: true,
        startTime: startDate,
        endTime: endDate,
      ));
    }

    return holidays;
  }

  static String getCalendarIdFromLocale() {
    final country = PlatformDispatcher.instance.locale.countryCode?.toLowerCase() ?? 'us';
    final language = PlatformDispatcher.instance.locale.languageCode.toLowerCase();

    return '$language.$country%23holiday@group.v.calendar.google.com';
  }
}
