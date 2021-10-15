//
//  ReasonView.swift
//  User
//
//  Created by CSS on 26/07/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class ReasonView: UIView, UIScrollViewDelegate {
    
    @IBOutlet private weak var scrollView : UIScrollView!
    @IBOutlet private weak var labelTitle : UILabel!
    @IBOutlet private weak var buttonClose : UIButton!
    @IBOutlet private weak var txtReason : UITextField!

    @IBOutlet weak var btnCancel1: UIButton!
    @IBOutlet weak var btnCancel2: UIButton!
    @IBOutlet weak var btnCancel3: UIButton!
    @IBOutlet weak var btnCancel4: UIButton!
    @IBOutlet weak var btnCancel5: UIButton!

    @IBOutlet var con_ResionHeight: NSLayoutConstraint!
    
    @IBOutlet var con_ViewHeight: NSLayoutConstraint!
    
    private var datasource:[String] = []
    private var selectedIndexPath = IndexPath(row: -1, section: -1)
    
    var onClickClose : ((Bool)->Void)?
    var didSelectReason : ((String)->Void)?
    
    private var isShowTextView = false {
        didSet {
//            self.tableview.tableFooterView = isShowTextView ? self.getTextView() : nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.tableview.dataSource = self
//        self.tableview.delegate = self
//        self.tableview.register(UINib(nibName: XIB.Names.CancelListTableViewCell, bundle: nil), forCellReuseIdentifier: XIB.Names.CancelListTableViewCell)
        
        con_ResionHeight.constant = 0
        con_ViewHeight.constant = 0
        self.isShowTextView = false
        Common.setFont(to: labelTitle)
        labelTitle.text = Constants.string.reasonForCancellation.localize()
        buttonClose.addTarget(self, action: #selector(self.buttonCloseAction), for: .touchUpInside)
    }
    @IBAction func btnSubmitClicked(_ sender: Any) {
        if txtReason.text!.isEmpty{
     
            DispatchQueue.main.async {
                if let viewController = UIApplication.topViewController() {
                    showAlert(message: "Please enter reason", okHandler: nil, fromView: viewController)
                }
            }
        }
        else{
            self.didSelectReason?(self.datasource[self.selectedIndexPath.row])
        }
    }
}

// MARK:-  Local Methods

extension ReasonView {
    
    // Creating Dynamic Text View
    
    private func getTextView()->UIView{
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height/2))
        let textView = UITextView(frame: CGRect(x: 16, y: 8, width: self.frame.width-32, height: (self.frame.height/2)-16))
        //textView.contentInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        Common.setFont(to: textView)
        textView.returnKeyType = .send
        textView.enablesReturnKeyAutomatically = true
        textView.delegate = self
        textView.borderLineWidth = 1
        textView.cornerRadius = 10
        textView.borderColor = .lightGray
        textView.toolbarPlaceholder = Constants.string.othersIfAny.localize()
        scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height)
        textView.becomeFirstResponder()
        view.addSubview(textView)
        return view
    }
    
    func set(value:[ReasonEntity])  {
//        for reason in value {
//            self.datasource.append(reason.reason!)
//        }
        self.datasource.append("Plan Change")
        self.datasource.append("Booked another cab")
        self.datasource.append("My reason is not listed")
        self.datasource.append("Driver is not moving")
        self.datasource.append("Driver Denied to Come")
//        self.datasource.append(Constants.string.othersIfAny)
//        self.tableview.reloadInMainThread()
    }
    
    // Button Done Action
    
    @IBAction private func buttonCloseAction() {
        self.onClickClose!(true)
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {

        con_ResionHeight.constant = 40
        con_ViewHeight.constant = 1
        btnCancel1.setImage(UIImage(named: "ic_radio_unselect"), for: .normal)
        btnCancel2.setImage(UIImage(named: "ic_radio_unselect"), for: .normal)
        btnCancel3.setImage(UIImage(named: "ic_radio_unselect"), for: .normal)
        btnCancel4.setImage(UIImage(named: "ic_radio_unselect"), for: .normal)
        btnCancel5.setImage(UIImage(named: "ic_radio_unselect"), for: .normal)

        if sender.tag == 0{
            btnCancel1.setImage(UIImage(named: "ic_radio_select"), for: .normal)

        }else if sender.tag == 1{
            btnCancel2.setImage(UIImage(named: "ic_radio_select"), for: .normal)

        }else if sender.tag == 2{
            btnCancel3.setImage(UIImage(named: "ic_radio_select"), for: .normal)

        }else if sender.tag == 3{
            btnCancel4.setImage(UIImage(named: "ic_radio_select"), for: .normal)

        }else if sender.tag == 4{
            btnCancel5.setImage(UIImage(named: "ic_radio_select"), for: .normal)
        }
    }
}

// MARK:- UITableViewDelegate

extension ReasonView : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.2) {
//
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
//        tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
        self.selectedIndexPath = indexPath
        tableView.reloadData()
        
//        tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .checkmark
//
//        if (indexPath.row == (datasource.count-1)) {
//            if !self.isShowTextView {
//                self.isShowTextView = true
//            }
//        }
//        else {
//            self.didSelectReason?(self.datasource[indexPath.row])
//        }
    }
}

// MARK:- UITableViewDataSource

//extension ReasonView: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return datasource.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let tableCell = tableview.dequeueReusableCell(withIdentifier: XIB.Names.CancelListTableViewCell, for: indexPath) as? CancelListTableViewCell, self.datasource.count > indexPath.row {
//
//            tableCell.lblName.text = self.datasource[indexPath.row]
//            tableCell.imgSelect.image = UIImage(named: "ic_radio_unselect")
//            if self.selectedIndexPath.row == indexPath.row{
//                tableCell.imgSelect.image = UIImage(named: "ic_radio_select")
//            }
//
//            imgColor(img: tableCell.imgSelect, colorHex: "FFDD59")
//            Common.setFont(to:  tableCell.lblName)
//            return tableCell
//        }
//        return UITableViewCell()
//    }
//}

// MARK:- UITextViewDelegate

extension ReasonView : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            self.didSelectReason?(textView.text)
            return false
        }
        return true
    }
}

