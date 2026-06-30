import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

// ===========================================================================
// 1. GENERIC EVENT MODEL FOR LIBRARY
// ===========================================================================
/// Model Event internal library agar lepas dari dependensi model proyek lama.
class PremiumCalendarEvent extends Event {
  final String? eventTitle;
  final dynamic customData; // Untuk menyimpan data tambahan bebas (SaaS metadata)

  PremiumCalendarEvent({
    required DateTime date,
    Widget? icon,
    this.eventTitle,
    this.customData,
  }) : super(date: date, icon: icon, title: eventTitle);
}

// ===========================================================================
// 2. PREMIUM STANDALONE CALENDAR WIDGET
// ===========================================================================
class PremiumCalendar extends StatelessWidget {
  final DateTime selectedDateTime;
  final DateTime targetDateTime;
  final EventList<PremiumCalendarEvent>? markedDatesMap;
  final double? height;
  final bool isScrollable;
  
  // Callback modern pengganti operan setState
  final Function(DateTime, List<PremiumCalendarEvent>) onDayPressed;
  final Function(DateTime)? onCalendarChanged;

  const PremiumCalendar({
    Key? key,
    required this.selectedDateTime,
    required this.targetDateTime,
    required this.onDayPressed,
    this.markedDatesMap,
    this.onCalendarChanged,
    this.height,
    this.isScrollable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: CalendarCarousel<PremiumCalendarEvent>(
        // --- Konfigurasi Handler ---
        onDayPressed: (date, events) => onDayPressed(date, events),
        onCalendarChanged: onCalendarChanged,
        
        // --- Struktur & Dimensi ---
        height: height ?? MediaQuery.of(context).size.height * 0.42,
        selectedDateTime: selectedDateTime,
        targetDateTime: targetDateTime,
        isScrollable: isScrollable,
        customGridViewPhysics: const NeverScrollableScrollPhysics(),
        showHeader: false, // Header bulan diatur manual di UI utama agar lebih fleksibel
        showOnlyCurrentMonthDate: false,
        markedDatesMap: markedDatesMap,
        markedDateIconMaxShown: 3,

        // --- Estetika Warna & Desain Premium (Slate/Clean Style) ---
        
        // Hari Utama
        daysTextStyle: const TextStyle(
          color: Color(0xFF334155), // Slate 700
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        
        // Hari Libur / Weekend
        weekendTextStyle: const TextStyle(
          color: Color(0xFFEF4444), // Red 500 halus
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),

        // Hari Terpilih (Selected Day)
        selectedDayButtonColor: primaryColor,
        selectedDayBorderColor: primaryColor,
        selectedDayTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),

        // Hari Ini (Today)
        todayButtonColor: primaryColor.withOpacity(0.12),
        todayBorderColor: primaryColor.withOpacity(0.3),
        todayTextStyle: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),

        // Hari di luar Bulan Aktif (Prev/Next Month Days)
        prevDaysTextStyle: TextStyle(
          color: Colors.grey[300],
          fontSize: 13,
        ),
        nextDaysTextStyle: TextStyle(
          color: Colors.grey[300],
          fontSize: 13,
        ),
        
        // Border Default Box Hari
        thisMonthDayBorderColor: Colors.transparent,
      ),
    );
  }
}