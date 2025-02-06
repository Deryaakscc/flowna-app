class OnboardingModel {
  final String image;
  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });

  static List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      image: 'assets/images/onboarding1.png',
      title: 'Sağlıklı Yaşam Asistanınız',
      description: 'Günlük aktivitelerinizi takip edin, sağlıklı yaşam hedeflerinize ulaşın.',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding2.png',
      title: 'Düzenli Hatırlatmalar',
      description: 'Su içme, egzersiz ve diğer önemli aktiviteleriniz için akıllı hatırlatmalar alın.',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding3.png',
      title: 'Motivasyon ve Takip',
      description: 'İlerlemenizi görün, başarılarınızı kutlayın ve motivasyonunuzu yüksek tutun.',
    ),
  ];
} 