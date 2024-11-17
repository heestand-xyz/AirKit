import UIKit
import SwiftUI

@Observable
public class Air {
    
    public static let shared = Air()
    
    public struct Connection {
        public internal(set) var isAvailable: Bool
        public internal(set) var isViewAdded: Bool
        static let disconnected = Connection(isAvailable: false, isViewAdded: false)
    }
    public private(set) var connection: Connection = .disconnected {
        didSet {
            connectionCallbacks.forEach({ $0(oldValue, connection) })
        }
    }
    @ObservationIgnored
    var connectionCallbacks: [(Connection, Connection) -> ()] = []
    
    @ObservationIgnored
    var airScreen: UIScreen?
    @ObservationIgnored
    var airWindow: UIWindow?
    
    @ObservationIgnored
    var hostingController: UIHostingController<AnyView>?
    
    var appIsActive: Bool {
        UIApplication.shared.applicationState == .active
    }
    
    init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(didConnect),
                                               name: UIScreen.didConnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didDisconnect),
                                               name: UIScreen.didDisconnectNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive),
                                               name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    public static func play<Content: View>(@ViewBuilder content: () -> Content) {
        play(AnyView(content()))
    }
    
    public static func play(_ view: AnyView) {
        print("AirKit - Play")
        Air.shared.hostingController = UIHostingController<AnyView>(rootView: view)
        Air.shared.playIfCan()
    }
    
    private func playIfCan() {
       if let connectedScreen = UIScreen.screens.first(where: { $0 != .main }) {
            add(screen: connectedScreen) { [weak self] success in
                guard success else { return }
                self?.connection.isViewAdded = true
            }
        }
    }
    
    public static func stop() {
        print("AirKit - Stop")
        Air.shared.remove()
        Air.shared.hostingController = nil
    }
    
    public static func connection(_ callback: @escaping (Connection, Connection) -> ()) {
        Air.shared.connectionCallbacks.append(callback)
    }
    
    @objc func didConnect(sender: NSNotification) {
        print("AirKit - Connect")
        guard let screen: UIScreen = sender.object as? UIScreen else { return }
        connection.isAvailable = true
        add(screen: screen) { [weak self] success in
            guard success else { return }
            self?.connection.isViewAdded = true
        }
    }
    
    func add(screen: UIScreen, completion: @escaping (Bool) -> ()) {
        
        print("AirKit - Add Screen")
        
        airScreen = screen
        
        airWindow = UIWindow(frame: screen.bounds)
        
        guard let viewController: UIViewController = hostingController else {
            completion(false)
            return
        }
        
        findWindowScene(for: screen) { windowScene in
            guard let airWindowScene: UIWindowScene = windowScene else {
                print("AirKit - Add - Failed: Window Scene Not Found")
                completion(false)
                return
            }
            self.airWindow?.rootViewController = viewController
            self.airWindow?.windowScene = airWindowScene
            self.airWindow?.isHidden = false
            print("AirKit - Add Screen - Done")
            completion(true)
        }
        
    }
    
    func findWindowScene(for screen: UIScreen, shouldRecurse: Bool = true, completion: @escaping (UIWindowScene?) -> ())  {
        print("AirKit - Find Window Scene")
        var matchingWindowScene: UIWindowScene? = nil
        let scenes = UIApplication.shared.connectedScenes
        for scene in scenes {
            if let windowScene = scene as? UIWindowScene {
                if windowScene.screen == screen {
                    matchingWindowScene = windowScene
                    break
                }
            }
        }
        guard let windowScene: UIWindowScene = matchingWindowScene else {
            DispatchQueue.main.async {
                self.findWindowScene(for: screen, shouldRecurse: false) { windowScene in
                    completion(windowScene)
                }
            }
            return
        }
        completion(windowScene)
    }
    
    @objc func didDisconnect() {
        print("AirKit - Disconnect")
        remove()
        connection = .disconnected
    }
    
    func remove() {
        print("AirKit - Remove")
        airWindow = nil
        airScreen = nil
        connection.isViewAdded = false
    }
    
    @objc func didBecomeActive() {}
    
    @objc func willResignActive() {}
}
