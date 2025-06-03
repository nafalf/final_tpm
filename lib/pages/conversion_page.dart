import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConversionPage extends StatefulWidget {
  const ConversionPage({super.key});

  @override
  State<ConversionPage> createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {
  // === TIME CONVERSION DATA === //
  static const Map<String, int> _timeZones = {
    'WIB (Jakarta)': 7,
    'WITA (Makassar)': 8,
    'WIT (Jayapura)': 9,
    'London (GMT)': 0,
    'New York (EST)': -5,
    'Tokyo (JST)': 9,
  };

  String _selectedTimeFrom = 'WIB (Jakarta)';
  String _selectedTimeTo = 'London (GMT)';
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _convertedTime = '';

  // === CURRENCY CONVERSION DATA === //
  final TextEditingController _amountController = TextEditingController();
  
  static const Map<String, double> _currencyRatesToIDR = {
    'IDR': 1,
    'USD': 15500,
    'EUR': 17000,
    'JPY': 110,
  };

  String _selectedCurrencyFrom = 'IDR';
  String _selectedCurrencyTo = 'USD';
  String _convertedCurrency = '';

  @override
  void initState() {
    super.initState();
    _convertTime();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // === TIME CONVERSION METHODS === //
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      _convertTime();
    }
  }

  void _convertTime() {
    final fromOffset = _timeZones[_selectedTimeFrom]!;
    final toOffset = _timeZones[_selectedTimeTo]!;

    // Create a base DateTime for calculation
    final baseDateTime = DateTime(2023, 1, 1, _selectedTime.hour, _selectedTime.minute);
    
    // Convert to UTC, then to target timezone
    final utcTime = baseDateTime.subtract(Duration(hours: fromOffset));
    final convertedLocalTime = utcTime.add(Duration(hours: toOffset));

    final formatter = DateFormat('HH:mm');
    setState(() {
      _convertedTime = formatter.format(convertedLocalTime);
    });
  }

  // === CURRENCY CONVERSION METHODS === //
  void _convertCurrency() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    
    if (amount == 0) {
      setState(() {
        _convertedCurrency = '';
      });
      return;
    }

    final rateFrom = _currencyRatesToIDR[_selectedCurrencyFrom]!;
    final rateTo = _currencyRatesToIDR[_selectedCurrencyTo]!;
    final result = amount * rateFrom / rateTo;

    setState(() {
      _convertedCurrency = '${NumberFormat.currency(
        symbol: '',
        decimalDigits: 2,
      ).format(result)} $_selectedCurrencyTo';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Waktu & Mata Uang'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.green[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTimeConversionSection(),
            const SizedBox(height: 40),
            _buildCurrencyConversionSection(),
          ],
        ),
      ),
    );
  }

  // === TIME CONVERSION UI === //
  Widget _buildTimeConversionSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Konversi Waktu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            
            // Time Picker Button
            ElevatedButton.icon(
              onPressed: () => _selectTime(context),
              icon: const Icon(Icons.access_time),
              label: Text(
                'Waktu: ${_selectedTime.format(context)}',
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[100],
                foregroundColor: Colors.green[800],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Timezone Selectors
            Row(
              children: [
                Expanded(
                  child: _buildTimeZoneDropdown(
                    'Dari:',
                    _selectedTimeFrom,
                    (value) {
                      setState(() => _selectedTimeFrom = value!);
                      _convertTime();
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.arrow_forward, size: 24, color: Colors.green),
                ),
                Expanded(
                  child: _buildTimeZoneDropdown(
                    'Ke:',
                    _selectedTimeTo,
                    (value) {
                      setState(() => _selectedTimeTo = value!);
                      _convertTime();
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Result
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Column(
                children: [
                  const Text(
                    'Hasil Konversi:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _convertedTime,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeZoneDropdown(String label, String value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: _timeZones.keys.map((tz) {
                return DropdownMenuItem(
                  value: tz,
                  child: Text(tz, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // === CURRENCY CONVERSION UI === //
  Widget _buildCurrencyConversionSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Konversi Mata Uang',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            
            // Amount Input
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Masukkan Nominal',
                prefixIcon: const Icon(Icons.attach_money, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.green[600]!),
                ),
              ),
              onChanged: (_) => _convertCurrency(),
            ),
            
            const SizedBox(height: 20),
            
            // Currency Selectors
            Row(
              children: [
                Expanded(
                  child: _buildCurrencyDropdown(
                    'Dari:',
                    _selectedCurrencyFrom,
                    (value) {
                      setState(() => _selectedCurrencyFrom = value!);
                      _convertCurrency();
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.swap_horiz, size: 28, color: Colors.green),
                ),
                Expanded(
                  child: _buildCurrencyDropdown(
                    'Ke:',
                    _selectedCurrencyTo,
                    (value) {
                      setState(() => _selectedCurrencyTo = value!);
                      _convertCurrency();
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Result
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Column(
                children: [
                  const Text(
                    'Hasil Konversi:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _convertedCurrency.isEmpty ? '-' : _convertedCurrency,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown(String label, String value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: _currencyRatesToIDR.keys.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency, style: const TextStyle(fontSize: 16)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}