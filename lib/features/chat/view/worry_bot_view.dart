import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_colors.dart';

class WorryBotView extends StatefulWidget {
  const WorryBotView({super.key});

  @override
  State<WorryBotView> createState() => _WorryBotViewState();
}

class _WorryBotViewState extends State<WorryBotView> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final List<String> _quickQuestions = [
    'Bugün kendimi çok yalnız hissediyorum',
    'İş hayatımda çok stres yaşıyorum',
    'Ailemle sorunlar yaşıyorum',
    'Gelecek kaygısı yaşıyorum',
    'Motivasyonum düşük',
    'Özgüven problemim var',
    'İlişkilerimde sorun yaşıyorum',
    'Kararsızlık yaşıyorum',
  ];

  final Map<String, String> _botResponses = {
    'Bugün kendimi çok yalnız hissediyorum': 
      'Yalnızlık hissi gerçekten zor bir duygu olabilir. Size birkaç öneri sunmak isterim:\n\n'
      '1. Sevdiğiniz bir arkadaşınızı veya aile üyenizi arayın\n'
      '2. Sosyal aktivitelere katılın (spor, sanat, hobi grupları)\n'
      '3. Online toplulukları keşfedin\n'
      '4. Gönüllülük faaliyetlerine katılın\n'
      '5. Kendinize özel zaman ayırın ve sevdiğiniz aktiviteleri yapın\n\n'
      'Bu duyguyu benimle paylaştığınız için teşekkür ederim. Başka neler hissediyorsunuz?',

    'İş hayatımda çok stres yaşıyorum':
      'İş stresi oldukça yaygın ve zorlayıcı olabilir. İşte size yardımcı olabilecek öneriler:\n\n'
      '1. Düzenli molalar verin\n'
      '2. Önceliklendirme yapın ve yapılacakları listeleyin\n'
      '3. "Hayır" demeyi öğrenin\n'
      '4. İş-yaşam dengesi kurun\n'
      '5. Stres yönetimi teknikleri öğrenin\n'
      '6. Gerekirse yöneticinizle konuşun\n\n'
      'İş ortamında sizi en çok ne strese sokuyor?',

    'Ailemle sorunlar yaşıyorum':
      'Aile ilişkileri bazen karmaşık olabilir. Size yardımcı olabilecek önerilerim:\n\n'
      '1. Açık ve sakin bir iletişim kurmaya çalışın\n'
      '2. Karşılıklı anlayış geliştirmeye odaklanın\n'
      '3. Ortak aktiviteler planlayın\n'
      '4. Sınırlarınızı belirleyin\n'
      '5. Gerekirse bir aile terapistinden destek alın\n\n'
      'Ailenizle yaşadığınız sorunlar hakkında daha fazla konuşmak ister misiniz?',

    'Gelecek kaygısı yaşıyorum':
      'Gelecek kaygısı çok normal bir duygu. Size yardımcı olabilecek öneriler:\n\n'
      '1. Şu ana odaklanın ve mindfulness pratikleri yapın\n'
      '2. Küçük, ulaşılabilir hedefler belirleyin\n'
      '3. Pozitif düşünme alışkanlıkları geliştirin\n'
      '4. Kendinize güvenin ve başarılarınızı hatırlayın\n'
      '5. Bir B planı oluşturun\n\n'
      'Gelecekle ilgili sizi en çok endişelendiren şey nedir?',

    'Motivasyonum düşük':
      'Motivasyon dalgalanmaları yaşamak çok doğal. İşte size yardımcı olabilecek öneriler:\n\n'
      '1. Küçük, ulaşılabilir hedefler belirleyin\n'
      '2. Her başarıyı kutlayın\n'
      '3. Kendinizi ödüllendirin\n'
      '4. Hedeflerinizi görselleştirin\n'
      '5. Olumlu insanlarla vakit geçirin\n'
      '6. Rutininizi değiştirin\n\n'
      'Sizi en çok ne motive eder?',

    'Özgüven problemim var':
      'Özgüven geliştirilebilen bir özelliktir. Size yardımcı olabilecek öneriler:\n\n'
      '1. Küçük başarılarla başlayın\n'
      '2. Kendinize karşı nazik olun\n'
      '3. Pozitif özelliklerinize odaklanın\n'
      '4. Yeni beceriler öğrenin\n'
      '5. Konfor alanınızdan yavaşça çıkın\n\n'
      'Hangi durumlarda kendinizi daha güvensiz hissediyorsunuz?',

    'İlişkilerimde sorun yaşıyorum':
      'İlişkiler karmaşık olabilir. Size yardımcı olabilecek öneriler:\n\n'
      '1. Açık iletişim kurun\n'
      '2. Aktif dinleme yapın\n'
      '3. Empati geliştirin\n'
      '4. Kendi sınırlarınızı belirleyin\n'
      '5. Beklentilerinizi net ifade edin\n\n'
      'İlişkilerinizde sizi en çok zorlayan şey nedir?',

    'Kararsızlık yaşıyorum':
      'Karar vermek bazen zor olabilir. Size yardımcı olabilecek öneriler:\n\n'
      '1. Artıları ve eksileri listeleyin\n'
      '2. Küçük adımlarla başlayın\n'
      '3. Sezgilerinizi dinleyin\n'
      '4. Zaman sınırı koyun\n'
      '5. Gerekirse başkalarının fikrini alın\n\n'
      'Hangi konuda karar vermekte zorlanıyorsunuz?',
  };

  @override
  void initState() {
    super.initState();
    // Başlangıç mesajını ekle
    _messages.add(ChatMessage(
      text: 'Merhaba! Ben sizin dert ortağınızım. Size nasıl yardımcı olabilirim?\n\n'
           'Aşağıdaki konulardan birini seçebilir veya kendi düşüncelerinizi paylaşabilirsiniz. '
           'Sizi dinlemek için buradayım.',
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
              'Sizi anlıyorum ve dinliyorum. Duygularınızı paylaştığınız için teşekkür ederim. '
              'Size daha iyi yardımcı olabilmem için biraz daha detay verebilir misiniz? '
              'Nasıl hissediyorsunuz?';
          
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
          'Dert Ortağınız',
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
          // Mesaj Gönderme Alanı
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
                  FontAwesomeIcons.heart,
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