//
//  ViewController.swift
//  VkTokenGenerator
//
//  Created by Mike Mozhaev on 20.04.17.
//  Copyright © 2017 Mike Mozhaev. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, NSTextFieldDelegate, AccessTokenDelegate {
    
    var checkboxesNames: [String] = ["notify", "friends", "photos", "audio", "video", "pages", "status", "notes", "messages", "wall", "ads", "offline", "docs", "groups", "stats", "email", "market", "nohttps", "Applicaion link", "notifications"]
    
    var scope = Set<String>()
    
    var oauthUrl: String!
    
    @IBOutlet weak var applicationId: NSTextField!
    
    @IBOutlet weak var accessTokenLabel: NSTextField!
    
    @IBOutlet weak var oauthUrlLabel: NSTextField!
    
    @IBOutlet weak var generateButton: NSButton!
    
    @IBOutlet weak var copyToken: NSButton!
    
    @IBOutlet weak var copyOAuthUrl: NSButton!
    
    var pasteboard: NSPasteboard!
    
    var webAuthViewController: WebAuthViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applicationId.delegate = self
        webAuthViewController = self.storyboard?.instantiateController(withIdentifier: "WebAuthViewController") as! WebAuthViewController
        webAuthViewController.delegate = self
        self.generateButton.isEnabled = false
        pasteboard = NSPasteboard.general()
        self.drawCheckboxes()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func didGetAccessToken(controller: WebAuthViewController, accessToken: String) {
        self.accessTokenLabel.stringValue = accessToken
        self.oauthUrlLabel.stringValue = oauthUrl
        self.copyToken.isHidden = false
        self.copyOAuthUrl.isHidden = false

    }
    
    override func controlTextDidChange(_ obj: Notification) {
        if self.applicationId.integerValue != 0 {
            self.generateButton.isEnabled = true
        } else {
            self.generateButton.isEnabled = false
        }
    }
    
    @IBAction func generateButtonPress(_ sender: NSButton) {
        let joinedScope = self.scope.joined(separator: ",")
        oauthUrl = "https://oauth.vk.com/authorize?client_id=\(self.applicationId.stringValue)&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&scope=\(joinedScope)&response_type=token&v=5.63"
        
        webAuthViewController.oauthUrl = oauthUrl
        self.presentViewControllerAsModalWindow(webAuthViewController)
    }
    
    @IBAction func copyTokenPress(_ sender: NSButton) {
        pasteboard.clearContents()
        pasteboard.setString(self.accessTokenLabel.stringValue, forType: NSPasteboardTypeString)
    }
    
    @IBAction func copyOAuthUrlPress(_ sender: NSButton) {
        pasteboard.clearContents()
        pasteboard.setString(self.oauthUrlLabel.stringValue, forType: NSPasteboardTypeString)
    }
    
    func drawCheckboxes() {
        var row = 0
        var column = 0
        for name in self.checkboxesNames {
            let b = NSButton(checkboxWithTitle: name, target: self, action: #selector(click))
            b.frame = NSRect(x: 100*column+30, y: row*25+20, width: 200, height: 20)
            self.view.addSubview(b)
            row += 1
            if row == 5 {
                column += 1
                row = 0
            }
        }
    }
    
    func click(sender: NSButton!) {
        if sender.integerValue == 1 {
            scope.insert(sender.title)
        } else {
            scope.remove(sender.title)
        }
    }

}

