//
//  CircleView.swift
//  Programming Test
//
//  Created by Rafael Aguilera on 2/22/18.
//  Copyright © 2018 Rafael Aguilera. All rights reserved.
//

import UIKit
//MARK:UIView Extension class Circleview for drawing circle
class CircleView: UIView {
    //determines how many colors can in circle can add as many as wanted from plist or JSON
    var colorArray: [UIColor] = [.red, .purple, .blue, .green]
    
    override func draw(_ rect: CGRect) {
        let divSize = CGFloat(360/self.colorArray.count)
        for colorCount in 0...colorArray.count-1{
            let f = CGFloat(colorCount)
            let ovalRect = CGRect(x: 0, y: 0, width: 375, height: 375)
            let ovalPath = UIBezierPath()
            ovalPath.addArc(withCenter: CGPoint(x: ovalRect.midX, y: ovalRect.midY), radius: ovalRect.width / 2, startAngle: f * divSize * CGFloat.pi/180 + CGFloat.pi/4, endAngle: (f+1) * divSize * CGFloat.pi/180 + CGFloat.pi/4, clockwise: true)
            ovalPath.addLine(to: CGPoint(x: ovalRect.midX, y: ovalRect.midY))
            ovalPath.close()
            colorArray[colorCount].setFill()
            ovalPath.fill()
        }
        
    }
    
}
