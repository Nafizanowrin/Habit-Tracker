import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/habits_repository.dart';
import '../domain/habit.dart';
import '../../auth/presentation/auth_provider.dart';

// Repository provider
final habitsRepositoryProvider = Provider<HabitsRepository>((ref) {
  return HabitsRepository();
});

// Habits stream provider
final habitsStreamProvider = StreamProvider<List<Habit>>((ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return Stream.value([]);
  
  final repository = ref.read(habitsRepositoryProvider);
  return repository.getHabits(user.id);
});

// Habit stats provider
final habitStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return {'totalHabits': 0, 'completedToday': 0, 'bestStreak': 0};
  
  final repository = ref.read(habitsRepositoryProvider);
  return repository.getHabitStats(user.id);
});

// Habits controller provider
final habitsControllerProvider = Provider<HabitsController>((ref) {
  final repository = ref.read(habitsRepositoryProvider);
  final user = ref.watch(currentUserProvider).value;
  return HabitsController(repository, user?.id);
});

class HabitsController {
  final HabitsRepository _repository;
  final String? _userId;

  HabitsController(this._repository, this._userId);

  Future<void> createHabit(Habit habit) async {
    if (_userId == null) throw Exception('User not authenticated');
    await _repository.createHabit(_userId, habit);
  }

  Future<void> updateHabit(Habit habit) async {
    if (_userId == null) throw Exception('User not authenticated');
    await _repository.updateHabit(_userId, habit);
  }

  Future<void> deleteHabit(String habitId) async {
    if (_userId == null) throw Exception('User not authenticated');
    await _repository.deleteHabit(_userId, habitId);
  }

  Future<void> markHabitCompleted(String habitId, DateTime completedAt) async {
    if (_userId == null) throw Exception('User not authenticated');
    await _repository.markHabitCompleted(_userId, habitId, completedAt);
  }
}
