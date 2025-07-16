import 'dart:convert';
import 'package:calendar_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HolidayService {
  static const String _calendarId = 'en.bd%23holiday@group.v.calendar.google.com';
  static const String _apiKey = 'MY_API_KEY';

  static Future<Map<DateTime, List<Event>>> loadHolidays(int year) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cached_holidays_$year';

    final cached = prefs.getString(cacheKey);
    if (cached != null) {
      return _parseHolidayJson(jsonDecode(cached));
    }

    final url =
        'https://www.googleapis.com/calendar/v3/calendars/$_calendarId/events'
        '?key=$_apiKey'
        '&timeMin=$year-01-01T00:00:00Z'
        '&timeMax=$year-12-31T23:59:59Z'
        '&singleEvents=true'
        '&orderBy=startTime';
    
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      await prefs.setString(cacheKey, response.body);
      return _parseHolidayJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch holidays for $year');
    }
  }

  static Map<DateTime, List<Event>> _parseHolidayJson(Map<String, dynamic> json) {
    final items = json['items'] as List;
    final Map<DateTime, List<Event>> holidays = {};

    for (var item in items) {
      final dateStr = item['start']['date'];
      final summary = item['summary'];
      final date = (DateTime.parse(dateStr));
      holidays.putIfAbsent(date, () => []).add(Event(title: summary));
    }

    return holidays;
  }
}
