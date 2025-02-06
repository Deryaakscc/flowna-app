import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../core/constants/app_colors.dart';

class LifestylePage extends StatefulWidget {
  const LifestylePage({super.key});

  @override
  State<LifestylePage> createState() => _LifestylePageState();
}

class _LifestylePageState extends State<LifestylePage> {
  String? selectedLifestyle;

  final List<Map<String, dynamic>> lifestyles = [
    {
      'id': 'sedentary',
      'label': 'Hareketsiz',
      'description': 'Genellikle masa başında, az hareket',
      'icon': FontAwesomeIcons.chair,
    },
    {
      'id': 'lightly_active',
      'label': 'Az Hareketli',
      'description': 'Hafif yürüyüşler, günlük aktiviteler',
      'icon': FontAwesomeIcons.personWalking,
    },
    {
      'id': 'moderately_active',
      'label': 'Orta Hareketli',
      'description': 'Düzenli egzersiz, aktif yaşam',
      'icon': FontAwesomeIcons.personRunning,
    },
    {
      'id': 'very_active',
      'label': 'Çok Hareketli',
      'description': 'Yoğun spor, atletik yaşam',
      'icon': FontAwesomeIcons.dumbbell,
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
            'Yaşam Tarzınız',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Size uygun aktivite planı oluşturabilmemiz için yaşam tarzınızı seçin',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lifestyles.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final lifestyle = lifestyles[index];
              return _LifestyleCard(
                icon: lifestyle['icon'],
                label: lifestyle['label'],
                description: lifestyle['description'],
                isSelected: selectedLifestyle == lifestyle['id'],
                onTap: () {
                  setState(() {
                    selectedLifestyle = lifestyle['id'];
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

class _LifestyleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _LifestyleCard({
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