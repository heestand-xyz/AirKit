import SwiftUI

public extension View {

    /// Register the main interface as a source of optional external-display content.
    @MainActor
    @ViewBuilder
    func airPlaySource() -> some View {
        if #available(iOS 27.0, *) {
            background {
                AirSourceView()
                    .allowsHitTesting(false)
            }
        } else {
            self
        }
    }
}

@available(iOS 27.0, *)
private struct AirSourceView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> AirSceneAccessoryViewController {
        AirSceneAccessoryViewController()
    }

    func updateUIViewController(_ controller: AirSceneAccessoryViewController, context: Context) {}

    static func dismantleUIViewController(_ controller: AirSceneAccessoryViewController, coordinator: ()) {
        controller.unregister()
    }
}
