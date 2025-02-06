import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../location/location_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final Random _random = Random();
  final LocationService _locationService = LocationService();

  final List<String> _motivationMessages = [
    'Bugün harika bir gün olacak! 🌟',
    'Kendine inanmak başarının ilk adımıdır 💪',
    'Her yeni gün, yeni bir başlangıçtır 🌅',
    'Küçük adımlar büyük değişimlere yol açar 🚶‍♂️',
    'Bugün kendine iyi davranmayı unutma 💝',
    'Sen yapabilirsin! 🎯',
    'Hedeflerine bir adım daha yaklaştın 🎊',
    'Başarı senin karakterinin bir parçası 🌟',
    'Zorluklar seni daha güçlü yapar 💪',
    'Her şey senin elinde! ✨',
    'Bugün kendini şaşırtma zamanı 🎉',
    'İyi ki varsın! 💫',
  ];

  final List<String> _homeMessages = [
    'Hoş geldin! Bugün su içmeyi unutma 💧',
    'Eve hoş geldin! Biraz dinlenmeye ne dersin? 🏠',
    'Evde egzersiz yapmak için harika bir zaman! 🏋️‍♂️',
    'Meditasyon için sakin bir ortamdasın 🧘‍♂️',
    'Günün nasıl geçti? Duygularını kaydetmeye ne dersin? 📝',
  ];

  final List<String> _outsideMessages = [
    'Güzel bir gün seni bekliyor! Yürüyüş yapmayı unutma 🚶‍♂️',
    'Dışarıdayken su içmeyi ihmal etme 💧',
    'Bugün biraz hareket etmeye ne dersin? 🏃‍♂️',
    'Güneşli bir gün! D vitamini almayı unutma ☀️',
    'Derin nefes al ve günün tadını çıkar 🌟',
  ];

  final List<String> _periodMessages = [
    'Adet döneminiz yaklaşıyor. Kendinize iyi bakın! 💝',
    'Adet döneminiz 2 gün içinde başlayacak. Hazırlıklı olun! 🌸',
    'Döngünüzü takip etmeyi unutmayın 📝',
    'Kendinize ekstra özen gösterme zamanı! ❤️',
  ];

  Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    
    // Konum servisini başlat
    await _locationService.initialize();
    _locationService.onLocationStatusChanged = _handleLocationChange;
    
    // İlk motivasyon bildirimini planla
    await scheduleMotivationNotification();
  }

  void _handleLocationChange(bool isAtHome) {
    if (isAtHome) {
      _showLocationBasedNotification(
        'Konum Bildirimi',
        _homeMessages[_random.nextInt(_homeMessages.length)],
        2, // Home notification ID
      );
    } else {
      _showLocationBasedNotification(
        'Konum Bildirimi',
        _outsideMessages[_random.nextInt(_outsideMessages.length)],
        3, // Outside notification ID
      );
    }
  }

  Future<void> _showLocationBasedNotification(
    String title,
    String body,
    int notificationId,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'location_channel',
      'Konum Bildirimleri',
      channelDescription: 'Konum bazlı bildirimler',
      importance: Importance.high,
      priority: Priority.high,
      enableLights: true,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      notificationId,
      title,
      body,
      notificationDetails,
    );
  }

  String _getRandomMotivationMessage() {
    return _motivationMessages[_random.nextInt(_motivationMessages.length)];
  }

  Future<void> scheduleMotivationNotification() async {
    // Sabah 9:00'da bildirim gönder
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      9, // saat
      0, // dakika
    );

    // Eğer saat 9:00'u geçtiyse, bir sonraki güne planla
    if (now.isAfter(scheduledDate)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'motivation_channel',
      'Motivasyon Bildirimleri',
      channelDescription: 'Günlük motivasyon mesajları',
      importance: Importance.high,
      priority: Priority.high,
      enableLights: true,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      1, // Uyku bildirimleri için 0 kullandığımızdan, motivasyon için 1 kullanıyoruz
      'Günlük Motivasyon',
      _getRandomMotivationMessage(),
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Her gün aynı saatte tekrarla
    );
  }

  Future<void> scheduleSleepReminder(DateTime bedTime) async {
    final reminderTime = bedTime.subtract(const Duration(minutes: 30));
    
    if (reminderTime.isBefore(DateTime.now())) {
      // If reminder time is in the past, schedule for next day
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final nextReminder = DateTime(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        bedTime.hour,
        bedTime.minute,
      ).subtract(const Duration(minutes: 30));
      
      await _scheduleNotification(nextReminder);
    } else {
      await _scheduleNotification(reminderTime);
    }
  }

  Future<void> _scheduleNotification(DateTime scheduledTime) async {
    const androidDetails = AndroidNotificationDetails(
      'sleep_reminder',
      'Uyku Hatırlatıcısı',
      channelDescription: 'Uyku saati hatırlatmaları',
      importance: Importance.high,
      priority: Priority.high,
      enableLights: true,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      0,
      'Uyku Zamanı Yaklaşıyor',
      'Yatma vaktinize 30 dakika kaldı. Hazırlanmaya başlayabilirsiniz.',
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Ev konumunu ayarla
  Future<void> setHomeLocation() async {
    await _locationService.setHomeLocation();
  }

  Future<void> schedulePeriodNotification(DateTime nextPeriod) async {
    final notificationDate = nextPeriod.subtract(const Duration(days: 2));
    
    if (notificationDate.isBefore(DateTime.now())) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'period_channel',
      'Adet Döngüsü Bildirimleri',
      channelDescription: 'Adet döngüsü hatırlatmaları',
      importance: Importance.high,
      priority: Priority.high,
      enableLights: true,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      4, // Unique ID for period notifications
      'Adet Döngüsü Hatırlatması',
      _periodMessages[_random.nextInt(_periodMessages.length)],
      tz.TZDateTime.from(notificationDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
} 