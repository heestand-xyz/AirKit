import UIKit
import SwiftUI

public extension View {
    
    func airPlay() -> some View {
        print("AirKit - airPlay")
        let hostingController = UIHostingController<AnyView>(rootView: AnyView(self))
        Air.shared.addHostingController(hostingController)
//        let view: UIView = controller.view
//        Air.shared.addSubview(view)
        return self
    }
    
}
