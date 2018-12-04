/*
 * Copyright (c) 2018 Atlas Protocol
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import ATPKit
import Renderer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupKit()
        //    self.setupKit()
        return true
    }
    
    // MARK: SDK Setup Sample
    fileprivate func setupKit() {
        print("value = \(TIEType.voting.rawValue)")
        KitFactory.setup(type: TIEType.voting.rawValue)
        
        let kitBuilder: KitBuilder = KitFactory.sharedInstance.getKitBuilder()
        kitBuilder.initSDK(atpConfig: ATPConfig(baseEP: Constants.baseEP, campaignID: Constants.campaignID
            , msg: "Thank you for your participation"))
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

