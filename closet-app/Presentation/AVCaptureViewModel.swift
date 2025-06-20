//
//  AVCaptureViewModel.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/20.
//

import AVFoundation
import Combine
import Foundation
import UIKit
import Vision

public class AVCaptureViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {

    public var captureSession = AVCaptureSession()
    private var mlRequest = [VNRequest]()

    @Published var identifier: String?
    @Published var confidence: Float?
    @Published var resultsText: String?
    @Published var resultsImage: String? = "sonota"
    @Published var image: UIImage?

    public override init() {
        super.init()
        setupSession()
        _ = setupVision()
    }

    func setupSession() {
        captureSession.beginConfiguration()
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              captureSession.canAddInput(input) else { return }

        captureSession.addInput(input)

        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.queue"))
        guard captureSession.canAddOutput(output) else { return }

        captureSession.addOutput(output)
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }

    func setupVision() -> NSError? {
        guard let modelURL = Bundle.main.url(forResource: "TestModel", withExtension: "mlmodelc") else {
            return NSError(domain: "Vision", code: -1, userInfo: [NSLocalizedDescriptionKey: "モデルファイルが見つかりません"])
        }

        do {
            let model = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let request = VNCoreMLRequest(model: model) { request, _ in
                DispatchQueue.main.async {
                    if let results = request.results {
                        print("🔍 Visionが結果を返しました: \(results.count)件")
                        self.handleResults(results)
                    } else {
                        print("❌ Vision結果なし")
                    }
                }
            }

            self.mlRequest = [request]
        } catch {
            print("モデル読み込みエラー:", error)
        }
        return nil
    }

    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("📸 フレームが届いた（Cameraから）")

        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("❌ バッファ取得失敗")
            return
        }

        let ciImage = CIImage(cvImageBuffer: buffer)
        let orientation = CGImagePropertyOrientation.up
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation, options: [:])

        if mlRequest.isEmpty {
            print("❗ mlRequest が空です！Visionが実行されません")
        } else {
            print("🧠 Visionリクエスト実行中...")
            try? handler.perform(self.mlRequest)
        }
    }


    private func handleResults(_ results: [Any]) {
        guard let observation = results.first as? VNClassificationObservation else {
            resultsText = "分類できませんでした"
            return
        }

        identifier = observation.identifier
        confidence = floor(observation.confidence * 100)

        // 信頼度が低い場合は accessory 扱いにする
        if observation.confidence < 0.7 {
            resultsText = "アクセサリーかもしれません"
            resultsImage = "accessory"
            return
        }

        switch observation.identifier {
        case "tops":      resultsText = "トップスです！"
        case "bottoms":   resultsText = "ボトムスです！"
        case "outer":     resultsText = "アウターです！"
        case "dress":     resultsText = "ワンピースです！"
        case "shoes":     resultsText = "靴です！"
        case "bag":       resultsText = "バッグです！"
        default:
            resultsText = "分類できませんでした"
        }
    }


}
