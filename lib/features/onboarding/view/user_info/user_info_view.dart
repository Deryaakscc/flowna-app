import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import 'pages/gender_page.dart';
import 'pages/occupation_page.dart';
import 'pages/age_page.dart';
import 'pages/lifestyle_page.dart';
import 'pages/sleep_page.dart';
import 'pages/activity_level_page.dart';
import 'pages/health_goals_page.dart';
import 'pages/summary_page.dart';

class UserInfoView extends StatefulWidget {
  const UserInfoView({super.key});

  @override
  State<UserInfoView> createState() => _UserInfoViewState();
}

class _UserInfoViewState extends State<UserInfoView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final Map<String, dynamic> _userInfo = {};

  final List<Widget> _pages = [
    GenderPage(),
    OccupationPage(),
    AgePage(),
    LifestylePage(),
    SleepPage(),
    ActivityLevelPage(),
    HealthGoalsPage(),
    SummaryPage(),
  ];

  void updateUserInfo(String key, dynamic value) {
    setState(() {
      _userInfo[key] = value;
    });
  }

  void nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: WormEffect(
                  dotColor: AppColors.accent,
                  activeDotColor: AppColors.primary,
                  dotHeight: 8,
                  dotWidth: 8,
                ),
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _pages[index];
                },
              ),
            ),
            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: previousPage,
                      child: Text(
                        'Geri',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 80),
                  // Next/Finish Button
                  ElevatedButton(
                    onPressed: _currentPage == _pages.length - 1
                        ? () {
                            // TODO: Save user info and navigate to home
                          }
                        : nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'Başla' : 'İleri',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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