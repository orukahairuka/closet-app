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

extension AVCaptureViewModel {

    func captureStillImage(completion: @escaping (UIImage?) -> Void) {
        print("📸 captureStillImage called")
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        settings.isHighResolutionPhotoEnabled = true

        // delegate をプロパティに保持
        let delegate = PhotoCaptureDelegate { [weak self] image in
            completion(image)
            self?.photoCaptureDelegate = nil // 解放
        }

        self.photoCaptureDelegate = delegate
        photoOutput.capturePhoto(with: settings, delegate: delegate)
    }
}

private class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    let completion: (UIImage?) -> Void

    init(completion: @escaping (UIImage?) -> Void) {
        print("🛠 PhotoCaptureDelegate initialized")
        self.completion = completion
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        print("📥 didFinishProcessingPhoto called")

        if let error = error {
            print("❌ 写真取得エラー: \(error.localizedDescription)")
        }

        if let data = photo.fileDataRepresentation() {
            print("📦 データサイズ: \(data.count) bytes")
            if let image = UIImage(data: data) {
                print("✅ 画像取得成功")
                completion(image)
            } else {
                print("❌ UIImage変換失敗")
                completion(nil)
            }
        } else {
            print("❌ dataがnil")
            completion(nil)
        }

    }
}

public class AVCaptureViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {

    public var captureSession = AVCaptureSession()
    private var mlRequest = [VNRequest]()

    private let photoOutput = AVCapturePhotoOutput() // ← ここで持たせる

    @Published var identifier: String?
    @Published var confidence: Float?
    @Published var resultsText: String?
    @Published var resultsImage: String? = "sonota"
    @Published var image: UIImage?
    private var photoCaptureDelegate: PhotoCaptureDelegate? // ✅ ここに移動！


    public override init() {
        super.init()
        setupSession()
        _ = setupVision()
    }

    func setupSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            captureSession.beginConfiguration()

            // 入力（カメラ）
            guard let device = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: device),
                  captureSession.canAddInput(input) else {
                captureSession.commitConfiguration()
                return
            }
            captureSession.addInput(input)

            // 出力（リアルタイム映像）
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.queue"))
            guard captureSession.canAddOutput(videoOutput) else {
                captureSession.commitConfiguration()
                return
            }
            captureSession.addOutput(videoOutput)

            // ✅ 写真出力（ここ重要）
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
                photoOutput.isHighResolutionCaptureEnabled = true // ← 追加！
            }

            captureSession.commitConfiguration()
            captureSession.startRunning()
        }
    }




    func setupVision() -> NSError? {
        guard let modelURL = Bundle.main.url(forResource: "TestModel", withExtension: "mlmodelc") else {
            return NSError(domain: "Vision", code: -1, userInfo: [NSLocalizedDescriptionKey: "モデルファイルが見つかりません"])
        }

        do {
            let model = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let request = VNCoreMLRequest(model: model) { request, _ in
                DispatchQueue.main.async {
                    if let results = request.results as? [VNClassificationObservation] {
                        print("🔍 Vision結果: \(results.map { "\($0.identifier)(\($0.confidence))" })")
                        self.handleResults(results)
                    } else {
                        print("❌ Vision結果変換失敗")
                    }
                }
            }

            self.mlRequest = [request]
        } catch {
            print("モデル読み込みエラー:", error)
        }
        return nil
    }

    private var isProcessing = false

    private var lastVisionRun = Date(timeIntervalSince1970: 0)

    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let now = Date()
        guard now.timeIntervalSince(lastVisionRun) > 0.5 else {
            return // 前回から0.5秒未満ならスキップ
        }
        lastVisionRun = now

        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        let ciImage = CIImage(cvImageBuffer: buffer)
        let orientation = CGImagePropertyOrientation.up
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                print("🧠 Visionリクエスト実行中...")
                try handler.perform(self.mlRequest)
            } catch {
                print("❌ Visionエラー:", error)
            }
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
