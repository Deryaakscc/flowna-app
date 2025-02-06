import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';

class PeriodTrackingView extends StatefulWidget {
  const PeriodTrackingView({super.key});

  @override
  State<PeriodTrackingView> createState() => _PeriodTrackingViewState();
}

class _PeriodTrackingViewState extends State<PeriodTrackingView> {
  DateTime? _lastPeriodDate;
  int _cycleLength = 28;
  int _periodLength = 5;
  List<String> _symptoms = [];
  final List<String> _availableSymptoms = [
    'Kramp', 'Baş ağrısı', 'Yorgunluk', 'Mide bulantısı',
    'Sırt ağrısı', 'Göğüs hassasiyeti', 'Akne', 'Şişkinlik',
    'Duygusal değişimler', 'İştah değişiklikleri'
  ];

  @override
  void initState() {
    super.initState();
    _loadPeriodData();
  }

  Future<void> _loadPeriodData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final lastPeriodTimestamp = prefs.getInt('last_period_date');
      _lastPeriodDate = lastPeriodTimestamp != null 
          ? DateTime.fromMillisecondsSinceEpoch(lastPeriodTimestamp)
          : null;
      _cycleLength = prefs.getInt('cycle_length') ?? 28;
      _periodLength = prefs.getInt('period_length') ?? 5;
      _symptoms = prefs.getStringList('symptoms') ?? [];
    });
  }

  Future<void> _savePeriodData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_lastPeriodDate != null) {
      await prefs.setInt('last_period_date', _lastPeriodDate!.millisecondsSinceEpoch);
    }
    await prefs.setInt('cycle_length', _cycleLength);
    await prefs.setInt('period_length', _periodLength);
    await prefs.setStringList('symptoms', _symptoms);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lastPeriodDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _lastPeriodDate) {
      setState(() {
        _lastPeriodDate = picked;
      });
      await _savePeriodData();
    }
  }

  String _getNextPeriodText() {
    if (_lastPeriodDate == null) return 'Tarih seçilmedi';
    
    final nextPeriod = _lastPeriodDate!.add(Duration(days: _cycleLength));
    final now = DateTime.now();
    final difference = nextPeriod.difference(now).inDays;
    
    if (difference < 0) {
      return 'Geçmiş dönem';
    } else if (difference == 0) {
      return 'Bugün başlaması bekleniyor';
    } else {
      return '$difference gün sonra';
    }
  }

  String _getCurrentPhase() {
    if (_lastPeriodDate == null) return 'Bilinmiyor';
    
    final now = DateTime.now();
    final daysSinceLastPeriod = now.difference(_lastPeriodDate!).inDays;
    
    if (daysSinceLastPeriod < _periodLength) {
      return 'Adet Dönemi';
    } else if (daysSinceLastPeriod < 14) {
      return 'Foliküler Faz';
    } else if (daysSinceLastPeriod < 17) {
      return 'Yumurtlama';
    } else {
      return 'Luteal Faz';
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
                      'Adet Döngüsü Takibi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // Next Period Card
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
                        'Sonraki Dönem',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getNextPeriodText(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Şu anki faz: ${_getCurrentPhase()}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Settings
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ayarlar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SettingCard(
                      icon: FontAwesomeIcons.calendar,
                      title: 'Son Adet Tarihi',
                      value: _lastPeriodDate != null
                          ? '${_lastPeriodDate!.day}/${_lastPeriodDate!.month}/${_lastPeriodDate!.year}'
                          : 'Seç',
                      onTap: () => _selectDate(context),
                    ),
                    _SettingCard(
                      icon: FontAwesomeIcons.clock,
                      title: 'Döngü Uzunluğu',
                      value: '$_cycleLength gün',
                      onTap: () async {
                        final result = await showDialog<int>(
                          context: context,
                          builder: (context) => _NumberPickerDialog(
                            title: 'Döngü Uzunluğu',
                            initialValue: _cycleLength,
                            min: 21,
                            max: 35,
                          ),
                        );
                        if (result != null) {
                          setState(() => _cycleLength = result);
                          await _savePeriodData();
                        }
                      },
                    ),
                    _SettingCard(
                      icon: FontAwesomeIcons.droplet,
                      title: 'Adet Süresi',
                      value: '$_periodLength gün',
                      onTap: () async {
                        final result = await showDialog<int>(
                          context: context,
                          builder: (context) => _NumberPickerDialog(
                            title: 'Adet Süresi',
                            initialValue: _periodLength,
                            min: 3,
                            max: 7,
                          ),
                        );
                        if (result != null) {
                          setState(() => _periodLength = result);
                          await _savePeriodData();
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Symptoms
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Semptomlar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableSymptoms.map((symptom) {
                        final isSelected = _symptoms.contains(symptom);
                        return FilterChip(
                          label: Text(
                            symptom,
                            style: TextStyle(
                              color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) async {
                            setState(() {
                              if (selected) {
                                _symptoms.add(symptom);
                              } else {
                                _symptoms.remove(symptom);
                              }
                            });
                            await _savePeriodData();
                          },
                          selectedColor: AppColors.primary.withOpacity(0.2),
                          checkmarkColor: AppColors.primary,
                          backgroundColor: Colors.transparent,
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : AppColors.textSecondary.withOpacity(0.3),
                          ),
                        );
                      }).toList(),
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

class _SettingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _SettingCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.primary.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FaIcon(
                  icon,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberPickerDialog extends StatefulWidget {
  final String title;
  final int initialValue;
  final int min;
  final int max;

  const _NumberPickerDialog({
    required this.title,
    required this.initialValue,
    required this.min,
    required this.max,
  });

  @override
  State<_NumberPickerDialog> createState() => _NumberPickerDialogState();
}

class _NumberPickerDialogState extends State<_NumberPickerDialog> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _value > widget.min
                ? () => setState(() => _value--)
                : null,
          ),
          Text(
            '$_value',
            style: const TextStyle(fontSize: 20),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _value < widget.max
                ? () => setState(() => _value++)
                : null,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _value),
          child: const Text('Tamam'),
        ),
      ],
    );
  }
}