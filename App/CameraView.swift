//
//  CameraView.swift
//  App
//
//  Created by Kosuke on 2023/03/05.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var viewModel: CameraViewModel = .init()

    var body: some View {
        ZStack {
            switch viewModel.permissionState {
            case .notDetermined:
                Button(
                    action: { viewModel.requestAccess() }
                ) {
                    Text("Request")
                }
            case .denied:
                Text("Denied")
                Button(
                    action: { viewModel.requestAccess() }
                ) {
                    Text("Request")
                }
            case .authorized:
                Text("Granted")
                CameraPreview()
            case .restricted:
                Text("Restricted")
            }
        }
    }
}
