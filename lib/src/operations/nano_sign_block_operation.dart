import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:ledger_flutter/ledger_flutter.dart';
import 'package:ledger_nano/src/ledger/ledger_input_operation.dart';
import 'package:ledger_nano/src/ledger/nano_instructions.dart';
import 'package:ledger_nano/src/utils/bip32_path_helper.dart';
import 'package:ledger_nano/src/utils/bip32_path_to_buffer.dart';
import 'package:ledger_nano/src/utils/string_uint8list_extension.dart';

/// This command returns the signature for the provided universal block data.
/// For non-null parent blocks the validate block command needs to be called before the this command.
class NanoSignBlockOperation extends LedgerInputOperation<(String, String)> {
  /// The [derivationPath] is a Bip32-path used to derive the address
  /// If the path is not standard, an error is returned
  final String derivationPath;

  final String parentBlockhash;
  final String link;
  final String representative;
  final int balance;

  NanoSignBlockOperation({
    this.derivationPath = "m/44'/165'/0'",
    required this.parentBlockhash,
    required this.link,
    required this.representative,
    required this.balance,
  }) : super(nanoCLA, cacheBlockINS);

  @override
  Future<(String, String)> read(ByteDataReader reader) async {
    final response = reader.read(reader.remainingLength);

    final blockHash = response.sublist(0, 32); // 32 bits
    final signature = response.sublist(32, 96); // 64 bits

    return (blockHash.toHexString(), signature.toHexString());
  }

  @override
  int get p1 => 0x00;

  @override
  int get p2 => 0x00;

  @override
  Future<Uint8List> writeInputData() async {
    final writer = ByteDataWriter();

    final path = BIPPath.fromString(derivationPath).toPathArray();
    writer.write(packDerivationPath(path));

    writer.write(hex.decode(parentBlockhash));
    writer.write(hex.decode(link));
    writer.write(hex.decode(representative));
    writer.writeUint16(balance);
    return writer.toBytes();
  }
}
