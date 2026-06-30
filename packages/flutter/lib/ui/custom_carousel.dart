import 'dart:async';
import 'package:flutter/material.dart';

class PremiumCarousel extends StatefulWidget {
  final List<Widget> items;
  final double height;
  final bool autoPlay;
  final Duration autoPlayDuration;
  
  // Konfigurasi Layout & Indikator
  final double viewportFraction;
  final bool showIndicators;
  final Color? activeIndicatorColor;
  final Color? inactiveIndicatorColor;

  const PremiumCarousel({
    Key? key,
    required this.items,
    this.height = 200.0,
    this.autoPlay = true,
    this.autoPlayDuration = const Duration(seconds: 4),
    this.viewportFraction = 0.9, // Memberikan sedikit intipan card sebelum & sesudahnya
    this.showIndicators = true,
    this.activeIndicatorColor,
    this.inactiveIndicatorColor,
  }) : super(key: key);

  @override
  State<PremiumCarousel> createState() => _PremiumCarouselState();
}

class _PremiumCarouselState extends State<PremiumCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: widget.viewportFraction,
    );

    if (widget.autoPlay && widget.items.isNotEmpty) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(widget.autoPlayDuration, (timer) {
      if (_pageController.hasClients && widget.items.length > 1) {
        int nextPage = _currentIndex + 1;
        if (nextPage >= widget.items.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic, // Efek transisi meluncur premium
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose(); // Wajib di-dispose biar gak memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final activeColor = widget.activeIndicatorColor ?? theme.primaryColor;
    final inactiveColor = widget.inactiveIndicatorColor ?? Colors.grey[300];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. AREA SLIDER / CAROUSEL
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              // Efek scaling halus pada item yang tidak aktif biar dinamis
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.05)).clamp(0.9, 1.0);
                  }
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: widget.items[index],
                ),
              );
            },
          ),
        ),

        // 2. SMOOTH EXPANDING DOTS INDICATOR
        if (widget.showIndicators && widget.items.length > 1) ...[
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.items.length, (index) {
              final isSelected = _currentIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 6.0,
                // Kalau aktif, titik indikator memanjang (Modern UI Style)
                width: isSelected ? 20.0 : 6.0, 
                decoration: BoxDecoration(
                  color: isSelected ? activeColor : inactiveColor,
                  borderRadius: BorderRadius.circular(3.0),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}