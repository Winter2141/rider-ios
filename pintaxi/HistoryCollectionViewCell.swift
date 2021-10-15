//
//  HistoryCollectionViewCell.swift
//  TranxitUser
//
//  Created by 99appdev on 27/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
protocol HistoryCellAction {
    func getRowIndexClicked (indexClicked : Int , dictClicked : [String : Any])
    func BookingCancel(strCancelID : Int)
}


class UpcomingHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var imgPath: UIImageView!
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblBookingId: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblCarType: UILabel!
    @IBOutlet weak var viewMain: UIView!
    
    
}
class HistoryCollectionViewCell: UICollectionViewCell , UITableViewDelegate , UITableViewDataSource{
    var delegate : HistoryCellAction!
    @IBOutlet weak var tableTrip: UITableView!
    
    
    @IBOutlet weak var lblNoRideFound: UILabel!
    @IBOutlet weak var ViewNoPastTrip: UIView!
    
    var arraydata = [[String : Any]] ()
    var pageCount:Int?


    override func awakeFromNib() {
        self.tableTrip.dataSource = self
        self.tableTrip.delegate = self
        
        
    }
    
    
    func getItemIndex(cellIndex:Int , ArrayData : [[String : Any]] , page : Int){
        pageCount = page
        print("SelectedInde\(cellIndex)")
          arraydata.removeAll()
          if ArrayData.count > 0{
            arraydata = ArrayData
            self.tableTrip.isHidden = false
            
            self.ViewNoPastTrip.isHidden = true
            self.tableTrip.reloadData()
            }
            else
            {
                
          //  self.tableTrip.isHidden = true
            self.ViewNoPastTrip.isHidden = false
                if page == 0
                {
                 self.lblNoRideFound.text = "You have no past trips"
                }
                else
                {
                  self.lblNoRideFound.text = "You have no upcoming trip"
                }
                self.tableTrip.reloadData()
            }
        
    }
    
    
    //MARK:- TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraydata.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if pageCount == 0{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cellBookingTable") as! HistoryTableViewCell
            let dict = self.arraydata[indexPath.row]
            
            //        let data = dict[""] as? String ?? ""
            //        print(localDateStringToString(date: data))
            if pageCount == 0{
                
            }
            cell.lblSourceLocationValue.text = dict["s_address"] as? String ?? ""
            cell.lblDestinationLocationValue.text = dict["d_address"] as? String ?? ""
            
            let strDate = dict["updated_at"] as? String ?? ""
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let dte = dateformat.date(from: strDate) {
                dateformat.dateFormat = "dd MMM yyyy 'at' hh:mm a"
                cell.lblDAte.text = dateformat.string(from: dte)

            }
            
            
            
            
            imgColor(img: cell.imgPin, colorHex: "6AC33E")
            cell.viewpickup.layer.masksToBounds = true
            cell.viewpickup.layer.cornerRadius = cell.viewpickup.frame.size.height / 2
            
            if (dict["status"] as? String ?? "") == "CANCELLED"
            {
                cell.imgCancelled.isHidden = false
            }
            else
            {
                cell.imgCancelled.isHidden = true
            }
            
            return cell
        }
        else{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "UpcomingHistoryTableViewCell") as! UpcomingHistoryTableViewCell
            let dict = self.arraydata[indexPath.row]
            
            
            //IMAGE
            let pictureUrl = dict["static_map"] as? String ?? ""
            let url = URL(string: pictureUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            
            do {
                let data = try NSData(contentsOf: url!, options: NSData.ReadingOptions())
                cell.imgPath.image = UIImage(data: data as Data)
            } catch {
                cell.imgPath.image = UIImage(named: "rd-map")
            }
            
            

//            cell.lblDate.text = dict["updated_at"] as? String ?? ""
            
            let strDate = dict["schedule_at"] as? String ?? ""
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let dte = dateformat.date(from: strDate) {
                dateformat.dateFormat = "dd MMM yyyy 'at' hh:mm a"
                cell.lblDate.text = dateformat.string(from: dte)

            }

            
            
            cell.lblBookingId.text = "Booking Id : \(dict["booking_id"] as? String ?? "")"
            
            
            let dicService = dict["service_type"] as? NSDictionary
            cell.lblCarType.text = dicService?["name"] as? String ?? ""
            let carUrl = dicService?["image"] as? String ?? ""
            cell.imgCar.setImage(with: "\(baseUrl)/\(carUrl)", placeHolder: UIImage(named:"CarplaceHolder"))

            //SET BUTTON
            cell.btnCancel.backgroundColor = .clear
            cell.btnCancel.layer.cornerRadius = 5
            cell.btnCancel.layer.borderWidth = 1
            cell.btnCancel.layer.borderColor = UIColor.red.cgColor
            cell.btnCancel.tag = indexPath.row
            cell.btnCancel.addTarget(self,action: #selector(btnCancelClicked), for: .touchUpInside)
            setViewShadow(myView: cell.viewMain)
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    @objc func btnCancelClicked(sender: UIButton) {
        
//        let alert = UIAlertController(title: Constants.string.cancelRequest.localize(), message: Constants.string.cancelRequestDescription.localize(), preferredStyle: UIAlertController.Style.alert)
//
//        alert.addAction(UIAlertAction(title: Constants.string.no.localize(), style: UIAlertAction.Style.default, handler: { _ in
//            //Cancel Action
//        }))
//        alert.addAction(UIAlertAction(title: Constants.string.yes.localize(), style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in
//            //Sign out action
//
//
//
//        }))
//        self.present(alert, animated: true, completion: nil)
//
        let dict = self.arraydata[sender.tag]
        delegate.BookingCancel(strCancelID: dict["id"] as! Int)
        
        
    }
    
     func setViewShadow(myView : UIView) {
           //SER CONFIRM REQUEST
           myView.layer.shadowPath =
               UIBezierPath(roundedRect: myView.bounds,
                            cornerRadius: myView.layer.cornerRadius).cgPath
           myView.layer.shadowColor = UIColor.black.cgColor
           myView.layer.shadowOpacity = 0.3
           myView.layer.shadowOffset = CGSize(width: 0, height: 5)
           myView.layer.shadowRadius = 5
           myView.layer.masksToBounds = false
           myView.layer.cornerRadius = 10
       }
       
    //MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if pageCount == 0{
            return 170
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.arraydata[indexPath.row]
        if (dict["status"] as? String ?? "") != "CANCELLED"
        {
            delegate.getRowIndexClicked(indexClicked: indexPath.row, dictClicked : self.arraydata[indexPath.row])
            
        }
        
    }
    
}
