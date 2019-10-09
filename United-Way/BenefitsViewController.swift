//
//  BenefitsViewController.swift
//  United-Way
//
//  Created by Sharaf Nazaar on 10/8/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class BenefitsViewController: UIViewController {

    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var lowerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        centerLabel.text = "Benefit Kitchen"
        lowerLabel.text = ""
    }


}

