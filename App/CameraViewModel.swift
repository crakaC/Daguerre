//
//  CameraViewModel.swift
//  App
//
//  Created by Kosuke on 2023/03/05.
//

import AVKit
import Foundation

@MainActor
class CameraViewModel: ObservableObject {
    @Published var permissionState: CameraPermissionState = .notDetermined

    init() {
        checkAuthorizationStatus()
    }

    func checkAuthorizationStatus() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionState = .authorized
        case .denied:
            requestAccess()
        case .notDetermined:
            requestAccess()
        case .restricted:
            permissionState = .restricted
        @unknown default:
            fatalError()
        }
    }

    func requestAccess() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.permissionState = .authorized
                } else {
                    self.permissionState = .denied
                }
            }
        }
    }
}

enum CameraPermissionState {
    case notDetermined
    case authorized
    case denied
    case restricted
}
