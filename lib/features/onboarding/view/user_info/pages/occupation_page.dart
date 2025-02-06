import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../core/constants/app_colors.dart';

class OccupationPage extends StatefulWidget {
  const OccupationPage({super.key});

  @override
  State<OccupationPage> createState() => _OccupationPageState();
}

class _OccupationPageState extends State<OccupationPage> {
  String? selectedOccupation;

  final List<Map<String, dynamic>> occupations = [
    {
      'id': 'student',
      'label': 'Öğrenci',
      'icon': FontAwesomeIcons.graduationCap,
    },
    {
      'id': 'office_worker',
      'label': 'Ofis Çalışanı',
      'icon': FontAwesomeIcons.briefcase,
    },
    {
      'id': 'healthcare',
      'label': 'Sağlık Çalışanı',
      'icon': FontAwesomeIcons.userDoctor,
    },
    {
      'id': 'other',
      'label': 'Diğer',
      'icon': FontAwesomeIcons.user,
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
            'Mesleğiniz',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Size uygun egzersiz ve uyku programı oluşturabilmemiz için mesleğinizi seçin',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: occupations.map((occupation) {
              return _OccupationCard(
                icon: occupation['icon'],
                label: occupation['label'],
                isSelected: selectedOccupation == occupation['id'],
                onTap: () {
                  setState(() {
                    selectedOccupation = occupation['id'];
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _OccupationCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OccupationCard({
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
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 40,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 