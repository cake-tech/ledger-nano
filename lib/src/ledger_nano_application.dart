import 'dart:typed_data';

import 'package:ledger_flutter/ledger_flutter.dart';
import 'package:ledger_nano/src/nano_app_config.dart';
import 'package:ledger_nano/src/nano_transformer.dart';
import 'package:ledger_nano/src/operations/nano_app_config_operation.dart';
import 'package:ledger_nano/src/operations/nano_cache_block_operation.dart';
import 'package:ledger_nano/src/operations/nano_sign_block_operation.dart';
import 'package:ledger_nano/src/operations/nano_sign_nonce_operation.dart';
import 'package:ledger_nano/src/operations/nano_wallet_address_operation.dart';

class NanoLedgerApp extends LedgerApp {
  final NanoTransformer transformer;

  /// The [derivationPath] is a Bip32-path used to derive the Nano account
  /// If the path is not standard, an error is returned
  String derivationPath;

  NanoLedgerApp(
    super.ledger, {
    this.transformer = const NanoTransformer(),
    this.derivationPath = "m/44'/165'/0'",
  });

  @override
  Future<List<String>> getAccounts(LedgerDevice device) async {
    final (_, address) = await ledger.sendOperation<(String, String)>(
      device,
      NanoWalletAddressOperation(derivationPath: derivationPath),
      transformer: transformer,
    );
    return [address];
  }

  @override
  Future<NanoAppConfig> getVersion(LedgerDevice device) => getAppConfig(device);

  Future<NanoAppConfig> getAppConfig(LedgerDevice device) =>
      ledger.sendOperation<NanoAppConfig>(
        device,
        NanoAppConfigOperation(),
        transformer: transformer,
      );

  @override
  Future<Uint8List> signTransaction(
          LedgerDevice device, Uint8List transaction) =>
      throw UnimplementedError(
          "This is not applicable, please cache the frontier block and then sign the send block");

  @override
  Future<List<Uint8List>> signTransactions(
          LedgerDevice device, List<Uint8List> transactions) =>
      throw UnimplementedError(
          "This is not applicable, please cache the frontier block and then sign the send block");

  /// This command returns the signature for the provided universal block data.
  /// For non-null parent blocks the validate block command needs to be called before the this command.
  Future<(String, String)> signBlock(
    LedgerDevice device, {
    required String parentBlockhash,
    required String link,
    required String representative,
    required int balance,
  }) =>
      ledger.sendOperation<(String, String)>(
        device,
        NanoSignBlockOperation(
          parentBlockhash: parentBlockhash,
          link: link,
          representative: representative,
          balance: balance,
          derivationPath: derivationPath,
        ),
        transformer: transformer,
      );

  /// This command caches the frontier block in memory. The sign block command
  /// uses this cached data to determine the changes in account state.
  Future<void> cacheBlock(
    LedgerDevice device, {
    required String parentBlockhash,
    required String link,
    required String representative,
    required int balance,
    required String signature,
  }) =>
      ledger.sendOperation<Uint8List>(
        device,
        NanoCacheBlockOperation(
          parentBlockhash: parentBlockhash,
          link: link,
          representative: representative,
          balance: balance,
          signature: signature,
          derivationPath: derivationPath,
        ),
        transformer: transformer,
      );

  /// This command signs a 128bit nonce and returns the signature.
  /// "Nano Signed Nonce:\n" + nonceBytes is the message that gets signed with the private key.
  /// This method is meant to be used as a soft-authentication (eg for APIs),
  /// to prove that the Ledger with the private key is connected.
  Future<Uint8List> signNonce(LedgerDevice device, int nonce) =>
      ledger.sendOperation<Uint8List>(
        device,
        NanoSignNonceOperation(nonce: nonce, derivationPath: derivationPath),
        transformer: transformer,
      );
}
