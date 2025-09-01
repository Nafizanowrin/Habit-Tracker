import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/habit.dart';
import 'create_habit_screen.dart';
import 'habit_details_screen.dart';
import '../../../common/providers/notification_provider.dart';
import '../../auth/presentation/auth_provider.dart';
import 'package:intl/intl.dart';

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  String? _selectedCategory;
  final List<String> _categories = [
    'All',
    'Health',
    'Study',
    'Fitness',
    'Productivity',
    'Mental Health',
    'Others',
  ];

  // Mock data for demonstration
  List<Habit> _habits = [
    Habit.create(
      userId: 'user1',
      title: 'Drink 8 glasses of water',
      description: 'Stay hydrated throughout the day',
      frequency: HabitFrequency.daily,
      category: HabitCategory.health,
    ).copyWith(
      id: '1',
      streakCount: 5,
      longestStreak: 8,
      lastCompletedAt: DateTime.now().subtract(const Duration(days: 1)),
      completedDates: [
        DateTime.now().subtract(const Duration(days: 1)),
        DateTime.now().subtract(const Duration(days: 2)),
        DateTime.now().subtract(const Duration(days: 3)),
        DateTime.now().subtract(const Duration(days: 4)),
        DateTime.now().subtract(const Duration(days: 5)),
      ],
    ),
    Habit.create(
      userId: 'user1',
      title: 'Read 30 minutes',
      description: 'Read a book or educational content',
      frequency: HabitFrequency.daily,
      category: HabitCategory.study,
    ).copyWith(
      id: '2',
      streakCount: 12,
      longestStreak: 15,
      lastCompletedAt: DateTime.now(),
      completedDates: List.generate(12, (index) => 
        DateTime.now().subtract(Duration(days: index))
      ),
    ),
    Habit.create(
      userId: 'user1',
      title: 'Exercise',
      description: '30 minutes of physical activity',
      frequency: HabitFrequency.daily,
      category: HabitCategory.fitness,
    ).copyWith(
      id: '3',
      streakCount: 0,
      longestStreak: 0,
      lastCompletedAt: null,
      completedDates: [],
    ),
  ];

  List<Habit> get _filteredHabits {
    if (_selectedCategory == null || _selectedCategory == 'All') {
      return _habits;
    }
    return _habits.where((habit) => 
      habit.category.displayName.toLowerCase() == _selectedCategory!.toLowerCase()
    ).toList();
  }

  void _toggleHabitCompletion(Habit habit) {
    setState(() {
      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        if (habit.lastCompletedAt == null || 
            !_isSameDay(habit.lastCompletedAt!, DateTime.now())) {
          _habits[index] = habit.markCompleted();
        } else {
          // Uncomplete the habit
          _habits[index] = habit.copyWith(
            lastCompletedAt: null,
            streakCount: habit.streakCount > 0 ? habit.streakCount - 1 : 0,
          );
        }
      }
    });
  }

  void _addNewHabit(Habit newHabit) {
    setState(() {
      // Add the new habit to the beginning of the list
      _habits.insert(0, newHabit.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
      ));
    });
  }

  void _deleteHabit(Habit habit) {
    setState(() {
      _habits.removeWhere((h) => h.id == habit.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${habit.title} has been deleted'),
        backgroundColor: Colors.red[400],
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _habits.add(habit);
            });
          },
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildNotificationBanner(ThemeData theme) {
    final completedToday = _habits.where((h) => 
      h.lastCompletedAt != null && 
      _isSameDay(h.lastCompletedAt!, DateTime.now())
    ).length;
    
    final totalHabits = _habits.length;
    final completionRate = totalHabits > 0 ? (completedToday / totalHabits * 100).round() : 0;
    
    // Show different notifications based on completion rate
    String notificationText;
    Color notificationColor;
    IconData notificationIcon;
    
    if (completedToday == 0) {
      notificationText = "Start your day strong! Complete your first habit.";
      notificationColor = Colors.orange[400]!;
      notificationIcon = Icons.wb_sunny_rounded;
    } else if (completionRate < 50) {
      notificationText = "Great start! Keep going to complete more habits today.";
      notificationColor = Colors.blue[400]!;
      notificationIcon = Icons.trending_up_rounded;
    } else if (completionRate < 100) {
      notificationText = "You're doing great! Almost there - complete the remaining habits.";
      notificationColor = Colors.green[400]!;
      notificationIcon = Icons.emoji_events_rounded;
    } else {
      notificationText = "🎉 Amazing! You've completed all your habits today!";
      notificationColor = Colors.purple[400]!;
      notificationIcon = Icons.celebration_rounded;
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: notificationColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notificationColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: notificationColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              notificationIcon,
              color: notificationColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              notificationText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: notificationColor,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          if (completionRate < 100)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: notificationColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$completionRate%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReminderWidget(ThemeData theme) {
    return Consumer(
      builder: (context, ref, child) {
        final notificationSettings = ref.watch(notificationProvider);
        final notificationNotifier = ref.read(notificationProvider.notifier);
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.notifications_active_rounded,
                      color: Colors.blue[600],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Smart Reminders',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          'Stay on track with personalized notifications',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: notificationSettings.notificationsEnabled,
                    onChanged: (value) {
                      notificationNotifier.updateNotificationsEnabled(value);
                    },
                    activeColor: Colors.blue[600],
                  ),
                ],
              ),
              
              if (notificationSettings.notificationsEnabled) ...[
                const SizedBox(height: 16),
                
                // Reminder Options
                Row(
                  children: [
                    Expanded(
                      child: _buildReminderOption(
                        theme,
                        'Morning',
                        notificationSettings.morningReminderTime,
                        Icons.wb_sunny_rounded,
                        Colors.orange[400]!,
                        () => _showTimePicker(
                          context,
                          notificationSettings.morningReminderTime,
                          (time) => notificationNotifier.updateMorningReminderTime(time),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildReminderOption(
                        theme,
                        'Evening',
                        notificationSettings.eveningReminderTime,
                        Icons.nights_stay_rounded,
                        Colors.purple[400]!,
                        () => _showTimePicker(
                          context,
                          notificationSettings.eveningReminderTime,
                          (time) => notificationNotifier.updateEveningReminderTime(time),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Quick Toggle Options
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickToggle(
                        theme,
                        'Habit Reminders',
                        notificationSettings.habitReminders,
                        (value) => notificationNotifier.updateHabitReminders(value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickToggle(
                        theme,
                        'Streak Alerts',
                        notificationSettings.streakReminders,
                        (value) => notificationNotifier.updateStreakReminders(value),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildReminderOption(
    ThemeData theme,
    String title,
    String time,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickToggle(
    ThemeData theme,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: value ? Colors.green[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value ? Colors.green[200]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: value ? Colors.green[700] : Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green[600],
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  void _showTimePicker(BuildContext context, String currentTime, Function(String) onTimeSelected) {
    final timeParts = currentTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    
    showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    ).then((selectedTime) {
      if (selectedTime != null) {
        final formattedTime = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
        onTimeSelected(formattedTime);
      }
    });
  }

  Widget _buildHeaderSection(ThemeData theme) {
    return Consumer(
      builder: (context, ref, child) {
        final userAsync = ref.watch(currentUserProvider);
        final currentTime = DateTime.now();
        final greeting = _getGreeting(currentTime);
        final dateFormat = DateFormat('EEEE, MMMM d');
        final formattedDate = dateFormat.format(currentTime);
        
        // Calculate total streak (sum of all habit streaks)
        final totalStreak = _habits.fold<int>(0, (sum, habit) => sum + habit.streakCount);
        
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.1),
                theme.colorScheme.secondary.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userAsync.when(
                            data: (user) => '$greeting, ${user?.displayName ?? 'User'}!',
                            loading: () => '$greeting, User!',
                            error: (_, __) => '$greeting, User!',
                          ),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Notification Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Streak Indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange[200]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.orange[600],
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Streak: $totalStreak days',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getGreeting(DateTime time) {
    final hour = time.hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  Widget _buildHabitSuggestionsSection(ThemeData theme) {
    final suggestions = [
      {
        'title': 'Drink 8 glasses of water',
        'completed': true,
      },
      {
        'title': 'Read for 15 minutes',
        'completed': true,
      },
      {
        'title': 'Take a 10-minute walk',
        'completed': true,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Habit Suggestions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          ...suggestions.map((suggestion) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  suggestion['completed'] as bool ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: suggestion['completed'] as bool ? Colors.green[600] : Colors.grey[400],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    suggestion['title'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                      decoration: suggestion['completed'] as bool 
                          ? TextDecoration.lineThrough 
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              // TODO: Navigate to suggestions screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('See More suggestions coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'See More',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSlider(ThemeData theme) {
    final tips = [
      {
        'category': 'Health',
        'icon': Icons.favorite_rounded,
        'color': const Color(0xFF4CAF50),
        'tip': 'Drink water first thing in the morning to boost energy and metabolism.',
      },
      {
        'category': 'Study',
        'icon': Icons.school_rounded,
        'color': const Color(0xFF2196F3),
        'tip': 'Use Pomodoro Technique: 25 minutes focused study + 5-minute break.',
      },
      {
        'category': 'Fitness',
        'icon': Icons.fitness_center_rounded,
        'color': const Color(0xFFFF9800),
        'tip': 'Start with 10 minutes daily exercise. Small actions lead to big results.',
      },
      {
        'category': 'Health',
        'icon': Icons.bedtime_rounded,
        'color': const Color(0xFF4CAF50),
        'tip': 'Get 7-9 hours of quality sleep for optimal physical and mental health.',
      },
      {
        'category': 'Study',
        'icon': Icons.psychology_rounded,
        'color': const Color(0xFF2196F3),
        'tip': 'Review notes within 24 hours to improve retention by 60%.',
      },
      {
        'category': 'Fitness',
        'icon': Icons.directions_walk_rounded,
        'color': const Color(0xFFFF9800),
        'tip': 'Take stairs instead of elevators. Every step counts towards daily goals.',
      },
      {
        'category': 'Health',
        'icon': Icons.restaurant_rounded,
        'color': const Color(0xFF4CAF50),
        'tip': 'Eat rainbow fruits and vegetables for diverse nutrients and antioxidants.',
      },
      {
        'category': 'Study',
        'icon': Icons.lightbulb_rounded,
        'color': const Color(0xFF2196F3),
        'tip': 'Teach others what you\'ve learned. Explaining solidifies understanding.',
      },
      {
        'category': 'Fitness',
        'icon': Icons.timer_rounded,
        'color': const Color(0xFFFF9800),
        'tip': 'Stand and stretch every hour for desk jobs. Your body will thank you.',
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 100,
      child: PageView.builder(
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  tip['color'] as Color,
                  (tip['color'] as Color).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (tip['color'] as Color).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    tip['icon'] as IconData,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tip['category'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tip['tip'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateHabitScreen(),
                ),
              );
              
              // If a new habit was created, add it to the list
              if (result != null && result is Habit) {
                _addNewHabit(result);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('New habit added to your dashboard!'),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // New Header Section with Greeting, Date, Streak, and Notification
            _buildHeaderSection(theme),

            // Habit Suggestions Section
            _buildHabitSuggestionsSection(theme),

            // Simple Professional Header (existing design preserved)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.dashboard_rounded,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Habit Dashboard',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Track your daily progress',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_habits.where((h) => h.lastCompletedAt != null && _isSameDay(h.lastCompletedAt!, DateTime.now())).length}/${_habits.length}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Notification Banner
            _buildNotificationBanner(theme),

            // Reminder Widget
            _buildReminderWidget(theme),

            // Stats Summary
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Total Habits',
                      value: _habits.length.toString(),
                      icon: Icons.list_rounded,
                      color: theme.colorScheme.primary,
                      theme: theme,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatCard(
                      title: 'Completed Today',
                      value: _habits.where((h) => 
                        h.lastCompletedAt != null && 
                        _isSameDay(h.lastCompletedAt!, DateTime.now())
                      ).length.toString(),
                      icon: Icons.check_circle_rounded,
                      color: theme.colorScheme.secondary,
                      theme: theme,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatCard(
                      title: 'Best Streak',
                      value: _habits.isNotEmpty 
                          ? _habits.map((h) => h.streakCount).reduce((a, b) => a > b ? a : b).toString()
                          : '0',
                      icon: Icons.local_fire_department_rounded,
                      color: Colors.orange,
                      theme: theme,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tips Slider
            _buildTipsSlider(theme),
            const SizedBox(height: 12),

            // Category Filter
            Container(
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? category : null;
                        });
                      },
                      backgroundColor: theme.cardColor,
                      selectedColor: theme.colorScheme.primary,
                      checkmarkColor: theme.colorScheme.onPrimary,
                      side: BorderSide(
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Habits List
            _filteredHabits.isEmpty
                ? _buildEmptyState(theme)
                : Column(
                    children: _filteredHabits.map((habit) {
                      final isCompletedToday = habit.lastCompletedAt != null &&
                          _isSameDay(habit.lastCompletedAt!, DateTime.now());
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: _HabitCard(
                          habit: habit,
                          isCompletedToday: isCompletedToday,
                          onToggleCompletion: () => _toggleHabitCompletion(habit),
                          onDelete: () => _deleteHabit(habit),
                          theme: theme,
                        ),
                      );
                    }).toList(),
                  ),
            
            // Bottom padding for better scrolling
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateHabitScreen(),
            ),
          );
          
          // If a new habit was created, add it to the list
          if (result != null && result is Habit) {
            _addNewHabit(result);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('New habit added to your dashboard!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Habit'),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_task_rounded,
              size: 50,
              color: const Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No habits found',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first habit to get started!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateHabitScreen(),
                ),
              );
              
              // If a new habit was created, add it to the list
              if (result != null && result is Habit) {
                _addNewHabit(result);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('New habit added to your dashboard!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create First Habit'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final ThemeData theme;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HabitCard extends StatefulWidget {
  final Habit habit;
  final bool isCompletedToday;
  final VoidCallback onToggleCompletion;
  final ThemeData theme;
  final VoidCallback? onDelete;

  const _HabitCard({
    required this.habit,
    required this.isCompletedToday,
    required this.onToggleCompletion,
    required this.theme,
    this.onDelete,
  });

  @override
  State<_HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<_HabitCard> {
  bool _isLiked = false;
  bool _isPinned = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HabitDetailsScreen(habit: widget.habit),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Completion Circle
              GestureDetector(
                onTap: widget.onToggleCompletion,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.isCompletedToday 
                        ? const Color(0xFF4CAF50)
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.isCompletedToday ? const Color(0xFF4CAF50) : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    widget.isCompletedToday ? Icons.check_rounded : Icons.circle_outlined,
                    color: widget.isCompletedToday ? Colors.white : Colors.grey[400],
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Habit Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.habit.category.icon,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.habit.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: widget.isCompletedToday 
                                  ? TextDecoration.lineThrough 
                                  : null,
                              color: widget.isCompletedToday 
                                  ? Colors.grey[500] 
                                  : Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.habit.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        // Streak
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9800).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_fire_department_rounded,
                                size: 14,
                                color: const Color(0xFFFF9800),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${widget.habit.streakCount}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFFFF9800),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Category
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.habit.category.icon,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                widget.habit.category.displayName,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF2E7D32),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Action Buttons
              Column(
                children: [
                  // Like Button
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isLiked = !_isLiked;
                      });
                    },
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red[400] : Colors.grey[400],
                      size: 20,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  
                  // Edit Button
                  IconButton(
                    onPressed: () {
                      // TODO: Navigate to edit habit screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Edit habit feature coming soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.blue[400],
                      size: 20,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  
                  // Pin Button
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isPinned = !_isPinned;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isPinned ? 'Habit pinned!' : 'Habit unpinned!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: Icon(
                      _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      color: _isPinned ? Colors.orange[400] : Colors.grey[400],
                      size: 20,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  
                  // Delete Button
                  if (widget.onDelete != null)
                    IconButton(
                      onPressed: () {
                        _showDeleteConfirmation(context);
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Habit'),
          content: Text('Are you sure you want to delete "${widget.habit.title}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete?.call();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
