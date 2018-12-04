Starter iOS
==========

ATP iOS SDK Starter

#### Install Submodule Dependencies

```
$ cd ../..
$ git submodule update --init --recursive
```


#### SDK

To run the Starter, you should add Renderer and ATPKit as framework dependencies

#### Build

```
$ xcodebuild -workspace Starter.xcworkspace -scheme Starter -destination generic/platform=iOS build
$ xcodebuild -workspace Starter.xcworkspace -scheme Starter -sdk iphoneos -configuration AppStoreDistribution archive -archivePath $PWD/build/Starter.xcarchive
```

#### Export Lib

Refer to the [video](https://youtu.be/odENZE5AMaI)

You may find the output library `libATPLib.a`

#### Code Structure

```
Starter
```

#### Sample

You can run the sample by bundle identifier `io.atlasp.Starter`

The sample is temporarily consuming services from mock server `https://virtserver.swaggerhub.com/atlas-protocol/ces/1.0.0`

It gets TIE by Type `voting` and renders the TIE to the mobile, please have a try, have fun.

The sample implements the protocol `TieRenderer`, the renderer may be finer-grained in the following versions.
