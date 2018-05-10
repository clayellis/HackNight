//
//  ViewController.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let mainView = MainView()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

