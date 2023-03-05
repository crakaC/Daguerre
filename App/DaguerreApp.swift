import SwiftUI

@main
struct DaguerreApp: App {
    var body: some Scene {
        WindowGroup {
            CameraView()
        }
    }
}

struct DaguerreApp_Preview: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
