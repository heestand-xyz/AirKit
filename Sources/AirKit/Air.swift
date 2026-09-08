import Observation
import SwiftUI
import UIKit

@MainActor
@Observable
public final class Air {

    public static let shared = Air()

    public internal(set) var connection: Connection = .disconnected {
        didSet {
            guard connection != oldValue else { return }
            Self.log("[AirKit] connection: available \(oldValue.isAvailable) -> \(connection.isAvailable), viewAdded \(oldValue.isViewAdded) -> \(connection.isViewAdded)")
        }
    }
    public private(set) var isPlaybackRequested = false

    @ObservationIgnored
    var airWindow: UIWindow?
    @ObservationIgnored
    var hostingController: UIHostingController<AnyView>?
    @ObservationIgnored
    var externalScenes: [ObjectIdentifier: UIWindowScene] = [:]
    @ObservationIgnored
    var accessoryAvailability: [UUID: Bool] = [:]

    private init() {
        logConfiguration()
        logDiagnostics("Initialize")
    }

    public static func play<Content: View>(@ViewBuilder content: () -> Content) {
        play(AnyView(content()))
    }

    public static func play(_ view: AnyView) {
        let air = shared
        air.logDiagnostics("Play requested")
        if let hostingController = air.hostingController {
            hostingController.rootView = view
        } else {
            air.hostingController = UIHostingController(rootView: view)
        }
        air.isPlaybackRequested = true
        if let scene = air.airWindow?.windowScene ?? air.externalScenes.values.first {
            air.displayContent(in: scene)
        }
    }

    public static func stop() {
        let air = shared
        air.logDiagnostics("Stop requested")
        air.isPlaybackRequested = false
        air.removeWindow()
        air.hostingController = nil
    }

    func removeWindow() {
        airWindow?.isHidden = true
        airWindow?.rootViewController = nil
        airWindow = nil
        connection.isViewAdded = false
    }
}
