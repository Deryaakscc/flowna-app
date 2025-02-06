import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../chat/view/chat_bot_view.dart';
import 'summary_page.dart';

class HealthGoalsPage extends StatefulWidget {
  const HealthGoalsPage({super.key});

  @override
  State<HealthGoalsPage> createState() => _HealthGoalsPageState();
}

class _HealthGoalsPageState extends State<HealthGoalsPage> {
  final Set<String> selectedGoals = {};

  final List<Map<String, dynamic>> healthGoals = [
    {
      'id': 'sleep',
      'label': 'Daha İyi Uyku',
      'icon': FontAwesomeIcons.bed,
    },
    {
      'id': 'stress',
      'label': 'Stres Yönetimi',
      'icon': FontAwesomeIcons.brain,
    },
    {
      'id': 'weight',
      'label': 'Kilo Kontrolü',
      'icon': FontAwesomeIcons.weightScale,
    },
    {
      'id': 'fitness',
      'label': 'Fiziksel Form',
      'icon': FontAwesomeIcons.dumbbell,
    },
  ];

  void _handleGoalTap(String goalId) {
    if (goalId == 'stress') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatBotView(),
        ),
      );
    } else {
      setState(() {
        if (selectedGoals.contains(goalId)) {
          selectedGoals.remove(goalId);
        } else {
          selectedGoals.add(goalId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress Dots
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  8,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 6 ? AppColors.primary : AppColors.accent,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        'Sağlık Hedefleriniz',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Size özel bir program hazırlayabilmemiz için hedeflerinizi seçin',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1,
                        children: healthGoals.map((goal) {
                          return _HealthGoalCard(
                            icon: goal['icon'],
                            label: goal['label'],
                            isSelected: selectedGoals.contains(goal['id']),
                            onTap: () => _handleGoalTap(goal['id']),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Geri',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: selectedGoals.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SummaryPage(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'İleri',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthGoalCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _HealthGoalCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  size: 24,
                  color: isSelected ? AppColors.primary : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 