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

    public var viewState: ViewState = .none {
        didSet {
            buildPath()
        }
    }

    class override var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    private func buildPath() {
        let path = UIBezierPath()
        switch viewState {
        case .none:
            break
        case .caret:
            let caretStart = CGPoint(x: 200, y: 280)
            let caretMiddle = CGPoint(x: 280, y: 200)
            let caretEnd = CGPoint(x: 200, y: 120)

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
        case .arc:
            let arcBezier1PointA = CGPoint(x: 111, y: 288)
            let arcBezier1PointB = CGPoint(x: 190, y: 367)
            let arcBezier1PointC = CGPoint(x: 325, y: 311)

            let arcMiddle = CGPoint(x: 325, y: 200) //arcBezier1PointD and arcBezier2PointA

            let arcBezier2PointB = CGPoint(x: 325, y:  89)
            let arcBezier2PointC = CGPoint(x: 190, y:  33)
            let arcBezier2PointD = CGPoint(x: 111, y: 112)

            path.move(to: arcBezier1PointA)
            path.addCurve(to: arcMiddle, controlPoint1: arcBezier1PointB, controlPoint2: arcBezier1PointC)
            path.addCurve(to: arcBezier2PointD, controlPoint1: arcBezier2PointB, controlPoint2: arcBezier2PointC)
        }
        if let layer = self.layer as? CAShapeLayer {

            if viewState == .none || layer.path == nil {
                layer.path = path.cgPath
            } else {
                let animation = CABasicAnimation(keyPath: "path")
                animation.duration = 1.0
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

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
        layer.lineWidth = 1
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