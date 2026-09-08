import UIKit

extension Air {

    func refreshAvailability() {
        let isAvailable: Bool
        if #available(iOS 27.0, *) {
            isAvailable = accessoryAvailability.values.contains(true)
        } else {
            isAvailable = !externalScenes.isEmpty
        }
        Self.log("[AirKit] Refresh availability: sources=\(accessoryAvailability.count), externalScenes=\(externalScenes.count), available=\(isAvailable)")
        guard connection.isAvailable != isAvailable else { return }
        connection.isAvailable = isAvailable
        if !isAvailable, isPlaybackRequested {
            Self.stop()
        }
    }

    func connectExternalScene(_ scene: UIWindowScene) {
        externalScenes[ObjectIdentifier(scene)] = scene
        logScene(scene)
        refreshAvailability()
        if isPlaybackRequested {
            displayContent(in: scene)
        }
    }

    func displayContent(in scene: UIWindowScene) {
        guard let hostingController else {
            assertionFailure("AirKit: Playback requested without a hosting controller.")
            return
        }
        if airWindow?.windowScene === scene {
            airWindow?.rootViewController = hostingController
        } else {
            removeWindow()
            let window = UIWindow(windowScene: scene)
            window.rootViewController = hostingController
            airWindow = window
        }
        airWindow?.isHidden = false
        connection.isViewAdded = true
        logDiagnostics("External scene window displayed")
    }

    func disconnectExternalScene(_ scene: UIScene) {
        externalScenes.removeValue(forKey: ObjectIdentifier(scene))
        logScene(scene)
        if airWindow?.windowScene === scene {
            removeWindow()
            if isPlaybackRequested, let remainingScene = externalScenes.values.first {
                displayContent(in: remainingScene)
            }
        }
        refreshAvailability()
    }
}
