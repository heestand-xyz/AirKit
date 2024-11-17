import UIKit
import SwiftUI

public extension View {
    func airPlay() -> some View {
        Air.play(AnyView(self))
        return self
    }
}
