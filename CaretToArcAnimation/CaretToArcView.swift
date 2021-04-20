//
//  CaretToArcView.swift
//  CaretToArcAnimation
//
//  Created by Duncan Champney on 4/19/21.
//  Copyright 2021 Duncan Champney
//  Licensed under the MIT source license
//

import UIKit

enum ViewState: Int {
    case none
    case caret
    case arc
}

class CaretToArcView: UIView {

    var rotation = 0.0
    public var animationDuration: Double = 0.2
    public var viewState: ViewState = .none {
        didSet {
            buildPath()
        }
    }

    class override var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    public func rotate(_ doRotate: Bool) {
        if !doRotate {
            layer.removeAllAnimations()
        } else {
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.duration = 1.0
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            animation.fromValue = rotation
            animation.repeatCount = Float.greatestFiniteMagnitude
            self.rotation += Double.pi * 2
            animation.toValue = rotation
            layer.add(animation, forKey: nil)
            DispatchQueue.main.async() {
            }
        }
    }

    private func buildPath() {
        let path = UIBezierPath()
        switch viewState {
        case .none:
            break  // Install an empty path in the shape layer

        // Create a path that draws a caret, but using 2 cubic bezier paths.
        case .caret:
            let caretStart = CGPoint(x: 200, y: 280)  // The lower left point of the caret
            let caretMiddle = CGPoint(x: 280, y: 200) // The middle part of the caret (The bend)
            let caretEnd = CGPoint(x: 200, y: 120)    // The top left point of the caret.

            let caretBezier1PointB = CGPoint(x: caretStart.x + abs(caretStart.x - caretMiddle.x)/3,
                                             y: caretStart.y - abs(caretStart.y - caretMiddle.y)/3)
            let caretBezier1PointC = CGPoint(x: caretStart.x + abs(caretStart.x - caretMiddle.x)*2/3,
                                             y: caretStart.y - abs(caretStart.y - caretMiddle.y)*2/3)

            let caretBezier2PointB = CGPoint(x: caretEnd.x + abs(caretEnd.x - caretMiddle.x)/3,
                                             y: caretEnd.y + abs(caretEnd.y - caretMiddle.y)/3)
            let caretBezier2PointC = CGPoint(x: caretEnd.x + abs(caretEnd.x - caretMiddle.x)*2/3,
                                             y: caretEnd.y + abs(caretEnd.y - caretMiddle.y)*2/3)

            path.move(to: CGPoint(x: 200, y: 280))
            path.addCurve(to: caretMiddle, controlPoint1: caretBezier1PointB, controlPoint2: caretBezier1PointC)
            path.addCurve(to: caretEnd, controlPoint1: caretBezier2PointB, controlPoint2: caretBezier2PointC)

        // Create an arc that draws 3/4 of a circle, also using 2 cubic bezier curves.
        // The arc is drawn counter-clockwise. No particular reason: That' just how I set up both the caret and the arc.
        case .arc:
            let arcBezier1PointA = CGPoint(x: 111, y: 288) // The lower point of the arc
            let arcBezier1PointB = CGPoint(x: 190, y: 367) // The first control point of the first Bezier curve
            let arcBezier1PointC = CGPoint(x: 325, y: 311) // The second control point of the first Bezier curve

            let arcMiddle = CGPoint(x: 325, y: 200) //arcBezier1PointD and arcBezier2PointA (The end of the first and beginning of the 2nd arc.)

            let arcBezier2PointB = CGPoint(x: 325, y:  89) // The first control point of the 2nd Bezier curve in the arc
            let arcBezier2PointC = CGPoint(x: 190, y:  33) // The second control point of the 2nd Bezier curve
            let arcBezier2PointD = CGPoint(x: 111, y: 112) // The end point of the 2nd Bezier curve, and the end of the arc.

            // Sart at the lower point of the arc
            path.move(to: arcBezier1PointA)

            // Draw the first Bezier curve
            path.addCurve(to: arcMiddle, controlPoint1: arcBezier1PointB, controlPoint2: arcBezier1PointC)

            // Draw the second Bezier cruve
            path.addCurve(to: arcBezier2PointD, controlPoint1: arcBezier2PointB, controlPoint2: arcBezier2PointC)
        }

        if let layer = self.layer as? CAShapeLayer {
            if viewState == .none || layer.path == nil {
                layer.path = path.cgPath
            } else {
                let animation = CABasicAnimation(keyPath: "path")
                animation.duration = animationDuration
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                animation.fromValue = layer.path
                animation.toValue = path.cgPath
                layer.add(animation, forKey: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    layer.path = path.cgPath
                }
            }
        }
    }

    func initSetup() {
        guard let layer = self.layer as? CAShapeLayer else { return }
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 5
        layer.path = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSetup()
    }
}
