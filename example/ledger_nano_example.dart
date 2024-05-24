import 'package:ledger_nano/ledger_nano.dart';
import 'package:ledger_flutter/ledger_flutter.dart';

Future<void> main() async {
  /// Create a new instance of LedgerOptions.
  final options = LedgerOptions(
    maxScanDuration: const Duration(milliseconds: 5000),
  );

  /// Create a new instance of Ledger.
  final ledger = Ledger(
    options: options,
  );

  /// Create a new Ethereum Ledger Plugin.
  final nanoApp = NanoLedgerApp(ledger);

  /// Scan for devices
  ledger.scan().listen((device) => print(device));

  /// or get a connected one
  final device = ledger.devices.first;

  /// Fetch a list of accounts/public keys from your ledger.
  final accounts = await nanoApp.getAccounts(device);

  print(accounts);
}
