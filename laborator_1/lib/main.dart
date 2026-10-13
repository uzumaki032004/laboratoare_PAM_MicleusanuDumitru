import 'package:flutter/material.dart';

import 'imc.dart';

void main() => runApp(const ImcApp());

class ImcApp extends StatelessWidget {
  const ImcApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Calculator IMC',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF147D73)),
      scaffoldBackgroundColor: const Color(0xFFF4F8F7),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    ),
    home: const CalculatorScreen(),
  );
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _weight = TextEditingController();
  final _height = TextEditingController();
  String? _weightError;
  String? _heightError;
  String? _calculationError;
  ImcResult? _result;

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    super.dispose();
  }

  void _invalidate(String _) => setState(() {
    _result = null;
    _weightError = null;
    _heightError = null;
    _calculationError = null;
  });

  void _calculate() {
    FocusScope.of(context).unfocus();
    final weight = parseMeasurement(_weight.text);
    final height = parseMeasurement(_height.text);
    setState(() {
      _result = null;
      _calculationError = null;
      _weightError = weight == null
          ? 'Introdu o greutate pozitivă în kg.'
          : null;
      _heightError = height == null
          ? 'Introdu o înălțime pozitivă în cm.'
          : null;
      if (weight != null && height != null) {
        try {
          _result = calculateImc(weight, height);
        } on ArgumentError {
          _calculationError =
              'Verifică valorile: sunt prea mari sau prea mici.';
        }
      }
    });
  }

  Color _categoryColor(ImcCategory category) => switch (category) {
    ImcCategory.underweight => const Color(0xFF245DA8),
    ImcCategory.normal => const Color(0xFF147D73),
    ImcCategory.overweight => const Color(0xFF956200),
    _ => const Color(0xFFB33434),
  };

  @override
  Widget build(BuildContext context) {
    final result = _result;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator IMC'),
        backgroundColor: const Color(0xFFF4F8F7),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.monitor_weight_outlined,
                    size: 56,
                    color: Color(0xFF147D73),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Indicele tău de masă corporală',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Introdu greutatea și înălțimea, apoi calculează IMC.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    key: const Key('weight'),
                    controller: _weight,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: _invalidate,
                    decoration: InputDecoration(
                      labelText: 'Greutate (kg)',
                      hintText: 'Exemplu: 70',
                      suffixText: 'kg',
                      errorText: _weightError,
                      prefixIcon: const Icon(Icons.monitor_weight_outlined),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    key: const Key('height'),
                    controller: _height,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged: _invalidate,
                    onSubmitted: (_) => _calculate(),
                    decoration: InputDecoration(
                      labelText: 'Înălțime (cm)',
                      hintText: 'Exemplu: 175',
                      suffixText: 'cm',
                      errorText: _heightError,
                      prefixIcon: const Icon(Icons.height),
                    ),
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton.icon(
                    onPressed: _calculate,
                    icon: const Icon(Icons.calculate_outlined),
                    label: const Text('Calculează IMC'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF147D73),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_calculationError != null)
                    Text(
                      _calculationError!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  if (result != null)
                    Semantics(
                      liveRegion: true,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _categoryColor(result.category),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text('Rezultatul tău'),
                            const SizedBox(height: 8),
                            Text(
                              'IMC: ${result.value.toStringAsFixed(2)}',
                              key: const Key('result'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _categoryColor(result.category),
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              result.category.label,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: _categoryColor(result.category),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_calculationError == null)
                    const Text(
                      'Rezultatul va apărea aici.',
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 28),
                  const Text(
                    'Cum se calculează?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'IMC = greutate (kg) / înălțime (m)²\n'
                    'Înălțimea introdusă în cm se împarte la 100.',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Categorii pentru adulți\n'
                    'Subponderal: < 18,5\nNormal: 18,5 – < 25\n'
                    'Supraponderal: 25 – < 30\nObezitate grad I: 30 – < 35\n'
                    'Obezitate grad II: 35 – < 40\nObezitate grad III: ≥ 40',
                    style: TextStyle(height: 1.6),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Laboratorul 1 · Varianta 2',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
