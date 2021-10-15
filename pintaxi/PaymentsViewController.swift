//
//  PaymentsViewController.swift
//  TranxitUser
//
//  Created by IndianRenters on 16/10/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class PaymentsViewController: BaseViewController{
    @IBOutlet weak var payTblView : UITableView!
    @IBOutlet weak var lblBalance : UILabel!
    @IBOutlet weak var viewCash : UIView!
    @IBOutlet weak var viewWallet : UIView!
    @IBOutlet weak var viewPaymentCard : UIView!
    @IBOutlet weak var imgPaypal : UIImageView!
    @IBOutlet weak var btnAddCard : UIButton!
    @IBOutlet weak var imgRazorpay : UIImageView!
    @IBOutlet weak var stackBanner: UIStackView!
    private var arrCard : [CardEntity] = []
    
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getpayListHit()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadGoogleAdmob1(stack: stackBanner)
    }
    
    override func viewWillLayoutSubviews() {
        setViewShadow(myView: viewCash)
        setViewShadow(myView: viewWallet)
        setViewShadow(myView: viewPaymentCard)
        
        btnAddCard.layer.masksToBounds = true
        btnAddCard.layer.cornerRadius = 5
        
        //CASH, CARD, WALLET, RAZORPAY, PAYPAL
        if Payment_type == "PAYPAL"{
            imgPaypal.image = UIImage(named: "ic_radio_select")
        }
        else if Payment_type == "RAZORPAY"{
            imgRazorpay.image = UIImage(named: "ic_radio_select")
        }
        
        let vw_Table = payTblView.tableHeaderView
        vw_Table?.frame = CGRect(x: 0, y: 0, width: payTblView.frame.size.width, height: 70)
        payTblView.tableHeaderView = vw_Table
        
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
//        self.loader.isHidden = false
//        self.presenter?.get(api: .getCards, parameters: nil)

        self.lblBalance.text = "Your wallet amount is \(String.removeNil(User.main.currency)+" \(User.main.wallet_balance ?? "")")"
        
    }
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChat(_ sender: Any) {
        let chatVC = storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
    @IBAction func btnAddWalletClicked(_ sender: Any) {
        let addCardVc = storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
        navigationController?.pushViewController(addCardVc, animated: true)
    }
    @IBAction func btnAddCard(_ sender: Any) {
        let addCardVc = storyboard?.instantiateViewController(withIdentifier: "AddCreditCardVC") as! AddCreditCardVC
        navigationController?.pushViewController(addCardVc, animated: true)
    }
    
    @IBAction func btnSelectCashlicked(_ sender: Any) {
        Payment_type = "CASH"
        selected_Card = nil
        selectcardIndex = -1
        navigationController?.popViewController(animated: true)
        

    }
    @IBAction func btnSelectWalletlicked(_ sender: Any) {
        if User.main.wallet_balance ?? "" != "" || User.main.wallet_balance ?? "" != "0"{
            Payment_type = "WALLET"
            selected_Card = nil
            selectcardIndex = -1
            navigationController?.popViewController(animated: true)
        }
        
    }
    @IBAction func btnPaypalClicked(_ sender: Any) {
        Payment_type = "PAYPAL"
        selected_Card = nil
        selectcardIndex = -1
        
        imgPaypal.image = UIImage(named: "ic_radio_select")
        imgRazorpay.image = UIImage(named: "ic_radio_unselect")
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnRazorpayClicked(_ sender: Any) {
        Payment_type = "RAZORPAY"
        selected_Card = nil
        selectcardIndex = -1
        
        imgPaypal.image = UIImage(named: "ic_radio_unselect")
        imgRazorpay.image = UIImage(named: "ic_radio_select")
        navigationController?.popViewController(animated: true)
        
    }
}



// MARK:- PostViewProtocol

extension PaymentsViewController : PostViewProtocol {
    func onError(api: Base, message: String, statusCode code: Int) {
        self.loader.isHidden = true
        showAlert(message: message, okHandler: nil, fromView: self)
    }
    
    func getCardEnities(api: Base, data: [CardEntity]) {
        self.loader.isHidden = true

        self.arrCard = data
        payTblView.reloadData()
        
    }
    
}

extension PaymentsViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "payTblCell", for: indexPath) as! payTblCell
        let dic = arrCard[indexPath.row]
        //let promoCode = dic["last_four"]
        cell.payLbl.text = "XXXX-XXXX-XXXX-" + "\(dic.last_four ?? "")"
        cell.imgSelectCard.image = UIImage(named: "ic_radio_unselect")
        if selectcardIndex == indexPath.row{
            cell.imgSelectCard.image = UIImage(named: "ic_radio_select")
        }
        imgColor(img: cell.payImg, colorHex: "9A9A9A")
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Payment_type = "CARD"
        selected_Card = arrCard[indexPath.row]
        selectcardIndex = indexPath.row
        
        //RELOAD TABLE
        payTblView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}


class payTblCell:UITableViewCell{
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnGray: UIButton!
    @IBOutlet weak var payLbl: UILabel!
    @IBOutlet weak var payImg: UIImageView!
    @IBOutlet weak var imgSelectCard: UIImageView!
    
}
