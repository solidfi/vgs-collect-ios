//
//  OptionsSelectionVC.swift
//  vgsCollect
//
//  Created by Copyright © 2022 Solid. All rights reserved.
//

import UIKit

class OptionsSelectionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Select Action"
    }
    
    @IBAction func btnSetPinPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToSetPin", sender: self)
    }
    
    @IBAction func btnLinkDebitCardPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToLinkCard", sender: self)
    }
}
