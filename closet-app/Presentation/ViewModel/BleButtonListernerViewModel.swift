//
//  BleButtonListernerViewModel.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/22.
//

import Foundation
import CoreBluetooth

final class BleTemperatureListenerViewModel: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var temperature: Float?
    @Published var log: String = "🔌 初期化待ち"

    private var centralManager: CBCentralManager!
    private var targetPeripheral: CBPeripheral?
    private var notifyCharacteristic: CBCharacteristic?

    private var targetServiceUUID: CBUUID!
    private var notifyCharacteristicUUID: CBUUID!

    override init() {
        super.init()
        print("📡 [BLE] ViewModel init")  // ← ここを追加！
        setupUUID()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    /// 🔧 ユーザー名の末尾に応じてUUID切り替え
    private func setupUUID() {
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let userSuffix = username.suffix(1)
        print("🧩 UUID切替: username=\(username), suffix=\(userSuffix)")

        if userSuffix == "2" {
            targetServiceUUID = CBUUID(string: "12345678-0002-0002-0002-123456789ABC")
            notifyCharacteristicUUID = CBUUID(string: "87654321-0002-0002-0002-CBA987654321")
        } else {
            targetServiceUUID = CBUUID(string: "12345678-1234-1234-1234-123456789ABC")
            notifyCharacteristicUUID = CBUUID(string: "87654321-4321-4321-4321-CBA987654321")
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("🔍 Bluetooth ON - スキャン開始")
            setupUUID()
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("❌ Bluetooth未対応またはオフ: \(central.state.rawValue)")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let name = peripheral.name ?? "no name"
        print("📡 発見: \(name) (\(peripheral.identifier)) RSSI: \(RSSI)")
        print("📦 advertisementData: \(advertisementData)")

        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let userSuffix = username.suffix(1)

        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            print("🔍 広告名: \(localName)")

            if localName.contains("ESP32 BLE Temp") {
                connectTo(peripheral)
            }
        }
    }

    private func connectTo(_ peripheral: CBPeripheral) {
        print("✅ 対象デバイス発見: \(peripheral.name ?? "no name")")
        targetPeripheral = peripheral
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("🔗 接続成功: \(peripheral.name ?? "no name")")
        peripheral.delegate = self
        peripheral.discoverServices([targetServiceUUID])
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services where service.uuid == targetServiceUUID {
            print("🧩 対象サービス発見: \(service.uuid)")
            peripheral.discoverCharacteristics([notifyCharacteristicUUID], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics where characteristic.uuid == notifyCharacteristicUUID {
            print("📡 Notifyキャラクタリスティック発見: \(characteristic.uuid)")
            notifyCharacteristic = characteristic
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value,
              let message = String(data: data, encoding: .utf8) else {
            print("⚠️ データ受信失敗")
            return
        }

        print("📥 通知受信（文字列）: \(message)")

        if let floatVal = Float(message.trimmingCharacters(in: .whitespacesAndNewlines)) {
            temperature = floatVal
            print("🌡️ 温度更新: \(floatVal) ℃")
        } else {
            print("❌ Float変換失敗")
        }
    }
}
