//
//  AddCreditCardVC.swift
//  TranxitUser
//
//  Created by 99appdev on 16/10/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Stripe
import Alamofire


class AddCreditCardVC: UIViewController,UITextFieldDelegate,ServerCommunicationApiDelegate {
    @IBOutlet weak var textFieldCardNumber: UITextField!
    @IBOutlet weak var textFieldExpiryDate: UITextField!
    @IBOutlet weak var textFieldCVVnumber: UITextField!
    @IBOutlet weak var imgCard: UIImageView!

    var months:String = ""
    

    
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
   


    override func viewDidLoad() {
        super.viewDidLoad()
        imgColor(img: imgCard, colorHex: "9A9A9A")
        
        self.textFieldCardNumber.delegate = self
        self.textFieldExpiryDate.delegate = self
        self.textFieldCVVnumber.delegate = self
        
       self.textFieldCardNumber.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
    }
    
    @IBAction func selectExpiryBtn(_ sender: Any) {
        AKMonthYearPickerView.sharedInstance.barTintColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        AKMonthYearPickerView.sharedInstance.previousYear = 60
        AKMonthYearPickerView.sharedInstance.show(vc: self, doneHandler: doneHandler, completetionalHandler: completetionalHandler)
    }
    func doneHandler() {
        
    }
     func completetionalHandler(month: Int, year: Int) {
        //print( "month = ", month, " year = ", year )
        switch month {
        case 1,2,3,4,5,6,7,8,9:
           months = "0" + "\(month)"
            break
        case 10,11,12:
            months = "\(month)"
            break
        default:
            print("")
        }
        let yearStr = String("\(year)".suffix(2))
        textFieldExpiryDate.text = "\(months)" + "/" + yearStr
        
    }
    
    
    @IBAction func addCardBtn(_ sender: Any) {
        if textFieldCardNumber.text == "" || textFieldExpiryDate.text == "" || textFieldCVVnumber.text == ""{
            showAlert(message: "Please enter all fields.", okHandler: nil, fromView: self)
            
        }else{
            let trimmedCardNo = textFieldCardNumber.text!.removingWhitespaces()
            let month = String(textFieldExpiryDate.text!.prefix(2))
            let yyyy = String(textFieldExpiryDate.text!.suffix(2))
            let cardParams = STPCardParams()
            cardParams.number = trimmedCardNo
            cardParams.expMonth = UInt(month) ?? 0
            cardParams.expYear = UInt(yyyy) ?? 0
            cardParams.cvc = textFieldCVVnumber.text!
           
            STPAPIClient.shared().createToken(withCard: cardParams) { token, error in
                guard let token = token else {
                    // Handle the error
                    print(error!.localizedDescription)
                    showAlert(message: error!.localizedDescription, okHandler: nil, fromView: self)
                    return
                }
                print(token)
                DispatchQueue.main.async {
                    self.loader.isHidden = false
                }
                let url =  "\(baseUrl)\(Base.addCard.rawValue)"
                let params:Parameters = ["stripe_token":"tok_mastercard_debit"]
                let network = NetworkHelper()
                network.delegate = self
                network.getDataFromUrlWithAccessPOST(url: url, requestName: Base.addCard.rawValue, headerField: "", parameter: params)
           }
        }
        
    }
    
    //MARK:- Receive Service Methods
    func dataReceiveFromService(dic: Dictionary<String, Any>, requestName: String) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            print(dic)
            switch requestName{
            case Base.addCard.rawValue :
                if dic.keys.contains("error") {
                    showAlert(message: dic["error"] as? String ?? "", okHandler: nil, fromView: self)
                }else{
                    if dic.keys.contains("message") {
                        showAlert(message: dic["message"] as? String ?? "", okHandler: nil, fromView: self)
                        
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                
                
            default:
                print("default")
            }
        }
    }
    
    func dataFailure(error: String, requestName: String) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
        }
        showAlert(message: error, okHandler: nil, fromView: self)
        // self.showAlertMessage(titleStr:"Quick Ride User", messageStr:error)
        print(error)
    }
    
    
    // Mark:- Textfield Methods

    @objc func didChangeText(textField:UITextField) {
        textField.text = self.modifyCreditCardString(creditCardString: textField.text!)
    }
     // Card number
    func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
   

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textFieldCardNumber{
        let newLength = (textField.text ?? "").count + string.count - range.length
        if(textField == textFieldCardNumber) {
            return newLength <= 19
         }
       }
        else if textField == textFieldExpiryDate {

        }
        else if textField == textFieldCVVnumber {
            let currentText = textField.text! as NSString
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            if(textField == textFieldCVVnumber) {
                return updatedText.count <= 3
            }
            
        }
        return true
    }
    
    // Mark:- Action methods

    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
   
    

}

extension Date {
    
    func dateString(_ format: String = "MM/YY") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}

// MARK:- STPPaymentCardTextFieldDelegate





/*let currentText = textField.text! as NSString
 let updatedText = currentText.replacingCharacters(in: range, with: string)
 if updatedText.count <= 5{
 textField.text = updatedText
 let numberOfCharacters = updatedText.count
 if numberOfCharacters == 2 {
 textField.text?.append("/")
 
 }
 // return false
 }
 return false*/
