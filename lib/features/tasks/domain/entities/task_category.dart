enum TaskCategory { general, work, personal, health, finance }

extension TaskCategoryExtension on TaskCategory {
  String get name => toString().split('.').last;

  String get label {
    switch (this) {
      case TaskCategory.general:
        return 'General';
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.health:
        return 'Health';
      case TaskCategory.finance:
        return 'Finance';
    }
  }

  static TaskCategory fromString(String value) {
    switch (value.toLowerCase()) {
      case 'general':
        return TaskCategory.general;
      case 'work':
        return TaskCategory.work;
      case 'personal':
        return TaskCategory.personal;
      case 'health':
        return TaskCategory.health;
      case 'finance':
        return TaskCategory.finance;
      default:
        return TaskCategory.general;
    }
  }
}
