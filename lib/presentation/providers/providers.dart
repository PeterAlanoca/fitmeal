import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/supabase_repositories.dart';
import '../../domain/repositories/interfaces.dart';
import '../../domain/usecases/metrics_usecases.dart';

// Supabase Client Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) => Supabase.instance.client);

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return SupabaseAuthRepository(ref.watch(supabaseClientProvider));
});

final metricsRepositoryProvider = Provider<MetricsRepository>((ref) {
  return SupabaseMetricsRepository(ref.watch(supabaseClientProvider));
});

// Use Cases
final calculateAndSaveMetricsProvider = Provider<CalculateAndSaveMetrics>((ref) {
  return CalculateAndSaveMetrics(ref.watch(metricsRepositoryProvider));
});

// State Providers
final currentUserProvider = FutureProvider((ref) {
  return ref.watch(authRepositoryProvider).getCurrentUser();
});

final userProfileProvider = FutureProvider((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return null;
  return ref.watch(metricsRepositoryProvider).getProfile(user.id);
});
