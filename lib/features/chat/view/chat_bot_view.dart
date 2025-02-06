import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_colors.dart';

class ChatBotView extends StatefulWidget {
  const ChatBotView({super.key});

  @override
  State<ChatBotView> createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<ChatBotView> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  
  final List<String> _quickQuestions = [
    'Stres seviyemi nasıl azaltabilirim?',
    'Anksiyete ile nasıl başa çıkabilirim?',
    'İş stresini yönetmek için öneriler',
    'Rahatlamak için teknikler',
    'Uyku kalitemi nasıl artırabilirim?',
  ];

  final Map<String, String> _botResponses = {
    'Stres seviyemi nasıl azaltabilirim?': 
      'Stres seviyenizi azaltmak için şu yöntemleri deneyebilirsiniz:\n\n'
      '1. Derin nefes egzersizleri yapın\n'
      '2. Düzenli egzersiz yapın\n'
      '3. Meditasyon ve mindfulness pratikleri yapın\n'
      '4. Yeterli uyku alın\n'
      '5. Sağlıklı beslenin\n'
      '6. Sevdiğiniz bir hobiye zaman ayırın',

    'Anksiyete ile nasıl başa çıkabilirim?':
      'Anksiyete ile başa çıkmak için önerilerim:\n\n'
      '1. 5-4-3-2-1 tekniğini kullanın (5 şey görün, 4 şey dokunun, 3 şey duyun, 2 şey koklayın, 1 şey tadın)\n'
      '2. Düşüncelerinizi yazıya dökün\n'
      '3. Düzenli egzersiz yapın\n'
      '4. Gevşeme tekniklerini öğrenin\n'
      '5. Gerekirse profesyonel yardım alın',

    'İş stresini yönetmek için öneriler':
      'İş stresini yönetmek için şunları uygulayabilirsiniz:\n\n'
      '1. Çalışma molaları planlayın\n'
      '2. Önceliklendirme yapın\n'
      '3. İş-yaşam dengesi kurun\n'
      '4. Sınırlar belirleyin\n'
      '5. Organize olun\n'
      '6. Gerektiğinde "hayır" deyin',

    'Rahatlamak için teknikler':
      'Hızlı rahatlama için şu teknikleri deneyebilirsiniz:\n\n'
      '1. Progresif kas gevşetme\n'
      '2. Diyafram nefesi\n'
      '3. Mindfulness meditasyonu\n'
      '4. Yürüyüşe çıkın\n'
      '5. Rahatlatıcı müzik dinleyin\n'
      '6. Yoga yapın',

    'Uyku kalitemi nasıl artırabilirim?':
      'Daha iyi uyku için önerilerim:\n\n'
      '1. Düzenli bir uyku programı oluşturun\n'
      '2. Yatak odanızı karanlık ve serin tutun\n'
      '3. Yatmadan önce ekran kullanımını azaltın\n'
      '4. Kafein tüketimini sınırlayın\n'
      '5. Rahatlatıcı bir gece rutini oluşturun',
  };

  @override
  void initState() {
    super.initState();
    // Başlangıç mesajını ekle
    _messages.add(ChatMessage(
      text: 'Merhaba! Ben sizin stres yönetimi asistanınızım. Size nasıl yardımcı olabilirim?\n\n'
           'Aşağıdaki konulardan birini seçebilir veya kendi sorunuzu yazabilirsiniz.',
      isBot: true,
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _messageController.clear();
    setState(() {
      _messages.add(ChatMessage(text: text, isBot: false));
    });

    // Bot yanıtı
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          String botResponse = _botResponses[text] ?? 
              'Stres yönetimi konusunda size yardımcı olmak için buradayım. '
              'Dilerseniz şu konularda size özel öneriler sunabilirim:\n\n'
              '1. Stres azaltma teknikleri\n'
              '2. Anksiyete yönetimi\n'
              '3. İş-yaşam dengesi\n'
              '4. Uyku düzeni\n'
              '5. Rahatlama egzersizleri\n\n'
              'Hangi konuda yardıma ihtiyacınız var?';
          
          _messages.add(ChatMessage(
            text: botResponse,
            isBot: true,
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stres Yönetimi Asistanı',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _ChatBubble(message: message);
              },
            ),
          ),
          // Hızlı Sorular
          if (_messages.length == 1) // Sadece başlangıç mesajı varken göster
            Container(
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _quickQuestions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      onPressed: () => _handleSubmitted(_quickQuestions[index]),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(_quickQuestions[index]),
                    ),
                  );
                },
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Mesajınızı yazın...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: _handleSubmitted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => _handleSubmitted(_messageController.text),
                      icon: const FaIcon(
                        FontAwesomeIcons.paperPlane,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isBot;

  ChatMessage({
    required this.text,
    required this.isBot,
  });
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            message.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (message.isBot) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.brain,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: message.isBot
                    ? Colors.grey[100]
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isBot ? Colors.black : AppColors.primary,
                ),
              ),
            ),
          ),
          if (!message.isBot) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.user,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
} 