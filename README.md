## iOS SDK

ATP Kit is one component for [Atlas Protocol](http://atlasp.io/), which interacts with Blockchain to get TIE (Targeting Interactive Element).

This library is for iOS devices.

##### Installation Guide(ToDo)

! Cocoapod is not configured yet.

##### Call SDK (Swift)
IMPORTANT: for Objective-C Developers!
if you want to use swift SDK in Objective-C project, please include at lease one SWIFT FILE in project compile source in order to auto-link swift standard library.

Import SDK
```swift
import ATPKit
import Renderer
```

Define the endpoint

```swift
public class Constants {
  // MARK: List of Constants
  public static let baseEP = "http://test-ces.atpsrv.net/v1"
  public static let campaignID = "cbehlkl7if2mfav8aof1g"
}
```

Override the voting Renderer

```swift
public class VotingViewController: VotingRenderer {
  override open func register(nasAddress: String, completion: @escaping (TIE?) -> Void) throws {
    try KitFactory.sharedInstance.getKitBuilder().register(nasAddress: nasAddress, completion: completion)
  }

  override open func parseTIE(tie: TIE) throws -> VoteData {
    return try KitFactory.sharedInstance.getKitBuilder().parseTIE(tie: tie) as! VoteData
  }

  override open func vote(_ vote: Vote, completion: @escaping (String?) -> Void) throws {
    try KitFactory.sharedInstance.getKitBuilder().delegateInteract(atpEvent: vote, completion: completion)
  }

  override open func getCampaignID() -> String {
    return Constants.campaignID
  }

  override open func setupKit() {
    KitFactory.setup(type: TIEType.voting.rawValue)
    let kitBuilder: KitBuilder = KitFactory.sharedInstance.getKitBuilder()
    kitBuilder.initSDK(atpConfig: ATPConfig(baseEP: Constants.baseEP, campaignID: Constants.campaignID, lang: "en", accid: "2312313", msg: "Thank you for your participation"))
  }
}
```

As the story board is configured mannually, please go ahead to configure `Main.storyboard`:

```xml
<viewController storyboardIdentifier="VotingViewController" id="4JQ-qw-sF2" customClass="VotingViewController" customModule="Starter" sceneMemberID="viewController">
  ...
</viewController>
```

If you would like to launch the ATPKit (SDK) by `AppDelegate`, you could do as:

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    setupKit()
    return true
  }

  // MARK: SDK Setup Sample
  private func setupKit() {
    KitFactory.setup(type: TIEType.voting.rawValue)
    let kitBuilder: KitBuilder = KitFactory.sharedInstance.getKitBuilder()
    kitBuilder.initSDK(atpConfig: ATPConfig(baseEP: Constants.baseEP, campaignID: Constants.campaignID, lang: "en", accid: "2312313", msg: "Thank you for your participation"))
  }

  // MARK: Dispatch Sample
  // MARK: DO NOT Know how to bind to story board
  private func getViewController(kitBuilder: KitBuilder) -> ATPRenderer {
    guard let mainViewController = kitBuilder.dispatch(adForm: nil) else {
      return VotingViewController()
    }
    return mainViewController
  }
}
```

The view controller could be got from the ATPKit method `dispatch`.  (NOT IN USE)


### For SDK Developers

#### Local Project Building
In first time build, you have to build both ATPKit.framework and Render.framework manually.
After you will only need to run Example demo app, they will be automatically builded.

```
$ cd ../Render
$ pod install
$ cd ../ATPKit
$ pod install
$ cd ../Example
$ pod install
```
```
ld: file too small (length=0)
```
if you happened to error above, please run  `pod install` for these projects again or try clean build folder.

#### Dictionary list

```
.
├── ATPKit
│   ├── ATPKit
│   │   ├── API
│   │   │   ├── HTTPClient.swift
│   │   │   └── LibraryAPI.swift
│   │   ├── ATPKit.h
│   │   ├── Config
│   │   │   └── ATPConfig.swift
│   │   ├── Helper
│   │   │   ├── Connectivity.swift
│   │   │   └── ATPKitError.swift
│   │   ├── Info.plist
│   │   ├── Services
│   │   │   ├── ATPManager.swift
│   │   │   ├── KitBuilder.swift
│   │   │   ├── KitFactory.swift
│   │   │   └── VotingManager.swift
│   │   └── TIERenderer.swift
│   ├── ATPKitTests
│   │   ├── ATPKitTests.swift
│   │   └── Info.plist
├── Example
│   ├── ATPKit.framework
│   │   ├── ATPKit
│   │   ├── Headers
│   │   │   ├── ATPKit-Swift.h
│   │   │   └── ATPKit.h
│   │   ├── Info.plist
│   │   └── Modules
│   │       ├── ATPKit.swiftmodule
│   │       │   ├── arm64.swiftdoc
│   │       │   └── arm64.swiftmodule
│   │       └── module.modulemap
│   ├── README.md
│   ├── Renderer
│   │   └── Renderer.xcodeproj
│   ├── Starter
│   │   ├── AppDelegate.swift
│   │   ├── Base.lproj
│   │   │   ├── LaunchScreen.xib
│   │   │   └── Main.storyboard
│   │   ├── Constants.swift
│   │   ├── FinishViewController.swift
│   │   ├── Images.xcassets
│   │   │   ├── AppIcon.appiconset
│   │   │   │   ├── Contents.json
│   │   │   │   ├── atp-logo-3.png
│   │   │   │   ├── atp-logo.png
│   │   │   │   ├── atp1024.png
│   │   │   │   ├── atp180.png
│   │   │   │   ├── atp58.png
│   │   │   │   ├── atp80.png
│   │   │   │   └── atp87.png
│   │   │   └── Contents.json
│   │   ├── Info.plist
│   │   ├── VotingViewController.swift
│   │   └── projects.json
│   └── StarterTests
│       ├── Info.plist
│       └── StarterTests.swift
└── Renderer
    ├── DLRadioButton
    ├── README.md
    ├── Renderer
    │   ├── Controllers
    │   │   ├── ATPRenderer.swift
    │   │   └── VotingRenderer.swift
    │   ├── Helper
    │   │   ├── Constants.swift
    │   │   └── Errors.swift
    │   ├── Info.plist
    │   ├── Models
    │   │   ├── ADForm.swift
    │   │   ├── ATPEvent.swift
    │   │   ├── Account.swift
    │   │   ├── TIE.swift
    │   │   ├── Vote.swift
    │   │   └── VoteData.swift
    │   ├── Renderer.h
    │   └── Views
    │       └── 
    ├── Renderer.xcodeproj
    ├── Renderer.xcworkspace
    ├── RendererTests
        ├── Info.plist
        └── RendererTests.swift
    
```

#### CICD

The bitbucket pipelines script is like:

```yaml
pipelines:
  custom:
    devios:
      - step:
          name: Build iOS Pods
          image: davidthornton/node6-cocoapods
          script:
            - chown -R node ios
            - export LANG=en_US.UTF-8
            - su node
            - cd ios/Renderer
            - pod trunk register bill.lv@atlasp.io 'Bill Lv' --description='Atlas Protocol'
            - pod trunk push Renderer.podspec
            - cd ../..
            - cd ios/ATPKit
            - pod trunk push ATPKit.podspec
```

Use `pod` to release the SDK library.

After execution of `pod trunk push Renderer.podspec`, we got pod dependency `https://cocoapods.org/pods/Renderer`

After execution of `pod trunk push ATPKit.podspec`, we got pod dependency `https://cocoapods.org/pods/ATPKit`

The above pipeline script cannot be executed in Bitbucket for the user privilege problems, which may need to build self docker image containing the `pod`. Just replace `davidthornton/node6-cocoapods` with proper docker image.

