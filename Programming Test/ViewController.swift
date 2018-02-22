//
//  ViewController.swift
//  Programming Test
//
//  Created by Rafael Aguilera on 2/22/18.
//  Copyright © 2018 Rafael Aguilera. All rights reserved.
//


import UIKit
import WatchConnectivity


class ViewController: UIViewController, WCSessionDelegate{
    
    //MARK: Properties
    let circleView = CircleView(frame: CGRect(x: 0, y: 143.5, width: 375, height: 375))
    var currentColor = "blue"
    var totalDeg:CGFloat = 0
    var rotation:CGFloat = 0
    var startRotationAngle:CGFloat = 0
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session().delegate = self
            session().activate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Methods
    func setupUI(){
        self.view.addSubview(circleView)
        circleView.backgroundColor = .white
        circleView.translatesAutoresizingMaskIntoConstraints = true
        circleView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        circleView.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        addPanGesture(view: circleView)
    }
    //sending color message to watch
    func sendWatchMessage() {
        if (WCSession.default().isReachable) {
            let message = ["color": currentColor]
            WCSession.default().sendMessage(message, replyHandler: nil)
        }
    }
    //adding panning gesture
    func addPanGesture(view: UIView){
        let pan = UIPanGestureRecognizer(target: self, action:#selector(self.panHandler))
        view.addGestureRecognizer(pan)
    }
    //handler for panning gesture
    func panHandler(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self.view)
        let gestureRotation = CGFloat(angle(from: location)) - startRotationAngle
        switch gesture.state {
        case .began:
            startRotationAngle = angle(from: location)
        case .changed:
            rotate(from: rotation - gestureRotation.degreesToRadians, to: rotation - gestureRotation.degreesToRadians)
        case .ended:
            rotation -= gestureRotation.degreesToRadians
            totalDeg = rotation.radiansToDegrees
            
            while totalDeg > 360{
                totalDeg -= 360
            }
            while totalDeg < 0{
                totalDeg += 360
            }
            //Glitch in animation due to jumping from 0 to 359 and vice versa can fix with more time
            if totalDeg > 315 || totalDeg < 45{
                currentColor = "blue"
                sendWatchMessage()
                rotate(from: rotation, to: CGFloat(0).degreesToRadians, duration: 0)
                rotation = 0
            }
            else if totalDeg >= 45 && totalDeg < 135{
                currentColor = "purple"
                sendWatchMessage()
                rotate(from: rotation, to: CGFloat(90).degreesToRadians, duration: 0)
                rotation = CGFloat(90).degreesToRadians
            }
            else if totalDeg >= 135 && totalDeg < 225{
                currentColor = "red"
                sendWatchMessage()
                rotate(from: rotation, to: CGFloat(180).degreesToRadians, duration: 0)
                rotation = CGFloat(180).degreesToRadians
            }
            else if totalDeg >= 225 && totalDeg < 315{
                currentColor = "green"
                sendWatchMessage()
                rotate(from: rotation, to: CGFloat(270).degreesToRadians, duration: 0)
                rotation = CGFloat(270).degreesToRadians
            }
            //Glitch in animation due to jumping from 0 to 359 and vice versa can fix with more time
        default :
            break
        }
    }
    //rotation animation from point to point with duration of
    func rotate(from: CGFloat, to: CGFloat, duration: Double = 0) {
        let rotateAnimation = CABasicAnimation()
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.fromValue = from
        rotateAnimation.toValue = to
        rotateAnimation.repeatCount = 0
        rotateAnimation.duration = duration
        rotateAnimation.fillMode = kCAFillModeForwards
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        circleView.layer.add(rotateAnimation, forKey: "transform.rotation.z")
    }
    //determine angle
    func angle(from location: CGPoint) -> CGFloat {
        let deltaX = location.x - view.center.x
        let deltaY = location.y - view.center.y
        let angle = atan2(deltaY, deltaX) * 180 / CGFloat.pi
        return 360 - angle
    }
    
    //MARK: protocol stubs for WCSessionsDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
}
//extension for converting between radians and degrees
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

