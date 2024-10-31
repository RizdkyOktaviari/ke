class Reminder {
  final String title;
  final String message;
  final String reminderDate;
  final String reminderTime;
  final String type;
  final String status;

  Reminder({
    required this.title,
    required this.message,
    required this.reminderDate,
    required this.reminderTime,
    required this.type,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    // Convert emoji title to clean type
    String cleanType = '';
    switch (type) {
      case '🍳 Sarapan':
        cleanType = 'breakfast';
        break;
      case '🥗 Makan Siang':
        cleanType = 'lunch';
        break;
      case '🥣 Makan Malam':
        cleanType = 'dinner';
        break;
      case '🍪 Cemilan':
        cleanType = 'snack';
        break;
      case '🥤 Minum':
        cleanType = 'drink';
        break;
      case '🏃 Aktivitas Fisik':
        cleanType = 'exercise';
        break;
      case '💊 Minum Obat':
        cleanType = 'medicine';
        break;
      case '📚 Membaca Pengetahuan':
        cleanType = 'reading';
        break;
      default:
        cleanType = type.toLowerCase();
    }

    // Get just the text part without emoji
    String cleanTitle = type.split(' ').last.toLowerCase();

    return {
      'title': cleanTitle,
      'message': message,
      'reminder_date': reminderDate,
      'reminder_time': reminderTime,
      'type': cleanType,
      'status': status,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      title: json['title'],
      message: json['message'],
      reminderDate: json['reminder_date'],
      reminderTime: json['reminder_time'],
      type: json['type'],
      status: json['status'],
    );
  }
}
