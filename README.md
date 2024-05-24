<br />
<div align="center">
  <img src="https://nano.org/images/common/nano-logo.svg" width="600"/>

<h1 align="center">ledger-nano</h1>

<p align="center">
    A Flutter plugin to scan, connect & sign transactions using Ledger Nano devices using USB & BLE
    <br />
    <a href="https://pub.dev/documentation/ledger_flutter/latest/"><strong>« Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/cake-tech/ledger-nano/issues">Report Bug</a>
    · <a href="https://github.com/cake-tech/ledger-nano/issues">Request Feature</a>
  </p>
</div>
<br/>

## Overview

Ledger Nano devices are the perfect hardware wallets for managing your crypto & NFTs on the go.
This Flutter package is a plugin for the [ledger_flutter](https://pub.dev/packages/ledger_flutter) package to get accounts and sign transactions using the 
Nano blockchain.

### Supported devices

|         | BLE                | USB                |
|---------|--------------------|--------------------|
| Android | :heavy_check_mark: | :heavy_check_mark: |
| iOS     | :heavy_check_mark: | :x:                |

### Installation

Install the latest version of this package via pub.dev:

```yaml
ledger_nano: ^latest-version
```

For integration with the Ledger Flutter package, check out the documentation [here](https://pub.dev/packages/ledger_flutter).

### Setup

Create a new instance of an `NanoLedgerApp` and pass an instance of your `Ledger` object.

```dart
final app = NanoLedgerApp(ledger);
```

## Usage

### Get public keys

Depending on the required blockchain and Ledger Application Plugin, the `getAccounts()` method can be used to fetch the 
public keys from the Ledger Nano device.

Based on the implementation and supported protocol, there might be only one public key in the list of accounts.

```dart
final accounts = await app.getAccounts(device);
```
