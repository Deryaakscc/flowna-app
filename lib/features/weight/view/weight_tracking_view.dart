import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/init/calorie/calorie_service.dart';

class WeightTrackingView extends StatefulWidget {
  const WeightTrackingView({super.key});

  @override
  State<WeightTrackingView> createState() => _WeightTrackingViewState();
}

class _WeightTrackingViewState extends State<WeightTrackingView> {
  final _calorieService = CalorieService();
  
  // Kullanıcı bilgileri
  bool _isFemale = true;
  int _age = 25;
  double _weight = 60;
  double _height = 165;
  ActivityLevel _activityLevel = ActivityLevel.moderatelyActive;
  WeightGoal _weightGoal = WeightGoal.maintain;
  
  // Hesaplanan değerler
  double _bmr = 0;
  double _dailyCalories = 0;
  double _targetCalories = 0;

  // Besin değerleri
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  double _foodCalories = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _calculateCalories();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFemale = prefs.getBool('is_female') ?? true;
      _age = prefs.getInt('age') ?? 25;
      _weight = prefs.getDouble('weight') ?? 60;
      _height = prefs.getDouble('height') ?? 165;
      _activityLevel = ActivityLevel.values[prefs.getInt('activity_level') ?? 2];
      _weightGoal = WeightGoal.values[prefs.getInt('weight_goal') ?? 1];
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_female', _isFemale);
    await prefs.setInt('age', _age);
    await prefs.setDouble('weight', _weight);
    await prefs.setDouble('height', _height);
    await prefs.setInt('activity_level', _activityLevel.index);
    await prefs.setInt('weight_goal', _weightGoal.index);
  }

  void _calculateCalories() {
    setState(() {
      _bmr = _calorieService.calculateBMR(
        isFemale: _isFemale,
        age: _age,
        weight: _weight,
        height: _height,
      );
      
      _dailyCalories = _calorieService.calculateDailyCalories(
        bmr: _bmr,
        activityLevel: _activityLevel,
      );
      
      _targetCalories = _calorieService.calculateTargetCalories(
        dailyCalories: _dailyCalories,
        goal: _weightGoal,
      );
    });
  }

  void _calculateFoodCalories() {
    final protein = double.tryParse(_proteinController.text) ?? 0;
    final carbs = double.tryParse(_carbsController.text) ?? 0;
    final fat = double.tryParse(_fatController.text) ?? 0;

    setState(() {
      _foodCalories = _calorieService.calculateFoodCalories(
        protein: protein,
        carbs: carbs,
        fat: fat,
      );
    });
  }

  String _getActivityLevelText(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Hareketsiz';
      case ActivityLevel.lightlyActive:
        return 'Az Hareketli';
      case ActivityLevel.moderatelyActive:
        return 'Orta Hareketli';
      case ActivityLevel.veryActive:
        return 'Çok Hareketli';
      case ActivityLevel.extraActive:
        return 'Aşırı Hareketli';
    }
  }

  String _getWeightGoalText(WeightGoal goal) {
    switch (goal) {
      case WeightGoal.lose:
        return 'Kilo Ver';
      case WeightGoal.maintain:
        return 'Kiloyu Koru';
      case WeightGoal.gain:
        return 'Kilo Al';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Kilo ve Kalori Takibi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // Kalori Kartı
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Günlük Kalori İhtiyacınız',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _CalorieInfoItem(
                            title: 'BMR',
                            value: _bmr.toStringAsFixed(0),
                            unit: 'kcal',
                          ),
                          _CalorieInfoItem(
                            title: 'Günlük',
                            value: _dailyCalories.toStringAsFixed(0),
                            unit: 'kcal',
                          ),
                          _CalorieInfoItem(
                            title: 'Hedef',
                            value: _targetCalories.toStringAsFixed(0),
                            unit: 'kcal',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Kullanıcı Bilgileri
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kişisel Bilgiler',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Cinsiyet Seçimi
                    Row(
                      children: [
                        Expanded(
                          child: _SelectionCard(
                            icon: FontAwesomeIcons.venus,
                            title: 'Kadın',
                            isSelected: _isFemale,
                            onTap: () {
                              setState(() {
                                _isFemale = true;
                                _calculateCalories();
                              });
                              _saveUserData();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _SelectionCard(
                            icon: FontAwesomeIcons.mars,
                            title: 'Erkek',
                            isSelected: !_isFemale,
                            onTap: () {
                              setState(() {
                                _isFemale = false;
                                _calculateCalories();
                              });
                              _saveUserData();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Yaş, Boy, Kilo
                    Row(
                      children: [
                        Expanded(
                          child: _NumberInputCard(
                            icon: FontAwesomeIcons.calendar,
                            title: 'Yaş',
                            value: _age,
                            onChanged: (value) {
                              setState(() {
                                _age = value;
                                _calculateCalories();
                              });
                              _saveUserData();
                            },
                            min: 15,
                            max: 100,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _NumberInputCard(
                            icon: FontAwesomeIcons.ruler,
                            title: 'Boy (cm)',
                            value: _height.toInt(),
                            onChanged: (value) {
                              setState(() {
                                _height = value.toDouble();
                                _calculateCalories();
                              });
                              _saveUserData();
                            },
                            min: 140,
                            max: 220,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _NumberInputCard(
                            icon: FontAwesomeIcons.weightScale,
                            title: 'Kilo (kg)',
                            value: _weight.toInt(),
                            onChanged: (value) {
                              setState(() {
                                _weight = value.toDouble();
                                _calculateCalories();
                              });
                              _saveUserData();
                            },
                            min: 40,
                            max: 200,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Aktivite Seviyesi ve Hedef
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aktivite ve Hedef',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Aktivite Seviyesi
                    Card(
                      elevation: 0,
                      color: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: AppColors.primary.withOpacity(0.1),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.personRunning,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Aktivite Seviyesi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: ActivityLevel.values.map((level) {
                                return ChoiceChip(
                                  label: Text(_getActivityLevelText(level)),
                                  selected: _activityLevel == level,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _activityLevel = level;
                                        _calculateCalories();
                                      });
                                      _saveUserData();
                                    }
                                  },
                                  selectedColor: AppColors.primary.withOpacity(0.2),
                                  backgroundColor: Colors.transparent,
                                  labelStyle: TextStyle(
                                    color: _activityLevel == level
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Hedef
                    Card(
                      elevation: 0,
                      color: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: AppColors.primary.withOpacity(0.1),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.bullseye,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Hedef',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: WeightGoal.values.map((goal) {
                                return ChoiceChip(
                                  label: Text(_getWeightGoalText(goal)),
                                  selected: _weightGoal == goal,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _weightGoal = goal;
                                        _calculateCalories();
                                      });
                                      _saveUserData();
                                    }
                                  },
                                  selectedColor: AppColors.primary.withOpacity(0.2),
                                  backgroundColor: Colors.transparent,
                                  labelStyle: TextStyle(
                                    color: _weightGoal == goal
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Besin Kalori Hesaplayıcı
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Besin Kalori Hesaplayıcı',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 0,
                      color: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: AppColors.primary.withOpacity(0.1),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _MacroInputField(
                              controller: _proteinController,
                              label: 'Protein (g)',
                              icon: FontAwesomeIcons.drumstickBite,
                              onChanged: (_) => _calculateFoodCalories(),
                            ),
                            const SizedBox(height: 12),
                            _MacroInputField(
                              controller: _carbsController,
                              label: 'Karbonhidrat (g)',
                              icon: FontAwesomeIcons.breadSlice,
                              onChanged: (_) => _calculateFoodCalories(),
                            ),
                            const SizedBox(height: 12),
                            _MacroInputField(
                              controller: _fatController,
                              label: 'Yağ (g)',
                              icon: FontAwesomeIcons.oilWell,
                              onChanged: (_) => _calculateFoodCalories(),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Toplam Kalori:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${_foodCalories.toStringAsFixed(0)} kcal',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalorieInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const _CalorieInfoItem({
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            FaIcon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberInputCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int value;
  final Function(int) onChanged;
  final int min;
  final int max;

  const _NumberInputCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.primary.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            FaIcon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 16),
                  onPressed: value > min
                      ? () => onChanged(value - 1)
                      : null,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  onPressed: value < max
                      ? () => onChanged(value + 1)
                      : null,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final Function(String) onChanged;

  const _MacroInputField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Container(
          padding: const EdgeInsets.all(12),
          child: FaIcon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
} 