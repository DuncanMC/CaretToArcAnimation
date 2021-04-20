//
//  ViewController.swift
//  CaretToArcAnimation
//
//  Created by Duncan Champney on 4/19/21.
//

import UIKit

class ViewController: UIViewController {

    var viewState: ViewState = .none

    @IBOutlet weak var caretToArcView: CaretToArcView!
    override func viewDidLoad() {
        super.viewDidLoad()
        caretToArcView.viewState = .caret
        // Do any additional setup after loading the view.
    }

    @IBAction func handleAnimateButton(_ sender: Any) {
        caretToArcView.viewState = caretToArcView.viewState == .caret ? .arc : .caret
    }

}

