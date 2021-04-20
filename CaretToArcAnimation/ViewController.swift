//
//  ViewController.swift
//  CaretToArcAnimation
//
//  Copyright 2021 Duncan Champney
//  Licensed under the MIT source license
//

import UIKit

class ViewController: UIViewController {

    let animationDuration = 0.5
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var rotateSwitch: UISwitch!
    var viewState: ViewState = .none

    @IBOutlet weak var caretToArcView: CaretToArcView!
    override func viewDidLoad() {
        super.viewDidLoad()
        caretToArcView.viewState = .caret
        caretToArcView.animationDuration = animationDuration
        // Do any additional setup after loading the view.
    }

    @IBAction func handleToggleButton(_ sender: UIButton) {
        toggleButton.isEnabled = false
        rotateSwitch.isEnabled = false
        caretToArcView.viewState = caretToArcView.viewState == .caret ? .arc : .caret
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.toggleButton.isEnabled = true
            self.rotateSwitch.isEnabled = true
        }
    }

    @IBAction func toggleShowBezierPoints(_ sender: UISwitch) {
        caretToArcView.showBezierPathIllustration = sender.isOn
    }
    @IBAction func handleRotateSwitch(_ sender: UISwitch) {
        toggleButton.isEnabled = !sender.isOn
        caretToArcView.rotate(sender.isOn)
    }

}


