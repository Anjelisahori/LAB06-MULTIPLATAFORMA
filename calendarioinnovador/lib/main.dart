import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apple Calendar Premium',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: '.SF Pro Display',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CalendarApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalendarApp extends StatefulWidget {
  @override
  _CalendarAppState createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp>
    with TickerProviderStateMixin {
  bool sidebarCollapsed = false;
  String selectedView = 'Semana';
  DateTime currentDate = DateTime(2025, 10, 2);
  late AnimationController _sidebarController;
  late AnimationController _fadeController;

  Map<String, CalendarData> calendars = {
    'examen': CalendarData(
      'EXAMEN TP/PT',
      '🎯',
      Color(0xFFFFB8B8),
      true,
      'YAHOO!',
    ),
    'almuerzo': CalendarData(
      'Almuerzo',
      '🍔',
      Color(0xFFB8E7B8),
      true,
      'YAHOO!',
    ),
    'tareas': CalendarData(
      'tareas',
      '📚',
      Color(0xFFFFB8E7),
      true,
      'YAHOO!',
    ),
    'lectura': CalendarData(
      'tiempo de lectura',
      '📖',
      Color(0xFFFFE8B8),
      true,
      'YAHOO!',
    ),
    'ejercicio': CalendarData(
      'ejercicio',
      '💪',
      Color(0xFFE8B8FF),
      true,
      'YAHOO!',
    ),
    'familia': CalendarData(
      'familia',
      '👨‍👩‍👧‍👦',
      Color(0xFFFFD4B8),
      true,
      'YAHOO!',
    ),
    'autobus': CalendarData(
      'autobús',
      '🚌',
      Color(0xFFD4D4D4),
      true,
      'iCLOUD',
    ),
    'otro': CalendarData(
      'Otro',
      '',
      Colors.white,
      false,
      'iCLOUD',
    ),
    'clases': CalendarData(
      'clases',
      '📚',
      Color(0xFFB8D4FF),
      true,
      'iCLOUD',
    ),
  };

  @override
  void initState() {
    super.initState();
    _sidebarController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
          ),
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _sidebarController,
              builder: (context, child) {
                return Container(
                  width: sidebarCollapsed ? 0 : 280,
                  child: sidebarCollapsed ? null : buildPremiumSidebar(),
                );
              },
            ),
            Expanded(
              child: FadeTransition(
                opacity: _fadeController,
                child: Column(
                  children: [
                    buildPremiumHeader(),
                    Expanded(child: buildPremiumWeekView()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPremiumSidebar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.white.withOpacity(0.85),
          ],
        ),
        border: Border(
          right: BorderSide(color: Colors.black.withOpacity(0.08), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildPremiumSidebarHeader(),
              buildPremiumMiniCalendar(),
              SizedBox(height: 24),
              Expanded(child: buildPremiumCalendarsList()),
              buildPremiumBottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPremiumSidebarHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF667EEA).withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.calendar_today_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Calendarios',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1D29),
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPremiumMiniCalendar() {
    DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    int daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;
    int firstWeekday = firstDayOfMonth.weekday;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavButton(Icons.chevron_left_rounded, () {}),
              Text(
                'Octubre 2025',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF2D3748),
                ),
              ),
              _buildNavButton(Icons.chevron_right_rounded, () {}),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 140,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: 35,
              itemBuilder: (context, index) {
                int dayNumber = index - firstWeekday + 2;
                bool isValidDay = dayNumber >= 1 && dayNumber <= daysInMonth;
                bool isToday = isValidDay && dayNumber == currentDate.day;
                bool hasEvents = isValidDay && [1, 2, 3, 4, 30].contains(dayNumber);

                return AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: isToday
                        ? LinearGradient(
                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          )
                        : null,
                    color: !isToday && hasEvents
                        ? Colors.blue.withOpacity(0.1)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isToday
                        ? [
                            BoxShadow(
                              color: Color(0xFF667EEA).withOpacity(0.4),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: isValidDay ? () {} : null,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isValidDay)
                              Text(
                                '$dayNumber',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isToday
                                      ? Colors.white
                                      : Color(0xFF2D3748),
                                ),
                              ),
                            if (hasEvents && !isToday)
                              Container(
                                width: 4,
                                height: 4,
                                margin: EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Icon(icon, size: 18, color: Color(0xFF4A5568)),
          ),
        ),
      ),
    );
  }

  Widget buildPremiumCalendarsList() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        buildPremiumSectionHeader('YAHOO!'),
        ...calendars.values
            .where((cal) => cal.section == 'YAHOO!')
            .map((cal) => buildPremiumCalendarItem(cal))
            .toList(),
        SizedBox(height: 20),
        buildPremiumSectionHeader('iCLOUD'),
        ...calendars.values
            .where((cal) => cal.section == 'iCLOUD')
            .map((cal) => buildPremiumCalendarItem(cal))
            .toList(),
      ],
    );
  }

  Widget buildPremiumSectionHeader(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF667EEA).withOpacity(0.1),
                  Color(0xFF764BA2).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4A5568),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Text(
            'OCULTAR TODO',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF718096),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPremiumCalendarItem(CalendarData calendar) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              calendar.isVisible = !calendar.isVisible;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: calendar.isVisible
                  ? calendar.color.withOpacity(0.3)
                  : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: calendar.isVisible
                    ? calendar.color.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildPremiumCheckbox(calendar),
                SizedBox(width: 12),
                if (calendar.emoji.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      calendar.emoji,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    calendar.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumCheckbox(CalendarData calendar) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        gradient: calendar.isVisible
            ? LinearGradient(
                colors: [calendar.color, calendar.color.withOpacity(0.8)],
              )
            : null,
        color: calendar.isVisible ? null : Colors.transparent,
        border: Border.all(color: calendar.color, width: 2.5),
        borderRadius: BorderRadius.circular(6),
        boxShadow: calendar.isVisible
            ? [
                BoxShadow(
                  color: calendar.color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: calendar.isVisible
          ? Icon(Icons.check_rounded, size: 14, color: Colors.white)
          : null,
    );
  }

  Widget buildPremiumBottomActions() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildActionButton(
            'Agregar calendario',
            Icons.add_rounded,
            Color(0xFFFF6B6B),
            () {},
          ),
          SizedBox(height: 8),
          _buildActionButton(
            'Mostrar todo',
            Icons.visibility_rounded,
            Color(0xFF4ECDC4),
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: color),
                SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPremiumHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white.withOpacity(0.95)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: ['Día', 'Semana', 'Mes', 'Año'].map((view) {
                  bool isSelected = view == selectedView;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            selectedView = view;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [
                                      Color(0xFF667EEA),
                                      Color(0xFF764BA2),
                                    ],
                                  )
                                : null,
                            color: isSelected ? null : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Color(0xFF667EEA).withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                          ),
                          child: Text(
                            view,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : Color(0xFF4A5568),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF667EEA).withOpacity(0.1),
                      Color(0xFF764BA2).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Octubre 2025',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                    letterSpacing: -1,
                  ),
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF4ECDC4).withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        "Hoy",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: Color(0xFF718096), size: 18),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Buscar eventos, personas...',
                    style: TextStyle(
                      color: Color(0xFF718096),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.mic_rounded, color: Colors.white, size: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPremiumWeekView() {
    List<DateTime> weekDays = getWeekDays();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFFAFBFC)],
        ),
      ),
      child: Column(
        children: [
          buildPremiumWeekHeader(weekDays),
          Expanded(child: buildPremiumWeekGrid(weekDays)),
        ],
      ),
    );
  }

  List<DateTime> getWeekDays() {
    DateTime startOfWeek = currentDate.subtract(
      Duration(days: currentDate.weekday - 1),
    );
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  Widget buildPremiumWeekHeader(List<DateTime> weekDays) {
    List<String> dayNames = [
      'lun.',
      'mar.',
      'mié.',
      'jue.',
      'vie.',
      'sáb.',
      'dom.',
    ];
    List<String> monthNames = [
      '',
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];

    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white.withOpacity(0.95)],
        ),
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.06), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(width: 80),
          ...weekDays.map((day) {
            bool isPreviousMonth = day.month != currentDate.month && day.isBefore(currentDate);
            bool isCurrentDay =
                day.day == currentDate.day && day.month == currentDate.month;

            return Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: isPreviousMonth
                      ? LinearGradient(
                          colors: [Colors.grey[50]!, Colors.grey[100]!],
                        )
                      : null,
                  border: Border(
                    left: BorderSide(color: Colors.black.withOpacity(0.04)),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayNames[day.weekday - 1],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF718096),
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: isCurrentDay
                                ? LinearGradient(
                                    colors: [
                                      Color(0xFF667EEA),
                                      Color(0xFF764BA2),
                                    ],
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isCurrentDay
                                ? [
                                    BoxShadow(
                                      color: Color(0xFF667EEA).withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: isCurrentDay
                                  ? Colors.white
                                  : Color(0xFF2D3748),
                            ),
                          ),
                        ),
                        if (isPreviousMonth) ...[
                          SizedBox(width: 6),
                          Text(
                            monthNames[day.month],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget buildPremiumWeekGrid(List<DateTime> weekDays) {
    List<int> hours = List.generate(15, (index) => index + 8);

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.white, Colors.white.withOpacity(0.95)],
              ),
            ),
            child: Column(
              children: hours.map((hour) {
                return Container(
                  height: 120,
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(right: 12, top: 8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      '${hour.toString().padLeft(2, '0')}:00',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          ...weekDays.asMap().entries.map((entry) {
            int dayIndex = entry.key;
            DateTime day = entry.value;

            return Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.black.withOpacity(0.04)),
                  ),
                ),
                child: Column(
                  children: hours.map((hour) {
                    return Container(
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black.withOpacity(0.02),
                          ),
                        ),
                        gradient: hour % 2 == 0
                            ? LinearGradient(
                                colors: [Colors.white, Color(0xFFFAFBFC)],
                              )
                            : null,
                      ),
                      child: buildPremiumEventsForHour(dayIndex, hour),
                    );
                  }).toList(),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget buildPremiumEventsForHour(int dayIndex, int hour) {
    List<Event> events = getEventsForDayAndHour(dayIndex, hour);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: events.map((event) {
          CalendarData? calendar = calendars[event.calendarKey];
          if (calendar == null || !calendar.isVisible) return Container();

          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 400),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Opacity(
                  opacity: value,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: calendar.color,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          _showEventDetails(event, calendar);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (calendar.emoji.isNotEmpty) ...[
                                Text(
                                  calendar.emoji,
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(width: 8),
                              ],
                              Flexible(
                                child: Text(
                                  event.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  void _showEventDetails(Event event, CalendarData calendar) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, calendar.color.withOpacity(0.05)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          calendar.color,
                          calendar.color.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      calendar.emoji.isNotEmpty ? calendar.emoji : '📅',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1D29),
                          ),
                        ),
                        Text(
                          '${event.hour}:00 - ${event.hour + 1}:00',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: calendar.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: calendar.color,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Calendario: ${calendar.name}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: calendar.color,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cerrar',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          calendar.color,
                          calendar.color.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: calendar.color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Text(
                            'Editar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Event> getEventsForDayAndHour(int dayIndex, int hour) {
    Map<String, List<Event>> dayEvents = {
      '0': [
        Event(8, 'autobus', 'autobús', '🚌'),
        Event(9, 'clases', 'clases', '📚'),
        Event(11, 'examen', 'PROG. HIST...', '🎯'),
        Event(12, 'almuerzo', 'Almuerzo con amigos', '🍔'),
        Event(14, 'clases', 'clases', '📚'),
        Event(17, 'autobus', 'autobús', '🚌'),
        Event(18, 'tareas', 'tareas', '📚'),
        Event(19, 'familia', 'familia', '👨‍👩‍👧‍👦'),
      ],
      '1': [
        Event(8, 'autobus', 'autobús', '🚌'),
        Event(9, 'clases', 'clases', '📚'),
        Event(12, 'almuerzo', 'Almuerzo con amigos', '🍔'),
        Event(14, 'clases', 'clases', '📚'),
        Event(16, 'autobus', 'autobús', '🚌'),
        Event(17, 'tareas', 'tareas', '📚'),
      ],
      '2': [
        Event(8, 'autobus', 'autobús', '🚌'),
        Event(9, 'clases', 'clases', '📚'),
        Event(11, 'examen', 'EXAMEN TP/PT', '🎯'),
        Event(12, 'almuerzo', 'Almuerzo con amigos', '🍔'),
        Event(14, 'clases', 'clases', '📚'),
        Event(17, 'autobus', 'autobús', '🚌'),
      ],
      '3': [
        Event(8, 'autobus', 'autobús', '🚌'),
        Event(9, 'clases', 'clases', '📚'),
        Event(10, 'tareas', 'figuras de estilo...', '📚'),
        Event(11, 'clases', 'clases', '📚'),
        Event(12, 'almuerzo', 'Almuerzo con amigos', '🍔'),
        Event(14, 'clases', 'clases', '📚'),
        Event(16, 'autobus', 'autobús', '🚌'),
      ],
      '4': [
        Event(8, 'autobus', 'autobús', '🚌'),
        Event(9, 'clases', 'clases', '📚'),
        Event(12, 'almuerzo', 'Almuerzo con amigos', '🍔'),
        Event(14, 'clases', 'clases', '📚'),
        Event(16, 'autobus', 'autobús', '🚌'),
      ],
    };

    List<Event> events = dayEvents['$dayIndex'] ?? [];
    return events.where((event) => event.hour == hour).toList();
  }
}

class CalendarData {
  String name;
  String emoji;
  Color color;
  bool isVisible;
  String section;

  CalendarData(this.name, this.emoji, this.color, this.isVisible, this.section);
}

class Event {
  int hour;
  String calendarKey;
  String title;
  String emoji;

  Event(this.hour, this.calendarKey, this.title, this.emoji);
}