import UIKit

@available(iOS 27.0, *)
final class AirSceneAccessoryViewController: UIViewController {

    private let sourceID = UUID()
    private var registration: UISceneAccessoryRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = false
        let configuration = UISceneConfiguration()
        configuration.delegateClass = AirSceneDelegate.self
        let accessory = UISceneAccessory.externalNonInteractive(sceneConfiguration: configuration)
        let registration = registerSceneAccessory(accessory)
        self.registration = registration
        registration.isEnabled = Air.shared.isPlaybackRequested
        Air.log("[AirKit] Scene accessory registered: source=\(sourceID), enabled=\(registration.isEnabled)")
        setNeedsUpdateProperties()
    }

    override func updateProperties() {
        super.updateProperties()
        guard let registration else { return }
        // UIKit tracks both reads and updates the accessory as playback or availability changes.
        let isEnabled = Air.shared.isPlaybackRequested
        if registration.isEnabled != isEnabled {
            registration.isEnabled = isEnabled
            Air.log("[AirKit] Source playback changed: source=\(sourceID), enabled=\(isEnabled)")
        }
        let isAvailable = registration.isAvailable
        guard Air.shared.accessoryAvailability[sourceID] != isAvailable else { return }
        Air.shared.accessoryAvailability[sourceID] = isAvailable
        Air.log("[AirKit] Source availability changed: source=\(sourceID), available=\(isAvailable), enabled=\(registration.isEnabled)")
        Air.shared.refreshAvailability()
    }

    func unregister() {
        guard let registration else { return }
        unregisterSceneAccessory(registration)
        self.registration = nil
        Air.shared.accessoryAvailability.removeValue(forKey: sourceID)
        Air.shared.refreshAvailability()
        Air.log("[AirKit] Scene accessory unregistered: source=\(sourceID)")
    }
}
