import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/habit.dart';

class HabitsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all habits for a user
  Stream<List<Habit>> getHabits(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Habit.fromMap({
          'id': doc.id,
          ...data,
        });
      }).toList();
    });
  }

  // Create a new habit
  Future<void> createHabit(String userId, Habit habit) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .add(habit.toMap());
  }

  // Update a habit
  Future<void> updateHabit(String userId, Habit habit) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habit.id)
        .update(habit.toMap());
  }

  // Delete a habit
  Future<void> deleteHabit(String userId, String habitId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habitId)
        .delete();
  }

  // Mark habit as completed
  Future<void> markHabitCompleted(String userId, String habitId, DateTime completedAt) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habitId)
        .update({
      'lastCompletedAt': completedAt,
      'completionHistory': FieldValue.arrayUnion([completedAt.millisecondsSinceEpoch]),
    });
  }

  // Get habit statistics
  Future<Map<String, dynamic>> getHabitStats(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .get();

    final habits = snapshot.docs.map((doc) {
      final data = doc.data();
      return Habit.fromMap({
        'id': doc.id,
        ...data,
      });
    }).toList();

    final totalHabits = habits.length;
    final completedToday = habits.where((habit) {
      if (habit.lastCompletedAt == null) return false;
      final today = DateTime.now();
      final lastCompleted = habit.lastCompletedAt!;
      return today.year == lastCompleted.year &&
          today.month == lastCompleted.month &&
          today.day == lastCompleted.day;
    }).length;

    final bestStreak = habits.isNotEmpty
        ? habits.map((h) => h.streakCount).reduce((a, b) => a > b ? a : b)
        : 0;

    return {
      'totalHabits': totalHabits,
      'completedToday': completedToday,
      'bestStreak': bestStreak,
    };
  }
}
