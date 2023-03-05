//
//  CameraPreview.swift
//  App
//
//  Created by Kosuke on 2023/03/05.
//

import AVFoundation
import Combine
import SwiftUI

struct CameraPreview: UIViewRepresentable {
    private var camera: CameraModel = .init()
    private var preview: PreviewView = .init()

    func makeUIView(context: Context) -> some UIView {
        camera.configureSession()
        preview.session = camera.session
        camera.start()
        return preview
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}

class CameraModel: ObservableObject {
    let session: AVCaptureSession = AVCaptureSession()
    func configureSession() {
        do {
            guard
                let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            else {
                fatalError("camera not found")
            }
            let input = try AVCaptureDeviceInput(device: cameraDevice)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                print("Couldn't create video device input to the session")
                return
            }
        } catch {
            print("Couldn't create video device input: \(error)")
            return
        }
    }

    func start() {
        Task{
            session.startRunning()
        }
    }
}

private class PreviewView: UIView {
    private var orientationListener: AnyCancellable?

    private var currentOrientation: AVCaptureVideoOrientation {
        return AVCaptureVideoOrientation(deviceOrientation: UIDevice.current.orientation) ?? .portrait
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupOrientationListner()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupOrientationListner()
    }

    private func setupOrientationListner() {
        guard orientationListener == nil else {
            return
        }
        orientationListener = NotificationCenter.default.publisher(
            for: UIDevice.orientationDidChangeNotification
        )
        .compactMap { ($0.object as? UIDevice)?.orientation }
        .compactMap { AVCaptureVideoOrientation(deviceOrientation: $0) }
        .receive(on: RunLoop.main)
        .sink { orientation in
            self.videoPreviewLayer.connection?.videoOrientation = orientation
        }
    }

    deinit {
        orientationListener?.cancel()
    }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError(
                "Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation."
            )
        }
        layer.videoGravity = .resizeAspectFill
        return layer
    }

    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
            videoPreviewLayer.connection?.videoOrientation = currentOrientation
        }
    }

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}

extension AVCaptureVideoOrientation {
    init?(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeRight
        case .landscapeRight: self = .landscapeLeft
        default: return nil
        }
    }

    init?(interfaceOrientation: UIInterfaceOrientation?) {
        switch interfaceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeLeft
        case .landscapeRight: self = .landscapeRight
        default: return nil
        }
    }
}
