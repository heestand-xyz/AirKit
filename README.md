# AirKit

Present SwiftUI content on an external display connected through AirPlay or HDMI.
Requires iOS 26 or later and Swift 6.2.

## Setup

Attach `.airPlaySource()` to the main interface that provides the external content:

```swift
import AirKit
import SwiftUI

struct PlayerView: View {
    private let air = Air.shared

    var body: some View {
        VStack {
            Button("Show on External Display") {
                Air.play {
                    Text("External display content")
                }
            }
            .disabled(!air.connection.isAvailable)

            Button("Stop") {
                Air.stop()
            }
            .disabled(!air.isPlaybackRequested)
        }
        .airPlaySource()
    }
}
```

On iOS 27 and later, the modifier registers a `UISceneAccessory` on a view controller in the main interface. It observes accessory availability even while playback is disabled, then enables external presentation when `Air.play` is called. Keep the source attached while offering external playback. UIKit chooses the topmost source when multiple interfaces register accessories.

On iOS 26, add this external-display entry to `UIApplicationSceneManifest` → `UISceneConfigurations` in the app's Info.plist. Preserve the app's existing scene configurations:

```xml
<key>UIWindowSceneSessionRoleExternalDisplayNonInteractive</key>
<array>
    <dict>
        <key>UISceneConfigurationName</key>
        <string>AirPlay</string>
        <key>UISceneClassName</key>
        <string>UIWindowScene</string>
        <key>UISceneDelegateClassName</key>
        <string>AirKitSceneDelegate</string>
    </dict>
</array>
```

Both versions use `UIWindow(windowScene:)` with the external scene supplied by UIKit. A wired display follows the same lifecycle as an AirPlay display. Stopping playback removes the external content while keeping connection availability observable.

## Observation

`Air` is an `@MainActor`, `@Observable` model. SwiftUI automatically observes reads of:

- `Air.shared.connection.isAvailable`: a display is available for presentation.
- `Air.shared.isPlaybackRequested`: the app has requested external playback.
- `Air.shared.connection.isViewAdded`: the content is attached to an external window.

Use SwiftUI `.onChange` or an `Observations` sequence when side effects are needed. The former `Air.connection` callback API has been removed.

```swift
.onChange(of: Air.shared.connection.isAvailable, initial: true) { _, isAvailable in
    // Update controls or other connection-dependent state.
}
```

## Diagnostics

Filter the Xcode or Console log by `AirKit` (subsystem `AirKit`, category `Connection`). Logs include scene configuration, source registration and availability, playback changes, and external scene/window attachment. Screen capture alone is not treated as an available external display.
