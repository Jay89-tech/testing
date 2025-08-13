// lib/utils/helpers/date_helper.dart
import 'package:intl/intl.dart';

class DateHelper {
  // Date Formats
  static const String defaultDateFormat = 'dd/MM/yyyy';
  static const String defaultDateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';
  static const String monthYearFormat = 'MMM yyyy';
  static const String fullDateFormat = 'EEEE, dd MMMM yyyy';
  static const String shortDateFormat = 'dd MMM yyyy';
  static const String isoDateFormat = 'yyyy-MM-dd';
  static const String isoDateTimeFormat = 'yyyy-MM-ddTHH:mm:ss';

  // Format date to string
  static String formatDate(DateTime date, {String format = defaultDateFormat}) {
    try {
      return DateFormat(format).format(date);
    } catch (e) {
      return DateFormat(defaultDateFormat).format(date);
    }
  }

  // Format date with time to string
  static String formatDateTime(DateTime dateTime, {String format = defaultDateTimeFormat}) {
    try {
      return DateFormat(format).format(dateTime);
    } catch (e) {
      return DateFormat(defaultDateTimeFormat).format(dateTime);
    }
  }

  // Format time only
  static String formatTime(DateTime time, {String format = timeFormat}) {
    try {
      return DateFormat(format).format(time);
    } catch (e) {
      return DateFormat(timeFormat).format(time);
    }
  }

  // Parse string to date
  static DateTime? parseDate(String dateString, {String format = defaultDateFormat}) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      // Try alternative formats
      final formats = [
        defaultDateFormat,
        isoDateFormat,
        shortDateFormat,
        'yyyy-MM-dd HH:mm:ss',
        'dd-MM-yyyy',
        'MM/dd/yyyy',
      ];
      
      for (final fmt in formats) {
        try {
          return DateFormat(fmt).parse(dateString);
        } catch (_) {
          continue;
        }
      }
      return null;
    }
  }

  // Get relative time (e.g., "2 hours ago", "3 days ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return '1 day ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return months == 1 ? '1 month ago' : '$months months ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return years == 1 ? '1 year ago' : '$years years ago';
      }
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 ? '1 minute ago' : '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  // Get time until expiry (e.g., "expires in 5 days")
  static String getTimeUntilExpiry(DateTime expiryDate) {
    final now = DateTime.now();
    final difference = expiryDate.difference(now);

    if (difference.isNegative) {
      return 'Expired';
    }

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Expires tomorrow';
      } else if (difference.inDays < 7) {
        return 'Expires in ${difference.inDays} days';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return weeks == 1 ? 'Expires in 1 week' : 'Expires in $weeks weeks';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return months == 1 ? 'Expires in 1 month' : 'Expires in $months months';
      } else {
        final years = (difference.inDays / 365).floor();
        return years == 1 ? 'Expires in 1 year' : 'Expires in $years years';
      }
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 
          ? 'Expires in 1 hour' 
          : 'Expires in ${difference.inHours} hours';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 
          ? 'Expires in 1 minute' 
          : 'Expires in ${difference.inMinutes} minutes';
    } else {
      return 'Expires soon';
    }
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  // Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }

  // Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }

  // Check if date is in current week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
           date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  // Check if date is in current month
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  // Check if date is in current year
  static bool isThisYear(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year;
  }

  // Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  // Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  // Get end of week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    return date.add(Duration(days: 7 - date.weekday));
  }

  // Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  // Get end of month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  // Get start of year
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  // Get end of year
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, 23, 59, 59, 999);
  }

  // Add business days (excluding weekends)
  static DateTime addBusinessDays(DateTime date, int days) {
    DateTime result = date;
    int remainingDays = days;
    
    while (remainingDays > 0) {
      result = result.add(const Duration(days: 1));
      if (result.weekday < 6) { // Monday = 1, Sunday = 7
        remainingDays--;
      }
    }
    
    return result;
  }

  // Get number of business days between two dates
  static int businessDaysBetween(DateTime startDate, DateTime endDate) {
    if (startDate.isAfter(endDate)) {
      return 0;
    }
    
    int businessDays = 0;
    DateTime current = startDate;
    
    while (current.isBefore(endDate)) {
      if (current.weekday < 6) { // Monday = 1, Sunday = 7
        businessDays++;
      }
      current = current.add(const Duration(days: 1));
    }
    
    return businessDays;
  }

  // Check if date is weekend
  static bool isWeekend(DateTime date) {
    return date.weekday >= 6; // Saturday = 6, Sunday = 7
  }

  // Check if date is weekday
  static bool isWeekday(DateTime date) {
    return date.weekday < 6; // Monday = 1, Friday = 5
  }

  // Get age from birth date
  static int getAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    
    if (today.month < birthDate.month || 
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }

  // Get days until birthday
  static int daysUntilBirthday(DateTime birthDate) {
    final today = DateTime.now();
    DateTime birthday = DateTime(today.year, birthDate.month, birthDate.day);
    
    if (birthday.isBefore(today)) {
      birthday = DateTime(today.year + 1, birthDate.month, birthDate.day);
    }
    
    return birthday.difference(today).inDays;
  }

  // Get quarter of year
  static int getQuarter(DateTime date) {
    return ((date.month - 1) ~/ 3) + 1;
  }

  // Get week number of year
  static int getWeekOfYear(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final days = date.difference(startOfYear).inDays;
    return (days / 7).ceil();
  }

  // Format duration to human readable string
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays == 1 ? '' : 's'}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours == 1 ? '' : 's'}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minute${duration.inMinutes == 1 ? '' : 's'}';
    } else {
      return '${duration.inSeconds} second${duration.inSeconds == 1 ? '' : 's'}';
    }
  }

  // Check if skill is expiring soon (within 30 days)
  static bool isExpiringSoon(DateTime? expiryDate) {
    if (expiryDate == null) return false;
    final now = DateTime.now();
    final difference = expiryDate.difference(now).inDays;
    return difference <= 30 && difference > 0;
  }

  // Check if skill is expired
  static bool isExpired(DateTime? expiryDate) {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate);
  }

  // Get smart date display (Today, Yesterday, or formatted date)
  static String getSmartDateDisplay(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isYesterday(date)) {
      return 'Yesterday';
    } else if (isTomorrow(date)) {
      return 'Tomorrow';
    } else if (isThisWeek(date)) {
      return DateFormat('EEEE').format(date); // Day name
    } else if (isThisYear(date)) {
      return DateFormat('dd MMM').format(date);
    } else {
      return formatDate(date);
    }
  }

  // Create date range string
  static String formatDateRange(DateTime startDate, DateTime endDate) {
    if (startDate.year == endDate.year) {
      if (startDate.month == endDate.month) {
        return '${startDate.day}-${endDate.day} ${DateFormat('MMM yyyy').format(startDate)}';
      } else {
        return '${DateFormat('dd MMM').format(startDate)} - ${DateFormat('dd MMM yyyy').format(endDate)}';
      }
    } else {
      return '${formatDate(startDate)} - ${formatDate(endDate)}';
    }
  }

  // Get fiscal year (April to March for South Africa)
  static String getFiscalYear(DateTime date) {
    if (date.month >= 4) {
      return '${date.year}/${date.year + 1}';
    } else {
      return '${date.year - 1}/${date.year}';
    }
  }

  // Check if date is in current fiscal year
  static bool isCurrentFiscalYear(DateTime date) {
    final now = DateTime.now();
    return getFiscalYear(date) == getFiscalYear(now);
  }
}