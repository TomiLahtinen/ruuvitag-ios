## RuuviTag - iOS Library

[![Build Status](https://travis-ci.org/TomiLahtinen/ruuvitag-ios.svg?branch=master)](https://travis-ci.org/TomiLahtinen/ruuvitag-ios)

Simple way to listen to RuuviTags' advertisement data on iOS. Put your tag to raw mode and go

### Example

```swift
import RuuviTag_iOS

RuuviTags.listen { tagInfo in 
  // Do your thing like for example
  debugPrint("Tag", tagInfo.uuid.uuidString, "sensor values", tagInfo.sensorValues)
}
```


### Installation
First, add this pod repository to your Podfile, sorry, no official Cocoapod yet
```
pod 'RuuviTag-iOS', :git => 'https://github.com/TomiLahtinen/ruuvitag-ios.git', :tag => '1.0.4' 
```

Then run
```shell
pod install
```
in your App code


### Supported versions
Only supports tags advertising in raw mode and Ruuvi's [data format 3](https://github.com/ruuvi/ruuvi-sensor-protocols#data-format-3-protocol-specification)