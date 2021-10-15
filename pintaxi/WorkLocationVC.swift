//
//  WorkLocationVC.swift
//  TranxitUser
//
//  Created by 99appdev on 26/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GooglePlaces
protocol clickedLocation {
    func locationData(address : String , lat : String , lon : String , homeOrWork : String)
}
class WorkLocationVC: UIViewController {
  var delegate : clickedLocation!
    @IBOutlet weak var tblLocation: UITableView!
    @IBOutlet weak var lblHomeAddressText: UILabel!
    
    @IBOutlet weak var txtLocation: UITextField!
    var strHomeOrWork : String!
    var latSelect : String!
    var lonSelect : String!
    
    // Mark:- Local Variables
    
    private var googlePlacesHelper : GooglePlacesHelper?
    private var locationSerivce : LocationService?
    
    typealias Address = (source : Bind<LocationDetail>?,destination : LocationDetail?)
    
    private var completion : ((Address)->Void)? // On dismiss send address
    
    private var address : Address? // Current Address
    {
        didSet{
            if address?.source != nil {
                self.txtLocation.text = self.address?.source?.value?.address
            }
           
        }
    }
    private var datasource = [GMSAutocompletePrediction]() {  // Predictions List
        didSet {
            DispatchQueue.main.async {
                print("Reloaded")
                self.tblLocation.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        latSelect = ""
        lonSelect = ""
        if strHomeOrWork == "Home"
        {
            self.lblHomeAddressText.text = "Home Address"
        }
        else
        {
         self.lblHomeAddressText.text = "Work Address"
        }
        self.initialLoads()

        // Do any additional setup after loading the view.
    }
    
    private func initialLoads() {
       
        self.googlePlacesHelper = GooglePlacesHelper()
        self.tblLocation.isHidden = true
       
        self.tblLocation.delegate = self
        self.tblLocation.dataSource = self
        self.txtLocation.delegate = self
       
        self.tblLocation.register(UINib(nibName: XIB.Names.LocationTableViewCell, bundle: nil), forCellReuseIdentifier:XIB.Names.LocationTableViewCell)
        self.tblLocation.register(UINib(nibName: XIB.Names.LocationHeaderTableViewCell, bundle: nil), forCellReuseIdentifier:XIB.Names.LocationHeaderTableViewCell)
        self.txtLocation.isEnabled = ![RideStatus.accepted, .arrived, .pickedup, .started].contains(riderStatus)
    }
    
    @IBAction func btnCross(_ sender: Any) {
        self.txtLocation.text = ""
    }
    func setValues(address : Address, completion :@escaping (Address)->Void){
        //self.endEditingForce()
        self.address = address
        self.completion = completion
        self.txtLocation.becomeFirstResponder()
        
    }
    
    private func getPredications(from string : String?){
        
        self.googlePlacesHelper?.getAutoComplete(with: string, with: { (predictions) in
            self.datasource = predictions
        })
    }
    
    // Did Select at Indexpath
    
    private func select(at indexPath : IndexPath){
        
       
            
            self.autoFill(with: (datasource[indexPath.row].attributedFullText.string, LocationCoordinate(latitude: 0, longitude: 0)))
            
            if datasource.count > indexPath.row {
                let placeID = datasource[indexPath.row].placeID
                GMSPlacesClient.shared().lookUpPlaceID(placeID ) { (place, error) in
                    
                    if error != nil {
                        
                      //  self.make(toast: error!.localizedDescription)
                        
                    } else if let addressString = place?.formattedAddress, let coordinate = place?.coordinate{
                        // print("\nselected ---- ",coordinate)
                        DispatchQueue.main.async {
                           // self.autoFill(with: (addressString,coordinate))
                            self.txtLocation.text = addressString
                            self.latSelect = "\(coordinate.latitude)"
                            self.lonSelect = "\(coordinate.longitude)"
                            self.delegate.locationData(address: addressString, lat: self.latSelect, lon: self.lonSelect, homeOrWork: self.strHomeOrWork)
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                        
                    }
                }
            }
        
    }
    
    //  Auto Fill At
    
    private func autoFill(with location : LocationDetail?){ //, with array : [T]
       
            self.address?.source?.value = location//array  array [indexPath.row].location
            self.address?.source = self.address?.source // Temporary fix to call didSet
        
        
        if self.address?.source?.value != nil{
            self.completion?(self.address!)
            // print("\nselected ----->>",self.completion, self.address!.destination, self.address!.source?.value?.coordinate)
          
        }
    }
    
    //  Get Table View Cell
    
    private func getCell(for indexPath : IndexPath)->UITableViewCell{
        
        // Predications
        
            if let tableCell = self.tblLocation.dequeueReusableCell(withIdentifier: XIB.Names.LocationTableViewCell, for: indexPath) as? LocationTableViewCell, datasource.count>indexPath.row{
                tableCell.imageLocationPin.image = #imageLiteral(resourceName: "ic_location_pin")
                let placesClient = GMSPlacesClient.shared()
                placesClient.lookUpPlaceID(datasource[indexPath.row].placeID , callback: { (place, error) -> Void in
                    if let error = error {
                        print("lookup place id query error: \(error.localizedDescription)")
                        return
                    }
                    if let place = place {
                        let formatAddress = place.formattedAddress
                        let addressName = place.name
                        let formatAddressString = formatAddress!.replacingOccurrences(of: "\(addressName ?? ""), ", with: "", options: .literal, range: nil)
                        tableCell.lblLocationTitle.text = addressName
                        tableCell.lblLocationSubTitle.text = formatAddressString
                    }
                })
               
                return tableCell
            }
        
        return UITableViewCell()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}


//MARK:-  UITableViewDelegate

extension WorkLocationVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.5) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        self.select(at: indexPath)
    }
}

// MARK:- UITableViewDataSource

extension WorkLocationVC : UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1 //datasource.count == 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datasource.count > 0
        {
            self.tblLocation.isHidden = false
        }
        else
        {
          self.tblLocation.isHidden = true
        }
        return  datasource.count // && datasource.count==0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return self.getCell(for: indexPath)
    }
}

// MARK:- UITextFieldDelegate

extension WorkLocationVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.datasource = []
        self.getPredications(from: textField.text)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.datasource = []
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let text = textField.text, !text.isEmpty, range.location>0 || range.length>1 else {
            self.datasource = []
            return true
        }
        let searchText = text+string
        
        //        guard searchText.count else {
        //            return false
        //        }
        
        self.getPredications(from: searchText)
        
        print(textField.text ?? "", "  ", string, "   ", range.location, "  ", range.length)
        
        return true
    }
}

// MARK:- PostViewProtocol

extension WorkLocationVC : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
        DispatchQueue.main.async {
            if let viewController = UIApplication.topViewController() {
                showAlert(message: message, okHandler: nil, fromView: viewController)
            }
        }
    }
    
    func getLocationService(api: Base, data: LocationService?) {
        
        storeFavouriteLocations(from: data)
    }
    
    func success(api: Base, message: String?) {
        
        if api == .locationServicePostDelete {
            self.presenter?.get(api: .locationService, parameters: nil)
        }
    }
}
