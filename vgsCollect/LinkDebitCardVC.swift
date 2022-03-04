//
//  LinkDebitCardVC.swift
//  vgsCollect
//
//  Created by Copyright © 2022 Solid. All rights reserved.
//

import UIKit
import MBProgressHUD

class LinkDebitCardVC: UIViewController {

    @IBOutlet weak var txtVGSVaultID: UITextField!
    @IBOutlet weak var txtCardToken: UITextField!
    @IBOutlet weak var txtContactID: UITextField!
    @IBOutlet weak var txtEnvironment: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtExpMonth: UITextField!
    @IBOutlet weak var txtExpYear: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var vgsModalView = VGSModalView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Link Debit Card"
    }

    @IBAction func btnSubmitPress(_ sender: Any) {
        self.validationCheck()
    }
}

// MARK: - Textfield delegate method
extension LinkDebitCardVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtEnvironment {
            self.showEnvironmentActionSheet()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtExpYear {
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
extension LinkDebitCardVC {
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
        if let vaultID = txtVGSVaultID.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            vgsModalView.vgsVaultID = vaultID
        }
        
        if let contactID = txtContactID.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            vgsModalView.vgsContactID = contactID
        }
        
        if let cardToken = txtCardToken.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            vgsModalView.vgsCardToken = cardToken
        }
        
        if let environment = txtEnvironment.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            vgsModalView.vgsEnvironmentType = environment
        }
        
        if let cardNumber = txtCardNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            vgsModalView.vgsCardNumber = cardNumber
        }
        
        if let expMonth = txtExpMonth.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            vgsModalView.vgsExpMonth = expMonth
        }
        
        if let expYear = txtExpYear.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            vgsModalView.vgsExpYear = expYear
        }
        
        self.vgsModalView.validationCheckForLinkCard { (isValid,msg) in
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
extension LinkDebitCardVC {
    func callVGSCollectAPI(){
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.vgsModalView.callVGSAPIToLinkCard { (isValid,msg) in
            progressHUD.hide(animated: true)
            let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
