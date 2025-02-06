import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';

class WaterTrackingView extends StatefulWidget {
  const WaterTrackingView({super.key});

  @override
  State<WaterTrackingView> createState() => _WaterTrackingViewState();
}

class _WaterTrackingViewState extends State<WaterTrackingView> {
  int _dailyGoal = 2000; // ml cinsinden günlük hedef
  int _currentAmount = 0;
  final List<int> _waterHistory = [];

  @override
  void initState() {
    super.initState();
    _loadWaterData();
  }

  Future<void> _loadWaterData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dailyGoal = prefs.getInt('water_daily_goal') ?? 2000;
      _currentAmount = prefs.getInt('water_current_amount') ?? 0;
      _waterHistory.addAll(prefs.getStringList('water_history')?.map(int.parse) ?? []);
    });
  }

  Future<void> _saveWaterData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('water_daily_goal', _dailyGoal);
    await prefs.setInt('water_current_amount', _currentAmount);
    await prefs.setStringList('water_history', _waterHistory.map((e) => e.toString()).toList());
  }

  void _addWater(int amount) {
    setState(() {
      _currentAmount += amount;
      _waterHistory.add(amount);
    });
    _saveWaterData();
  }

  void _resetWater() {
    setState(() {
      _currentAmount = 0;
      _waterHistory.clear();
    });
    _saveWaterData();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _currentAmount / _dailyGoal;

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
                      'Su Takibi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // Progress Card
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.water,
                        AppColors.water.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: CircularProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 10,
                            ),
                          ),
                          Column(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.droplet,
                                color: Colors.white,
                                size: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$_currentAmount ml',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Hedef: $_dailyGoal ml',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Quick Add Buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hızlı Ekle',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _WaterButton(
                          amount: 100,
                          onTap: () => _addWater(100),
                        ),
                        _WaterButton(
                          amount: 200,
                          onTap: () => _addWater(200),
                        ),
                        _WaterButton(
                          amount: 300,
                          onTap: () => _addWater(300),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _WaterButton(
                          amount: 400,
                          onTap: () => _addWater(400),
                        ),
                        _WaterButton(
                          amount: 500,
                          onTap: () => _addWater(500),
                        ),
                        _WaterButton(
                          amount: 600,
                          onTap: () => _addWater(600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // History
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Günlük Geçmiş',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _resetWater,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Sıfırla'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.water,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_waterHistory.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Henüz su içmediniz',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _waterHistory.length,
                        itemBuilder: (context, index) {
                          final amount = _waterHistory[index];
                          return Card(
                            elevation: 0,
                            color: AppColors.surface,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: AppColors.water.withOpacity(0.3),
                              ),
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.water.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.glassWater,
                                  color: AppColors.water,
                                  size: 20,
                                ),
                              ),
                              title: Text('$amount ml su içildi'),
                              trailing: Text(
                                '${DateTime.now().hour}:${DateTime.now().minute}',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        },
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

class _WaterButton extends StatelessWidget {
  final int amount;
  final VoidCallback onTap;

  const _WaterButton({
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.water.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.water.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            FaIcon(
              FontAwesomeIcons.glassWater,
              color: AppColors.water,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              '$amount ml',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 