import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../core/constants/app_colors.dart';

class ActivityLevelPage extends StatefulWidget {
  const ActivityLevelPage({super.key});

  @override
  State<ActivityLevelPage> createState() => _ActivityLevelPageState();
}

class _ActivityLevelPageState extends State<ActivityLevelPage> {
  String? selectedLevel;

  final List<Map<String, dynamic>> activityLevels = [
    {
      'id': 'beginner',
      'label': 'Başlangıç',
      'description': 'Düzenli egzersiz yapmıyorum',
      'icon': FontAwesomeIcons.personWalking,
    },
    {
      'id': 'intermediate',
      'label': 'Orta Seviye',
      'description': 'Haftada 2-3 kez egzersiz yapıyorum',
      'icon': FontAwesomeIcons.personRunning,
    },
    {
      'id': 'advanced',
      'label': 'İleri Seviye',
      'description': 'Haftada 4+ kez egzersiz yapıyorum',
      'icon': FontAwesomeIcons.dumbbell,
    },
    {
      'id': 'athlete',
      'label': 'Sporcu',
      'description': 'Profesyonel/yarı profesyonel sporcu',
      'icon': FontAwesomeIcons.medal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Aktivite Seviyeniz',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Size uygun egzersiz programı oluşturabilmemiz için aktivite seviyenizi seçin',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activityLevels.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final level = activityLevels[index];
              return _ActivityLevelCard(
                icon: level['icon'],
                label: level['label'],
                description: level['description'],
                isSelected: selectedLevel == level['id'],
                onTap: () {
                  setState(() {
                    selectedLevel = level['id'];
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActivityLevelCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActivityLevelCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.2) : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  size: 24,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
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