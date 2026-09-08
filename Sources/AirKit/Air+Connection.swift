import Foundation

public extension Air {

    struct Connection: Equatable, Sendable {
        public internal(set) var isAvailable: Bool
        public internal(set) var isViewAdded: Bool

        static let disconnected = Connection(isAvailable: false, isViewAdded: false)
    }
}
