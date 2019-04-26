//
//  SecondViewController.swift
//  My Resume
//
//  Created by Георгий Кашин on 24/04/2019.
//  Copyright © 2019 Georgii Kashin. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var information = ""
    var isHidden = true
    
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        informationLabel.text = information
        showMoreButton.isHidden = isHidden
    }
}
