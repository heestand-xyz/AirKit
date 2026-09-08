import UIKit

@objc(AirKitSceneDelegate)
public final class AirSceneDelegate: UIResponder, UIWindowSceneDelegate {

    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            assertionFailure("AirKit: Expected an external window scene.")
            return
        }
        Air.shared.connectExternalScene(windowScene)
    }

    public func sceneDidDisconnect(_ scene: UIScene) {
        Air.shared.disconnectExternalScene(scene)
    }
}
