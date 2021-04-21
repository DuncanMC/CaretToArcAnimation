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

    public var animationDuration: Double = 0.2
    public var viewState: ViewState = .none {
        didSet {
            buildPath()
        }
    }
    public var showBezierPathIllustration: Bool? {
        didSet {
            bezierIllustrationLayer.opacity = showBezierPathIllustration == true ? 1 : 0
        }
    }
    private var rotation = 0.0
    private var bezierIllustrationLayer = CAShapeLayer()

    override var frame: CGRect {
        didSet {
            bezierIllustrationLayer.frame = layer.bounds
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

    func circleRect(centerPoint: CGPoint) -> CGRect {
        return CGRect(origin: centerPoint, size: CGSize.zero).insetBy(dx: -3, dy: -3)
    }

    private func buildPath() {
        let path = UIBezierPath()
        let illustrationPath = UIBezierPath()
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

            let caretBezier2PointB = CGPoint(x: caretEnd.x + abs(caretEnd.x - caretMiddle.x)*2/3,
                                             y: caretEnd.y + abs(caretEnd.y - caretMiddle.y)*2/3)
            let caretBezier2PointC = CGPoint(x: caretEnd.x + abs(caretEnd.x - caretMiddle.x)/3,
                                             y: caretEnd.y + abs(caretEnd.y - caretMiddle.y)/3)

            path.move(to: caretStart)
            path.addCurve(to: caretMiddle, controlPoint1: caretBezier1PointB, controlPoint2: caretBezier1PointC)
            path.addCurve(to: caretEnd, controlPoint1: caretBezier2PointB, controlPoint2: caretBezier2PointC)

            // Now build a path to illustrate the Bezier path control points for the caret
            var oval: UIBezierPath
            oval = UIBezierPath(ovalIn: circleRect(centerPoint: caretStart))
            illustrationPath.append(oval)

            oval = UIBezierPath(ovalIn: circleRect(centerPoint: caretBezier1PointB))
            illustrationPath.append(oval)

            oval = UIBezierPath(ovalIn: circleRect(centerPoint: caretBezier1PointC))
            illustrationPath.append(oval)

            oval = UIBezierPath(ovalIn: circleRect(centerPoint: caretMiddle))
            illustrationPath.append(oval)

            oval = UIBezierPath(ovalIn: circleRect(centerPoint: caretBezier2PointB))
            illustrationPath.append(oval)

            oval = UIBezierPath(ovalIn: circleRect(centerPoint: caretBezier2PointC))
            illustrationPath.append(oval)

            oval = UIBezierPath(ovalIn: circleRect(centerPoint: caretEnd))
            illustrationPath.append(oval)

            illustrationPath.move(to: caretStart)
            illustrationPath.addLine(to: caretBezier1PointB)
            illustrationPath.addLine(to: caretBezier1PointC)
            illustrationPath.addLine(to: caretMiddle)
            illustrationPath.addLine(to: caretBezier2PointB)
            illustrationPath.addLine(to: caretBezier2PointC)
            illustrationPath.addLine(to: caretEnd)

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


            // Now build a path to illustrate the Bezier path control points.
            var oval: UIBezierPath
            oval = UIBezierPath(ovalIn: circleRect(centerPoint: arcBezier1PointA))
            illustrationPath.append(oval)

            oval = UIBezierPath(ovalIn: circleRect(centerPoint: arcBezier1PointB))
            illustrationPath.append(oval)

            oval = UIBezierPath(ovalIn: circleRect(centerPoint: arcBezier1PointC))
            illustrationPath.append(oval)

            oval = UIBezierPath(ovalIn: circleRect(centerPoint: arcMiddle))
            illustrationPath.append(oval)

            oval = UIBezierPath(ovalIn: circleRect(centerPoint: arcBezier2PointB))
            illustrationPath.append(oval)

            oval = UIBezierPath(ovalIn: circleRect(centerPoint: arcBezier2PointC))
            illustrationPath.append(oval)

            oval = UIBezierPath(ovalIn: circleRect(centerPoint: arcBezier2PointD))
            illustrationPath.append(oval)

            illustrationPath.move(to: arcBezier1PointA)
            illustrationPath.addLine(to: arcBezier1PointB)
            illustrationPath.addLine(to: arcBezier1PointC)
            illustrationPath.addLine(to: arcMiddle)
            illustrationPath.addLine(to: arcBezier2PointB)
            illustrationPath.addLine(to: arcBezier2PointC)
            illustrationPath.addLine(to: arcBezier2PointD)
        }

        if let layer = self.layer as? CAShapeLayer {
            if viewState == .none || layer.path == nil {
                layer.path = path.cgPath
                bezierIllustrationLayer.path = illustrationPath.cgPath
            } else {
                let pathAnimation = CABasicAnimation(keyPath: "path")
                pathAnimation.duration = animationDuration
                pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                pathAnimation.fromValue = layer.path
                pathAnimation.toValue = path.cgPath

                // This animation does not work when added to an animation group applied to the parent layer of the bezierIllustrationLayer
                let bezierPathAnimation = CABasicAnimation(keyPath: "sublayers.bezierillustrationlayer.path")
                bezierPathAnimation.duration = animationDuration
                bezierPathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                bezierPathAnimation.fromValue = bezierIllustrationLayer.path
                bezierPathAnimation.toValue = illustrationPath.cgPath

//                If I add this rotation animation to the animation group, it works
//                let rotationAnimation = CABasicAnimation(keyPath: "sublayers.bezierillustrationlayer.transform.rotation.z")
//                rotationAnimation.duration = 1.0
//                rotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//                rotationAnimation.fromValue = 0
//                rotationAnimation.toValue  = CGFloat.pi * 2

                let animationGroup = CAAnimationGroup()
                animationGroup.duration = animationDuration
                animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                animationGroup.animations = [pathAnimation, bezierPathAnimation]
                layer.add(animationGroup, forKey: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    layer.path = path.cgPath
                    self.bezierIllustrationLayer.path = illustrationPath.cgPath
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
        bezierIllustrationLayer.name = "bezierillustrationlayer"
        bezierIllustrationLayer.strokeColor = UIColor(red: 192, green: 0, blue: 0, alpha: 0.4).cgColor
        bezierIllustrationLayer.fillColor = UIColor.clear.cgColor
        bezierIllustrationLayer.lineWidth = 2
        layer.addSublayer(bezierIllustrationLayer)
        showBezierPathIllustration = false
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
