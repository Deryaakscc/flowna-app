import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../chat/view/chat_bot_view.dart';
import '../../chat/view/worry_bot_view.dart';
import '../../calendar/view/calendar_view.dart';
import '../../statistics/view/statistics_view.dart';
import '../../weight/view/weight_tracking_view.dart';
import '../../profile/view/profile_view.dart';
import '../../sleep/view/sleep_tracking_view.dart';
import '../../period/view/period_tracking_view.dart';
import '../../water/view/water_tracking_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _waterCount = 0;
  bool _tookMedicine = false;
  int _walkSteps = 0;
  int _mealCount = 0;

  void _handleFeatureCardTap(String feature, BuildContext context) {
    switch (feature) {
      case 'stress':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatBotView()),
        );
        break;
      case 'weight':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WeightTrackingView()),
        );
        break;
      case 'worry':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WorryBotView()),
        );
        break;
      case 'sleep':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SleepTrackingView()),
        );
        break;
      case 'period':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PeriodTrackingView()),
        );
        break;
      case 'water':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WaterTrackingView()),
        );
        break;
      // Diğer özellikler için case'ler eklenebilir
    }
  }

  void _onNavigationItemSelected(int index) {
    if (index == 1) { // Program sekmesi
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CalendarView()),
      );
    } else if (index == 2) { // İstatistik sekmesi
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StatisticsView()),
      );
    } else if (index == 3) { // Profil sekmesi
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileView()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'water':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WaterTrackingView()),
        );
        break;
      case 'medicine':
        setState(() {
          _tookMedicine = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('İlaç alındı olarak işaretlendi'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
        break;
      case 'walk':
        setState(() {
          _walkSteps += 1000;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Yürüyüş eklendi! Bugün toplam: $_walkSteps adım'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
        break;
      case 'meal':
        setState(() {
          _mealCount++;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Öğün eklendi! Bugün toplam: $_mealCount öğün'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Merhaba 👋',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          'Hoş Geldiniz!',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Daily Progress
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Günlük İlerlemeniz',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: 0.7,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '7/10 görev tamamlandı',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.trending_up,
                          color: AppColors.primary,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Feature Grid
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Özellikler',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _FeatureCard(
                          icon: FontAwesomeIcons.brain,
                          title: 'Stres Yönetimi',
                          description: 'Stresi azaltın ve rahatlayın',
                          color: const Color(0xFF3949AB),
                          onTap: () => _handleFeatureCardTap('stress', context),
                        ),
                        _FeatureCard(
                          icon: FontAwesomeIcons.solidHeart,
                          title: 'Dert Ortağınız',
                          description: 'Size destek olmak için buradayız',
                          color: const Color(0xFF5C6BC0),
                          onTap: () => _handleFeatureCardTap('worry', context),
                        ),
                        _FeatureCard(
                          icon: FontAwesomeIcons.moon,
                          title: 'Uyku Takibi',
                          description: 'Uyku kalitenizi artırın',
                          color: const Color(0xFF3F51B5),
                          onTap: () => _handleFeatureCardTap('sleep', context),
                        ),
                        _FeatureCard(
                          icon: FontAwesomeIcons.weightScale,
                          title: 'Kilo Takibi',
                          description: 'Hedeflerinize ulaşın',
                          color: const Color(0xFF1A237E),
                          onTap: () => _handleFeatureCardTap('weight', context),
                        ),
                        _FeatureCard(
                          icon: FontAwesomeIcons.venus,
                          title: 'Adet Döngüsü',
                          description: 'Döngünüzü takip edin',
                          color: const Color(0xFF5C6BC0),
                          onTap: () => _handleFeatureCardTap('period', context),
                        ),
                        _FeatureCard(
                          icon: FontAwesomeIcons.glassWater,
                          title: 'Su Takibi',
                          description: 'Günlük ortalama: 2.1L',
                          color: const Color(0xFF3F51B5),
                          onTap: () => _handleFeatureCardTap('water', context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Quick Actions
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hızlı İşlemler',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_waterCount > 0 || _tookMedicine || _walkSteps > 0 || _mealCount > 0)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _waterCount = 0;
                                _tookMedicine = false;
                                _walkSteps = 0;
                                _mealCount = 0;
                              });
                            },
                            child: Text(
                              'Sıfırla',
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _QuickActionCard(
                            icon: FontAwesomeIcons.glassWater,
                            title: _waterCount > 0 ? '$_waterCount bardak su' : 'Su İç',
                            onTap: () => _handleQuickAction('water'),
                            isActive: _waterCount > 0,
                          ),
                          _QuickActionCard(
                            icon: FontAwesomeIcons.pills,
                            title: _tookMedicine ? 'İlaç Alındı' : 'İlaç Al',
                            onTap: () => _handleQuickAction('medicine'),
                            isActive: _tookMedicine,
                          ),
                          _QuickActionCard(
                            icon: FontAwesomeIcons.personWalking,
                            title: _walkSteps > 0 ? '$_walkSteps adım' : 'Yürüyüş',
                            onTap: () => _handleQuickAction('walk'),
                            isActive: _walkSteps > 0,
                          ),
                          _QuickActionCard(
                            icon: FontAwesomeIcons.bowlFood,
                            title: _mealCount > 0 ? '$_mealCount öğün' : 'Öğün',
                            onTap: () => _handleQuickAction('meal'),
                            isActive: _mealCount > 0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Activity Grid
              Container(
                height: 140,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Günlük Aktiviteler',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView(
                        children: [
                          _ActivityItem(
                            title: 'Su İçme',
                            subtitle: '2/8 bardak',
                            progress: 0.25,
                          ),
                          const SizedBox(height: 8),
                          _ActivityItem(
                            title: 'Egzersiz',
                            subtitle: '15/30 dakika',
                            progress: 0.5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavigationItemSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Program',
          ),
          NavigationDestination(
            icon: Icon(Icons.insert_chart_outlined),
            selectedIcon: Icon(Icons.insert_chart),
            label: 'İstatistik',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.15),
              color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: FaIcon(
                icon,
                color: color.withOpacity(0.9),
                size: 18,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      height: 1.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isActive;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                )
              : null,
            color: isActive ? null : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? Colors.transparent : AppColors.primary.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: isActive 
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isActive 
                    ? Colors.white.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FaIcon(
                  icon,
                  color: isActive ? Colors.white : AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;

  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
} 