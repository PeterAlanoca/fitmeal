import '../entities/entities.dart';

abstract class AuthRepository {
  Future<UserProfile?> getCurrentUser();
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> signOut();
}

abstract class MetricsRepository {
  Future<void> saveMetrics(BodyMetrics metrics);
  Future<List<BodyMetrics>> getMetricsHistory(String userId);
  Future<void> saveProfile(UserProfile profile);
  Future<UserProfile?> getProfile(String userId);
}

abstract class RecommendationRepository {
  Future<List<HealthyRecommendation>> getRecommendations(double bmi);
}

abstract class ReminderRepository {
  Future<void> saveReminder(UserReminder reminder);
  Future<List<UserReminder>> getReminders(String userId);
  Future<void> deleteReminder(String reminderId);
}
