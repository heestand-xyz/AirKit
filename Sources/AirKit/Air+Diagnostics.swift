import UIKit
import OSLog

extension Air {

    private static let logger = Logger(subsystem: "AirKit", category: "Connection")

    static func log(_ message: String) {
        logger.notice("\(message, privacy: .public)")
    }

    func logDiagnostics(_ event: String) {
        Self.log("[AirKit] \(event): available=\(connection.isAvailable), viewAdded=\(connection.isViewAdded), playbackRequested=\(isPlaybackRequested), sources=\(accessoryAvailability.count), hostingController=\(hostingController != nil), window=\(airWindow != nil), externalScenes=\(externalScenes.count)")
        for scene in externalScenes.values {
            logScene(scene)
        }
    }

    func logScene(_ scene: UIScene) {
        Self.log("[AirKit] scene: id=\(ObjectIdentifier(scene)), role=\(scene.session.role.rawValue), state=\(scene.activationState.rawValue)")
        if let windowScene = scene as? UIWindowScene {
            Self.log("[AirKit] scene screen: id=\(ObjectIdentifier(windowScene.screen)), bounds=\(windowScene.coordinateSpace.bounds), scale=\(windowScene.traitCollection.displayScale), capture=\(windowScene.traitCollection.sceneCaptureState)")
        }
    }

    func logConfiguration() {
        let manifest = Bundle.main.object(forInfoDictionaryKey: "UIApplicationSceneManifest") as? [String: Any]
        let configurations = manifest?["UISceneConfigurations"] as? [String: Any]
        let roles = configurations?.keys.sorted() ?? []
        let backgroundModes = Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") as? [String] ?? []
        Self.log("[AirKit] configuration: sceneManifest=\(manifest != nil), sceneRoles=\(roles), backgroundModes=\(backgroundModes)")
    }
}
