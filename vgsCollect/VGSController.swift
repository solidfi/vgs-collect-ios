//
//  ViewController.swift
//  vgsCollect
//
//  Created by Copyright © 2021 Solid. All rights reserved.
//

import UIKit
import MBProgressHUD

class VGSController: UIViewController {
    
    @IBOutlet weak var txtVGSVaultID: UITextField!
    @IBOutlet weak var txtCardToken: UITextField!
    @IBOutlet weak var txtCardID: UITextField!
    @IBOutlet weak var txtEnvironment: UITextField!
    @IBOutlet weak var txtLast4CardDigit: UITextField!
    @IBOutlet weak var txtExpMonth: UITextField!
    @IBOutlet weak var txtExpYear: UITextField!
    @IBOutlet weak var txt4DigitPin: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var vgsModalView = VGSModalView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "VGS Collect Sample"
        setUpUI()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setUpUI()
    }
    
    @IBAction func btnSubmitPress(_ sender: Any) {
        self.validationCheck()
    }
}

// MARK: - Textfield delegate method
extension VGSController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtEnvironment {
            self.showEnvironmentActionSheet()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtExpYear || textField == txtLast4CardDigit || textField == txt4DigitPin {
            return vgsModalView.validateTextField(validateTextField: textField, validateText: string)
        } else if textField == txtExpMonth {
            return vgsModalView.validateTextField(validateTextField: textField, validateText: string)
        } else {
            return true
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtEnvironment {
            self.showEnvironmentActionSheet()
            return false
        } else {
            return true
        }
    }
}

// MARK: - Setup UI and Validation methods
extension VGSController {
    
    func setUpUI() {
        btnSubmit.layer.borderWidth = 1.0
        btnSubmit.layer.borderColor = UIScreen.main.traitCollection.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
        btnSubmit.tintColor = UIScreen.main.traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
    }

    func showEnvironmentActionSheet() {
        self.view.endEditing(true)
        let alert = UIAlertController(title: "" , message: "Please select Environment", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Sandbox", style: .default , handler:{ (UIAlertAction)in
            self.txtEnvironment.text = "Sandbox"
        }))
        
        alert.addAction(UIAlertAction(title: "Live", style: .default , handler:{ (UIAlertAction)in
            self.txtEnvironment.text = "Live"
        }))

        self.present(alert, animated: true, completion: {
            })
    }
    
    func validationCheck() {
        if let cardID = txtCardID.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            vgsModalView.vgsCardID = cardID
        }
        
        if let cardToken = txtCardToken.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            vgsModalView.vgsCardToken = cardToken
        }
        
        if let digitPin = txt4DigitPin.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            vgsModalView.vgsDigitPin = digitPin
        }
        
        if let environment = txtEnvironment.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            vgsModalView.vgsEnvironmentType = environment
        }
        
        if let expMonth = txtExpMonth.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            vgsModalView.vgsExpMonth = expMonth
        }
        
        if let expYear = txtExpYear.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            vgsModalView.vgsExpYear = expYear
        }
        
        if let vaultID = txtVGSVaultID.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            vgsModalView.vgsVaultID = vaultID
        }
        
        if let cardLast4Digit = txtLast4CardDigit.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            vgsModalView.vgsLast4CardDigit = cardLast4Digit
        }
        
        self.vgsModalView.validationCheck { (isValid,msg) in
            if !isValid {
                let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.callVGSCollectAPI()
            }
        }
    }
}

// MARK: - VGS Collect API Call
extension VGSController {
    func callVGSCollectAPI(){
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.vgsModalView.callVGSAPI { (isValid,msg) in
            progressHUD.hide(animated: true)
            let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
