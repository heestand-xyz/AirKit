<img src="https://github.com/hexagons/AirKit/blob/main/Assets/airplayvideo.jpeg?raw=true" height="100" />

# AirKit

AirPlay SwiftUI Views

## Add to App

- *File* / *Swift Packages* / *Add Package Dependecy*
- Search for **AirKit** by **hexagons**
- Add *Up to Next Major* from **1.0.0**

## Example

~~~~swift
import SwiftUI
import AirKit

struct ContentView: View {
    var body: some View {
        Text("Hello AirPlay")
            .airPlay()
    }
}
~~~~

You can also *Air* a View that is not on the main screen:

~~~~swift
Air.play(AnyView(Image(systemName: "airplayvideo")))
~~~~

To listen to the connection call:

~~~~swift
Air.connection { connected in
    let isAirPaying: Bool = connected
}
~~~~

## Add to Package

~~~~swift
.package(url: "https://github.com/hexagons/AirKit.git", from: "1.0.0")
~~~~
