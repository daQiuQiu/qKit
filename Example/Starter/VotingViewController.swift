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
import Foundation
import ATPKit
import Renderer

public class VotingViewController: VotingRenderer,ATPKitCallBack {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override open func register(nasAddress: String, completion: @escaping (VoteData?) -> Void) {
        KitFactory.sharedInstance.getKitBuilder().register(nasAddress: nasAddress, completion: completion)
    }
    
    override open func vote(_ vote: Vote) {
        super.showSpinner()
        KitFactory.sharedInstance.getKitBuilder().delegateInteract(atpEvent: vote, completion: { (result) in
            print("Vote result = \(String(describing: result))")
            self.hideSpinner()
            CBToast.showToastAction(message: "Vote Success!")
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    override open func getCampaignID() -> String {
        return Constants.campaignID
    }
    
    public func errorHandle(source: String?, errorMsg: String?) {
        self.hideSpinner()
        print("========Got ERROR From === \(String(describing: source)), Msg === \(String(describing: errorMsg))")
        CBToast.showToastAction(message: errorMsg! as NSString)
    }
    
}
