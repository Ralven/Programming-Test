//
//  InterfaceController.swift
//  Programming Test WatchKit Extension
//
//  Created by Rafael Aguilera on 2/22/18.
//  Copyright © 2018 Rafael Aguilera. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    //MARK: Properties
    @IBOutlet var watchImage: WKInterfaceImage!
   
    //MARK: LifeCycle
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        watchImage.setImageNamed("Circle")
        watchImage.setTintColor(UIColor.blue)
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //MARK: WCSessionDelegate Protocol Stubs
    //didrecievemessage function with color message
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if message["color"] as! String == "blue"{
            watchImage.setTintColor(UIColor.blue)
        }else if message["color"] as! String == "red"{
            watchImage.setTintColor(UIColor.red)
        }else if message["color"] as! String == "purple"{
            watchImage.setTintColor(UIColor.purple)
        }else if message["color"] as! String == "green"{
            watchImage.setTintColor(UIColor.green)
        }
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
}
