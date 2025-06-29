import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  ThemeData get _darkTheme => ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Color(0xFF121212),
    primaryColor: Colors.blueAccent,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(vertical: 14),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );

  ThemeData get _lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey[100],
    primaryColor: Colors.blueAccent,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(vertical: 14),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[300],
      iconTheme: IconThemeData(color: Colors.black),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pro Calculator',
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: CalculatorPage(
          isDarkMode: _isDarkMode,
          onToggleTheme: _toggleTheme,
        ),
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  CalculatorPage({required this.isDarkMode, required this.onToggleTheme});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _input = '';
  String _result = '';

  void _append(String value) {
    setState(() {
      _input += value;
    });
  }

  void _clear() {
    setState(() {
      _input = '';
      _result = '';
    });
  }

  void _calculate() {
    try {
      String expression = _input.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _result = '= $eval';
        _input = eval.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  Widget _buildButton(String label, {Color? color, VoidCallback? onTap}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: widget.isDarkMode ? Colors.white : Colors.black,
            textStyle: TextStyle(fontSize: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: onTap ?? () => _append(label),
          child: Text(label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pour les couleurs des boutons (adaptés au thème)
    final bgColorDefault = widget.isDarkMode ? Color(0xFF1E1E1E) : Colors.grey[300];
    final colorOperator = widget.isDarkMode ? Colors.blueAccent : Colors.blueAccent;
    final colorClear = Colors.redAccent;
    final colorEqual = Colors.greenAccent;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pro Calculator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            tooltip: 'Toggle Light/Dark Mode',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColorDefault,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _input,
                      style: TextStyle(
                        fontSize: 36,
                        color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _result,
                      style: TextStyle(
                        fontSize: 48,
                        color: widget.isDarkMode ? Colors.blueAccent : Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: widget.isDarkMode ? Colors.grey[800] : Colors.grey),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('(', color: widget.isDarkMode ? Colors.blueGrey : Colors.blueGrey),
                    _buildButton(')', color: widget.isDarkMode ? Colors.blueGrey : Colors.blueGrey),
                    _buildButton('.', color: widget.isDarkMode ? Colors.blueGrey : Colors.blueGrey),
                    _buildButton('÷', color: colorOperator),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7', color: bgColorDefault),
                    _buildButton('8', color: bgColorDefault),
                    _buildButton('9', color: bgColorDefault),
                    _buildButton('×', color: colorOperator),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4', color: bgColorDefault),
                    _buildButton('5', color: bgColorDefault),
                    _buildButton('6', color: bgColorDefault),
                    _buildButton('-', color: colorOperator),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1', color: bgColorDefault),
                    _buildButton('2', color: bgColorDefault),
                    _buildButton('3', color: bgColorDefault),
                    _buildButton('+', color: colorOperator),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('0', color: bgColorDefault),
                    _buildButton('C', color: colorClear, onTap: _clear),
                    _buildButton('=', color: colorEqual, onTap: _calculate),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
