## RuuviTag - iOS Library

Simple way to listen to RuuviTags' advertisement data on iOS. Put your tag to raw mode and go.

### Installation

First add this pod repository to your Podfile, sorry, no official Cocoapod yet
```
pod 'RuuviTag-iOS', :git => 'https://github.com/TomiLahtinen/ruuvitag-ios.git', :tag => '1.0.3' 
```

Then run
```shell
pod install
```
in your App code

```swift
import RuuviTag_iOS

RuuviTags.listen { tagInfo in 
  // Do your thing like for example
  debugPrint("Tag", tagInfo.uuid.uuidString, "sensor values", tagInfo.sensorValues)
}
 