import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../../domain/logic/body_metrics_calculator.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Progreso'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) return const Center(child: Text('Inicia sesión para continuar'));
          
          final historyAsync = ref.watch(FutureProvider((ref) => 
            ref.watch(metricsRepositoryProvider).getMetricsHistory(user.id)));

          return historyAsync.when(
            data: (history) {
              if (history.isEmpty) {
                return const Center(child: Text('No hay datos registrados.'));
              }
              final latest = history.first;
              final classification = BodyMetricsCalculator.classifyBMI(latest.bmi);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMetricCard(
                      context,
                      'IMC',
                      latest.bmi.toStringAsFixed(1),
                      classification,
                      _getBmiColor(latest.bmi),
                    ),
                    const SizedBox(height: 16),
                    _buildMetricCard(
                      context,
                      '% Grasa Corporal',
                      '${latest.bodyFat.toStringAsFixed(1)}%',
                      'Estimado',
                      Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    _buildMetricCard(
                      context,
                      'Calorías Diarias',
                      '${latest.dailyCalorieExp.toStringAsFixed(0)} kcal',
                      'Gasto estimado',
                      Colors.orange,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Historial',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final item = history[index];
                        return ListTile(
                          title: Text('Peso: ${item.weight} kg'),
                          subtitle: Text(item.createdAt.toString().split(' ')[0]),
                          trailing: Text('IMC: ${item.bmi.toStringAsFixed(1)}'),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to new measurement page
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, String subtitle, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: color, width: 8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }
}
