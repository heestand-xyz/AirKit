import UIKit
import SwiftUI

public extension View {
    @MainActor
    func airPlay() -> some View {
        Air.play(AnyView(self))
        return self
    }
}
