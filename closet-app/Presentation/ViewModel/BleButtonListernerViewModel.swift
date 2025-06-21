//
//  BleButtonListernerViewModel.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/22.
//

import Foundation
import CoreBluetooth

final class BleTemperatureViewModel: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var temperature: Float?

    private var centralManager: CBCentralManager!
    private var targetPeripheral: CBPeripheral?
    private var notifyCharacteristic: CBCharacteristic?

    private let serviceUUID = CBUUID(string: "FFE0")
    private let characteristicUUID = CBUUID(string: "FFE1")

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("🔍 Bluetooth ON - スキャン開始")
            centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        default:
            print("❌ Bluetooth未対応またはオフ: \(central.state.rawValue)")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name?.contains("ESP32-DHT11") == true {
            print("✅ デバイス発見: \(peripheral.name ?? "no name")")
            targetPeripheral = peripheral
            centralManager.stopScan()
            centralManager.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("🔗 接続成功: \(peripheral.name ?? "no name")")
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services where service.uuid == serviceUUID {
            print("🧩 サービス発見")
            peripheral.discoverCharacteristics([characteristicUUID], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics where characteristic.uuid == characteristicUUID {
            print("📡 Notifyキャラクタリスティック設定")
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

        print("📥 受信メッセージ: \(message)")

        // Temp: 25.00 C, Humidity: 65.00 %
        if let tempMatch = message.components(separatedBy: ",").first(where: { $0.contains("Temp:") }) {
            let value = tempMatch.replacingOccurrences(of: "Temp:", with: "")
                                 .replacingOccurrences(of: " C", with: "")
                                 .trimmingCharacters(in: .whitespaces)

            if let floatVal = Float(value) {
                temperature = floatVal
                print("🌡️ 温度更新: \(floatVal) ℃")
            } else {
                print("❌ 温度のFloat変換に失敗")
            }
        }
    }
}
