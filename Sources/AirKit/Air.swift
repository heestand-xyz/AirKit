import UIKit
import SwiftUI

public class Air {
    
    static let shared = Air()
    
    var airScreen: UIScreen?
    var airWindow: UIWindow?
    
//    let airView: UIView
    var hostingController: UIHostingController<AnyView>?
    
    var appIsActive: Bool { UIApplication.shared.applicationState == .active }
    
    init() {
        
//        airView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didConnect),
                                               name: UIScreen.didConnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didDisconnect),
                                               name: UIScreen.didDisconnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive),
                                               name: UIApplication.willResignActiveNotification, object: nil)
        
    }
    
    public static func play(_ view: AnyView) {
        Air.shared.hostingController = UIHostingController<AnyView>(rootView: view)
    }
    
//    public func addSubview(_ view: UIView) {
//        print("AirKit - Add Subview")
//        airView.addSubview(view)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.topAnchor.constraint(equalTo: airView.topAnchor).isActive = true
//        view.bottomAnchor.constraint(equalTo: airView.bottomAnchor).isActive = true
//        view.leftAnchor.constraint(equalTo: airView.leftAnchor).isActive = true
//        view.rightAnchor.constraint(equalTo: airView.rightAnchor).isActive = true
//    }
    
    @objc func didConnect(sender: NSNotification) {
        print("AirKit - Connect")
        guard let screen: UIScreen = sender.object as? UIScreen else { return }
        add(screen: screen)
    }
    
    func add(screen: UIScreen) {
        
        print("AirKit - Add Screen")
        
        airScreen = screen
        
        airWindow = UIWindow(frame: airScreen!.bounds)
                
//        airView.frame = airWindow!.bounds
//        airWindow!.addSubview(airView)
        
        guard let viewController: UIViewController = hostingController else {
            print("AirKit - Add - Failed: Hosting Controller Not Found")
            return
        }
        
        findWindowScene(for: airScreen!) { windowScene in
            guard let airWindowScene: UIWindowScene = windowScene else {
                print("AirKit - Add - Failed: Window Scene Not Found")
                return
            }
            self.airWindow?.rootViewController = viewController
            self.airWindow?.windowScene = airWindowScene
            self.airWindow?.isHidden = false
            print("AirKit - Add Screen - Done")
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
    }
    
    func remove() {
        print("AirKit - Remove")
//        airView.removeFromSuperview()
        airWindow = nil
        airScreen = nil
    }
    
    @objc func didBecomeActive() {
        print("AirKit - App Active")
        
    }
    
    @objc func willResignActive() {
        print("AirKit - App Inactive")
//        airWindow!.isHidden = true
        
    }
    
}
