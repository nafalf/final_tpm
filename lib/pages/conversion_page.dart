import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConversionPage extends StatefulWidget {
  const ConversionPage({super.key});

  @override
  State<ConversionPage> createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {
  // === KONVERSI WAKTU === //
  final Map<String, int> timeZones = {
    'WIB (Jakarta)': 7,
    'WITA (Makassar)': 8,
    'WIT (Jayapura)': 9,
    'London (GMT)': 0,
    'New York (EST)': -5,
    'Tokyo (JST)': 9,
  };

  String selectedTimeFrom = 'WIB (Jakarta)';
  String selectedTimeTo = 'London (GMT)';
  TimeOfDay selectedTime = TimeOfDay.now();
  String convertedTime = '';

  // === KONVERSI MATA UANG === //
  final TextEditingController amountController = TextEditingController();
  final Map<String, double> currencyRatesToIDR = {
    'IDR': 1,
    'USD': 15500,
    'EUR': 17000,
    'JPY': 110,
  };

  String selectedCurrencyFrom = 'IDR';
  String selectedCurrencyTo = 'USD';
  String convertedCurrency = '';

  // == Fungsi Konversi Waktu ==
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      convertTime();
    }
  }

  void convertTime() {
    final fromOffset = timeZones[selectedTimeFrom]!;
    final toOffset = timeZones[selectedTimeTo]!;

    DateTime inputLocalTime =
        DateTime(2023, 1, 1, selectedTime.hour, selectedTime.minute);
    DateTime timeUtc = inputLocalTime.subtract(Duration(hours: fromOffset));
    DateTime convertedLocalTime = timeUtc.add(Duration(hours: toOffset));

    final formatter = DateFormat('HH:mm');
    setState(() {
      convertedTime = formatter.format(convertedLocalTime);
    });
  }

  // == Fungsi Konversi Mata Uang ==
  void convertCurrency() {
    double amount = double.tryParse(amountController.text) ?? 0;

    double rateFrom = currencyRatesToIDR[selectedCurrencyFrom]!;
    double rateTo = currencyRatesToIDR[selectedCurrencyTo]!;

    double result = amount * rateFrom / rateTo;

    setState(() {
      convertedCurrency = '${NumberFormat.currency(symbol: '', decimalDigits: 2)
              .format(result)} $selectedCurrencyTo';
    });
  }

  @override
  void initState() {
    super.initState();
    convertTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Waktu & Mata Uang'),
        backgroundColor: Colors.green[800],
      ),
      backgroundColor: Colors.green[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // === BAGIAN WAKTU ===
              const Text(
                'Konversi Waktu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => selectTime(context),
                child: Text(
                  'Waktu: ${selectedTime.format(context)}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedTimeFrom,
                    items: timeZones.keys
                        .map(
                          (tz) => DropdownMenuItem(value: tz, child: Text(tz)),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedTimeFrom = val!;
                      });
                      convertTime();
                    },
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward, size: 30),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: selectedTimeTo,
                    items: timeZones.keys
                        .map(
                          (tz) => DropdownMenuItem(value: tz, child: Text(tz)),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedTimeTo = val!;
                      });
                      convertTime();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Hasil: $convertedTime',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // === BAGIAN MATA UANG ===
              const Text(
                'Konversi Mata Uang',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Masukkan nominal',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => convertCurrency(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 100,
                    child: DropdownButton<String>(
                      value: selectedCurrencyFrom,
                      isExpanded: true,
                      items: currencyRatesToIDR.keys
                          .map(
                            (currency) =>
                                DropdownMenuItem(value: currency, child: Text(currency)),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() => selectedCurrencyFrom = val!);
                        convertCurrency();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.swap_horiz, size: 32),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 100,
                    child: DropdownButton<String>(
                      value: selectedCurrencyTo,
                      isExpanded: true,
                      items: currencyRatesToIDR.keys
                          .map(
                            (currency) =>
                                DropdownMenuItem(value: currency, child: Text(currency)),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() => selectedCurrencyTo = val!);
                        convertCurrency();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Hasil: $convertedCurrency',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
