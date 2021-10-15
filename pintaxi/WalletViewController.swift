//
//  WalletViewController.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
//import PaymentSDK
import BraintreeDropIn
import Braintree

class WalletViewController: BaseViewController {
    
    //MARK:- IBOutlets
    @IBOutlet private weak var labelBalance : Label!
    @IBOutlet private weak var textFieldAmount : UITextField!
    @IBOutlet private weak var viewWallet : UIView!
    @IBOutlet private weak var buttonAddAmount : UIButton!
    @IBOutlet var labelWallet: UILabel!
    @IBOutlet var labelAddMoney: UILabel!
    @IBOutlet private var buttonsAmount : [UIButton]!
    @IBOutlet private weak var viewCard : UIView!
    @IBOutlet private weak var con_add : NSLayoutConstraint!
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var viewSelectCard : UIView!

    var selectCard : Int = -1
    var selectedCardEntity : CardEntity?

    //MARK:- Local variable
    
    private var arrCard : [CardEntity] = []
    
    private var isWalletEnabled : Bool = false {
        didSet{
            self.buttonAddAmount.isEnabled = true //isWalletEnabled
//            self.buttonAddAmount.backgroundColor = isWalletEnabled ? .primary : .lightGray
            self.viewCard.isHidden = !isWalletEnabled
        }
    }
    

    
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDesign()
//        self.initalLoads()
        viewSelectCard.isHidden = true
        
        //SET VIEW
        setViewShadow(myView: viewCard)
        setViewShadow(myView: viewWallet)

        loadGoogleAdmob()
    }
    

    func setViewShadow(myView : UIView) {
        //SER CONFIRM REQUEST
        myView.layer.shadowPath =
            UIBezierPath(roundedRect: myView.bounds,
                         cornerRadius: myView.layer.cornerRadius).cgPath
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.2
        myView.layer.shadowOffset = CGSize(width: 2, height: 2)
        myView.layer.shadowRadius = 5
        myView.layer.masksToBounds = false
        myView.layer.cornerRadius = 10
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//        self.isWalletAvailable = User.main.isCardAllowed
        self.setWalletBalance()
        self.loader.isHidden = false
        self.presenter?.get(api: .getCards, parameters: nil)
        self.presenter?.get(api: .getProfile, parameters: nil)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // IQKeyboardManager.sharedManager().enable = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// Mark:- Local methods

extension WalletViewController {
    
    private func initalLoads() {
        self.navigationController?.isNavigationBarHidden = true

        self.view.dismissKeyBoardonTap()
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
//        self.navigationItem.title = Constants.string.wallet.localize()
        self.textFieldAmount.placeholder = String.removeNil(User.main.currency)+" "+"\(0)"
        self.textFieldAmount.delegate = self
        for (index,button) in buttonsAmount.enumerated() {
            button.tag = (index*100)+99
            button.setTitle(String.removeNil(String.removeNil(User.main.currency)+" \(button.tag)"), for: .normal)
        }
        self.isWalletEnabled = false
        KeyboardAvoiding.avoidingView = self.view
    }
    
    // Set Designs
    
    private func setDesign() {
        
        Common.setFont(to: labelBalance, isTitle: true)
        Common.setFont(to: textFieldAmount)
        labelAddMoney.text = Constants.string.addAmount.localize()
        labelWallet.text = Constants.string.yourWalletAmnt.localize()
        buttonAddAmount.setTitle(Constants.string.ADDAMT, for: .normal)
    }
    
    @IBAction private func buttonAmountAction(sender : UIButton) {
        
        textFieldAmount.text = "\(sender.tag)"
    }
    
   
    @IBAction private func buttonAddAmountClick() {
        self.view.endEditingForce()
        
        if textFieldAmount.text!.isEmpty{
            showAlert(message: "Please send amount", okHandler: nil, fromView: self)
        }
        else{
            if arrCard.count == 0{
                let addCardVc = storyboard?.instantiateViewController(withIdentifier: "AddCreditCardVC") as! AddCreditCardVC
                navigationController?.pushViewController(addCardVc, animated: true)
            }
            else{
                viewSelectCard.isHidden = false
            }
        }
    }
    
    //  Change Card Action
    @IBAction func btnBackClciekd() {
        print("sererwere")
        navigationController?.popViewController(animated: true)

    }
    @IBAction func btnOkClciekd() {
        if selectedCardEntity == nil{
            showAlert(message: "Please select care first", okHandler: nil, fromView: self)

        }else{
            self.loader.isHidden = false

            let dicData : [String : Any] = ["card_id" : self.selectedCardEntity?.card_id ?? "",
                                            "amount" : textFieldAmount.text ?? ""]
            let jsonData = try? JSONSerialization.data(withJSONObject:dicData)
            self.presenter?.post(api: Base.addMoney, data: jsonData)

        }
    
    }
    @IBAction func btnCancelClicked() {
        viewSelectCard.isHidden = true
     }
    
    private func setWalletBalance() {
        DispatchQueue.main.async {
            self.labelBalance.text = String.removeNil(User.main.currency)+" \(User.main.wallet_balance ?? "")"
        }
    }
}


extension WalletViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

}

// MARK:- PostViewProtocol

extension WalletViewController : PostViewProtocol {
    
     
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    
    func getProfile(api: Base, data: Profile?) {
        self.loader.isHidden = true

        Common.storeUserData(from: data)
        storeInUserDefaults()
        self.setWalletBalance()
    }
    
    func getCardEnities(api: Base, data: [CardEntity]) {
        self.loader.isHidden = true

        self.arrCard = data
        tblView.reloadData()

    }
    func getWalletEntity(api: Base, data: WalletEntity?) {
        
        self.loader.isHidden = true
        if data?.user?.wallet_balance != 0{
            User.main.wallet_balance = "\(data?.user?.wallet_balance ?? 0)"
            storeInUserDefaults()
            self.setWalletBalance()
            
            self.viewSelectCard.isHidden = true
            self.textFieldAmount.text = ""
            
        }
       
        UIApplication.shared.keyWindow?.makeToast(data?.message)
                
    }
}


//MARK:- BrainTree Payment
extension WalletViewController {
    
    func getBrainTreeToken(api: Base, data: TokenEntity) {
        guard let token: String = data.token else {
            return
        }
        self.showDropIn(newToken: token)
    }
    
    
    func showDropIn(newToken: String) {
        let newRequest =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: newToken, request: newRequest)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
                print(result)
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
}





// MARK: - Table Delegate -

class cardCell: UITableViewCell {
    @IBOutlet weak var lblCardNumber : UILabel!
    @IBOutlet weak var imgSelectCard : UIImageView!

}
extension WalletViewController : UITableViewDelegate,UITableViewDataSource{
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCard.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier : String = "cardCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath as IndexPath) as! cardCell
        
        let obj = arrCard[indexPath.row]
        cell.lblCardNumber.text = "XXXX-XXXX-XXXX-\(obj.last_four ?? "")"
        cell.imgSelectCard.image = UIImage(named: "ic_radio_unselect")
        
        if selectCard == indexPath.row{
            cell.imgSelectCard.image = UIImage(named: "ic_radio_select")
        }
        imgColor(img: cell.imgSelectCard, colorHex: "FFCC00")
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCard = indexPath.row
        selectedCardEntity = arrCard[indexPath.row]
        tblView.reloadData()
    }
}

