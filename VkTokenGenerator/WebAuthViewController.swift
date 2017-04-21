//
//  webViewController.swift
//  VkTokenGenerator
//
//  Created by Mike Mozhaev on 20.04.17.
//  Copyright © 2017 Mike Mozhaev. All rights reserved.
//

import Cocoa
import WebKit

protocol AccessTokenDelegate {
    func didGetAccessToken(controller: WebAuthViewController, accessToken: String)
    func didError(controller: WebAuthViewController, error: String)
}

class WebAuthViewController: NSViewController, WebFrameLoadDelegate {
    
    var delegate: AccessTokenDelegate?
    
    var oauthUrl: String?
    
    @IBOutlet weak var web: WebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        web.frameLoadDelegate = self
        web.mainFrame.load(URLRequest(url: URL(string: self.oauthUrl!)!))
    }
    
    func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
        let url = sender.mainFrameURL!
        if url.contains("#access_token") {
            let access_token = url.components(separatedBy: "#access_token=")[1].components(separatedBy: "&")[0]
            delegate?.didGetAccessToken(controller: self, accessToken: access_token)
            web.close()
            self.dismissViewController(self)
        }
        if url.contains("error") {
            let error = url.components(separatedBy: "&error_description=")[1]
            delegate?.didError(controller: self, error: error)
            web.close()
            self.dismissViewController(self)
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
}
