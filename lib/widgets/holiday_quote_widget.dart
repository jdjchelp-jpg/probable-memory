import 'package:flutter/material.dart';
import 'package:wonderlapse/services/quotes_service.dart';

class HolidayQuoteWidget extends StatefulWidget {
  const HolidayQuoteWidget({super.key});

  @override
  State<HolidayQuoteWidget> createState() => _HolidayQuoteWidgetState();
}

class _HolidayQuoteWidgetState extends State<HolidayQuoteWidget> {
  final QuotesService _quotesService = QuotesService();
  String _currentQuote = '';

  @override
  void initState() {
    super.initState();
    _updateQuote();
    _startQuoteRotation();
  }

  void _updateQuote() {
    if (mounted) {
      setState(() {
        _currentQuote = _quotesService.getRandomQuote();
      });
    }
  }

  void _startQuoteRotation() {
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        _updateQuote();
        _startQuoteRotation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      child: Padding(
        key: ValueKey(_currentQuote),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          _currentQuote,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.95),
            fontSize: 17,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
