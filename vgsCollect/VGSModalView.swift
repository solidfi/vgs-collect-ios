//
//  VGSModalView.swift
//  vgsCollect
//
//  Copyright © 2022 Solid. All rights reserved.
//

import Foundation
import UIKit
import VGSCollectSDK
import VGSShowSDK

class VGSModalView {
    var vgsVaultID = String()
    var vgsCardToken = String()
    var vgsCardID = String()
    var vgsContactID = String() //for Link Card
    var vgsEnvironmentType = String()
    var vgsLast4CardDigit = String()
    var vgsCardNumber = String() //for Link Card
    var vgsExpMonth = String()
    var vgsExpYear = String()
    var vgsDigitPin = String()
    var path = String()
    
    func validationCheck(completion:@escaping((Bool, String?) -> Void)) {
        if  vgsVaultID == "" || vgsExpYear == "" || vgsCardToken == "" || vgsCardID == "" || vgsEnvironmentType == "" || vgsLast4CardDigit == "" || vgsExpMonth == "" || vgsDigitPin == "" {
            completion(false,"All fields are mendatory")
        } else if !vgsExpYear.isYearGreate{
            completion(false,"Expiration year should be greater or equal to current year!")
        } else {
            completion(true,nil)
        }
    }
    
    func validationCheckForLinkCard(completion:@escaping((Bool, String?) -> Void)) {
        if  vgsVaultID == "" || vgsExpYear == "" || vgsCardToken == "" || vgsContactID == "" || vgsEnvironmentType == "" || vgsCardNumber == "" || vgsExpMonth == "" {
            completion(false,"All fields are mendatory")
        } else if !vgsExpYear.isYearGreate{
            completion(false,"Expiration year should be greater or equal to current year!")
        } else {
            completion(true,nil)
        }
    }
    
    func validateTextField(validateTextField : UITextField?, validateText: String?) -> Bool {
        if validateText == "" {
            return true
        } else if validateTextField?.tag == 4 || validateTextField?.tag == 6 || validateTextField?.tag == 7 {
            if let validateTextFieldStr = validateTextField?.text , let validTextStr = validateText {
                let validateStr = validateTextFieldStr + validTextStr
                
                if validateStr.count <= 4 && validateStr.isNumeric {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
            
        } else if validateTextField?.tag == 5{
            if let validateTextFieldStr = validateTextField?.text , let validTextStr = validateText {
                let validateStr = validateTextFieldStr + validTextStr
                if validateStr.count <= 2 && validateStr.isNumeric  && Int(validateStr)! <= 12 {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        } else {
            return true
        }
    }
}

// MARK: - VGS Collect API Call for Set PIN
extension VGSModalView {
    func callVGSAPI(completion:@escaping((Bool, String?) -> Void)) {

        let environment = vgsEnvironmentType == "Sandbox" ? VGSEnvironment.sandbox : VGSEnvironment.live

        let vgsCollect = VGSCollect(id: vgsVaultID, environment: environment.rawValue)

        let param = ["pin": vgsDigitPin,
                     "expiryMonth": vgsExpMonth,
                     "expiryYear": vgsExpYear,
                     "last4": vgsLast4CardDigit]
        
        vgsCollect.customHeaders = [
            "sd-pin-token": vgsCardToken,
            "content-type": "application/json;charset=UTF-8"
        ]
        
        self.path = "/v2/card/\(vgsCardID)/pin"
        
        vgsCollect.sendData(path: self.path, method: .post, extraData: param as [String: Any]) {(response) in
            
            switch response {
                
            case .success(_, let data, _):
                if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                   debugPrint(jsonData)
                    completion(true, "Pin set successfully")
                } else {
                    completion(true, nil)
                }
                return
            case .failure(let code, _, _, let error):
                switch code {
                case 400..<499:
                    debugPrint("Error: Wrong Request, code: \(code)")
                case VGSErrorType.inputDataIsNotValid.rawValue:
                    if let error = error as? VGSError {
                        debugPrint("Error: Input data is not valid. Details:\n \(error)")
                    }
                default:
                    debugPrint("Error: Something went wrong. Code: \(code)")
                }
                completion(false, "Something went wrong, please try again.")
                print("Submit request error: \(code), \(String(describing: error))")
                return
            }
        }
    }
}

// MARK: - VGS Collect API Call to Link Debit card
extension VGSModalView {
    
    func callVGSAPIToLinkCard(completion:@escaping((Bool, String?) -> Void)) {

        let environment = vgsEnvironmentType == "Sandbox" ? VGSEnvironment.sandbox : VGSEnvironment.live

        let vgsCollect = VGSCollect(id: vgsVaultID, environment: environment.rawValue)

        let param = ["debitCard": ["cardNumber": vgsCardNumber,
                          "expiryMonth": vgsExpMonth,
                          "expiryYear": vgsExpYear,
                          //This is dummy address data..
                          //Use your card address data here...
                          "address": ["line1": "12340 Boggy Creek Rd",
                                      "line2": "",
                                      "city": "Orlando",
                                      "state": "FL",
                                      "postalCode": "32824",
                                      "country": "US"
                                     ]]]  as [String : Any]
    
        vgsCollect.customHeaders = [
            "sd-debitcard-token": vgsCardToken,
            "content-type": "application/json;charset=UTF-8"
        ]
        
        self.path = "/v2/contact/\(vgsContactID)/debitcard"
        
        vgsCollect.sendData(path: self.path, method: .patch, extraData: param as [String: Any]) {(response) in
            
            switch response {
                
            case .success(_, let data, _):
                if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                   debugPrint(jsonData)
                    completion(true, "Card linked successfully")
                } else {
                    completion(true, nil)
                }
                return
            case .failure(let code, _, _, let error):
                switch code {
                case 400..<499:
                    debugPrint("Error: Wrong Request, code: \(code)")
                case VGSErrorType.inputDataIsNotValid.rawValue:
                    if let error = error as? VGSError {
                        debugPrint("Error: Input data is not valid. Details:\n \(error)")
                    }
                default:
                    debugPrint("Error: Something went wrong. Code: \(code)")
                }
                completion(false, "Something went wrong, please try again.")
                print("Submit request error: \(code), \(String(describing: error))")
                return
            }
        }
    }
}
