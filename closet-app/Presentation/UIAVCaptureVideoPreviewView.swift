//
//  UIAVCaptureVideoPreviewView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/20.
//

import AVFoundation
import UIKit

public class UIAVCaptureVideoPreviewView: UIView {
    private var previewLayer: AVCaptureVideoPreviewLayer!

    public init(session: AVCaptureSession) {
        super.init(frame: .zero)
        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
        self.previewLayer.videoGravity = .resizeAspectFill
        self.layer.addSublayer(previewLayer)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
    }
}

import SwiftUI

public struct SwiftUIAVCaptureVideoPreviewView: UIViewRepresentable {
    let captureModel: AVCaptureViewModel

    public func makeUIView(context: Context) -> UIAVCaptureVideoPreviewView {
        let view = UIAVCaptureVideoPreviewView(session: captureModel.captureSession)
        return view
    }

    public func updateUIView(_ uiView: UIAVCaptureVideoPreviewView, context: Context) {
        // 更新なし
    }
}

struct ContentView: View {
    @ObservedObject var captureModel: AVCaptureViewModel
    var onClose: () -> Void  // ← 閉じる処理を呼ぶためのクロージャ

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                Button(action: {
                    onClose()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                }
            }

            if let result = captureModel.resultsText {
                Text(result)
                    .font(.title2)
                    .foregroundColor(.primary)
            }

            if let id = captureModel.identifier,
               let conf = captureModel.confidence {
                Text("カテゴリ: \(id), 確信度: \(Int(conf))%")
                    .font(.subheadline)
            }

            GeometryReader { geometry in
                SwiftUIAVCaptureVideoPreviewView(captureModel: captureModel)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .padding()
    }
}
