import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../../domain/entities/entities.dart';

class ProfileSetupPage extends ConsumerStatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  ConsumerState<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends ConsumerState<ProfileSetupPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _gender = 'male';
  String _activityLevel = 'moderate';
  String _goal = 'maintain';
  bool _isLoading = false;

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      final user = await ref.read(currentUserProvider.future);
      if (user == null) return;

      final profile = UserProfile(
        id: user.id,
        fullName: _nameController.text,
        gender: _gender,
        age: int.tryParse(_ageController.text),
        height: double.tryParse(_heightController.text),
        activityLevel: _activityLevel,
        goal: _goal,
      );

      await ref.read(metricsRepositoryProvider).saveProfile(profile);
      
      // Calculate initial metrics
      if (profile.height != null && _weightController.text.isNotEmpty) {
        await ref.read(calculateAndSaveMetricsProvider).execute(
          userId: user.id,
          weight: double.parse(_weightController.text),
          height: profile.height!,
          age: profile.age!,
          gender: profile.gender!,
          activityLevel: profile.activityLevel!,
        );
      }
      
      // Navigate to Dashboard
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configura tu Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nombre Completo')),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextField(controller: _ageController, decoration: const InputDecoration(labelText: 'Edad'), keyboardType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: TextField(controller: _heightController, decoration: const InputDecoration(labelText: 'Altura (cm)'), keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),
            TextField(controller: _weightController, decoration: const InputDecoration(labelText: 'Peso Actual (kg)'), keyboardType: TextInputType.number),
            const SizedBox(height: 24),
            const Text('Nivel de Actividad'),
            DropdownButton<String>(
              isExpanded: true,
              value: _activityLevel,
              items: ['sedentary', 'light', 'moderate', 'active', 'very_active'].map((level) {
                return DropdownMenuItem(value: level, child: Text(level));
              }).toList(),
              onChanged: (val) => setState(() => _activityLevel = val!),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                child: _isLoading ? const CircularProgressIndicator() : const Text('Guardar y Calcular'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
