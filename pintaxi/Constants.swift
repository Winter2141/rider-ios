//
//  Constants.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps

typealias ViewController = (UIViewController & PostViewProtocol)
var presenterObject :PostPresenterInputProtocol?

var polyLinePath = GMSPolyline()
var gmsPath = GMSPath()
var isRerouteEnable:Bool = false

// MARK: - Constant Strings

struct Constants {
    static let string = Constants()
    let writeSomething = "Write Something"
    let noChatHistory = "No Chat History Found"
    let yes = "Yes"
    let no = "No"
    let Done = "Done"
    let Back = "Back"
    let delete = "Delete"
    let noDevice = "no device"
    let manual = "manual"
    let OK = "OK"
    let Cancel = "Cancel"
    let NA = "NA"
    let MobileNumber = "Mobile Number"
    let next = "Next"
    let selectSource = "Select Source"
    let ConfirmPassword = "ConfirmPassword"
    let camera = "Camera"
    let photoLibrary = "Photo Library"
    let walkthrough = "Walkthrough"
    let signIn = "SIGN IN"
    let signUp = "SIGNUP"
    let orConnectWithSocial = "Or connect with social"
    let changePassword = "Change Password"
    let resetPassword = "Reset Password"
    let enterOtp = "Enter OTP"
    let otpIncorrect = "OTP incorrect"
    let enterCurrentPassword = "Current Password"
    let walkthroughWelcome = "Services to transport you where you need to go. A lot can happen, on our ride."
    let walkthroughDrive = "Take a ride whenever and wherever you want. Plan and Schedule for us to pick you up."
    let walkthroughEarn = "We have the most friendly drivers who will go the extra mile for you."
    let welcome = "Welcome"
    let schedule = "Schedule"
    let drivers = "Drivers"
    let country = "Country"
    let timeZone = "Time Zone"
    let referalCode = "Referral Code (Optional)"
    let business = "Business"
    let emailPlaceHolder = "Email Address"
    let email = "Email"
    let iNeedTocreateAnAccount = "I need to create an account"
    let whatsYourEmailAddress = "What's your Email Address?"
    let welcomeBackPassword = "Welcome back, sign in to continue"
    let enterPassword = "Enter Password"
    let enterNewpassword = "Enter New Password"
    let enterConfirmPassword = "Enter Confirm Password"
    let password = "Password"
    let newPassword = "New Password"
    let iForgotPassword = "I forgot my password"
    let enterYourMailIdForrecovery = "Enter your mail ID for recovery"
    let registerDetails = "Enter the details to register"
    let chooseAnAccount = "Choose an account"
    let facebook = "Facebook"
    let google = "Google"
    let payment = "Payment"
    let yourTrips = "Your Trips"
    let coupon = "Coupon"
    let wallet = "Wallet"
    let passbook = "Passbook"
    let settings = "Settings"
    let help = "Help"
    let share = "Share"
    let inviteReferral = "Invite Referral"
    let faqSupport = "FAQ Support"
    let termsAndConditions = "Terms and Conditions"
    let privacyPolicy = "Privacy Policy"
    let logout = "Logout"
    let profile = "Profile"
    let first = "First Name"
    let last = "Last Name"
    let phoneNumber = "Phone Number"
    let tripType = "Trip Trip"
    let personal = "Personal"
    let save = "save"
    let lookingToChangePassword = "Looking to change password?"
    let areYouSure = "Are you sure?"
    let areYouSureWantToLogout = "Are you sure want to logout?"
    let sure = "Sure"
    let source = "Source"
    let destination = "Destination"
    let home = "Home"
    let work = "Work"
    let addLocation = "Add Location"
    let selectService = "Select Service"
    let service = "Service"
    let more = "More"
    let change = "Change"
    let getPricing = "GET PRICING"
    let cancelRequest = "Cancel Request"
    let cancelRequestDescription = "Are you sure want to cancel the request?"
    let findingDriver = "Finding Driver..."
    let dueToHighDemandPriceMayVary = "Due to high demand price may vary"
    let estimatedFare = "Estimated Fare"
    let ETA = "ETA"
    let model = "Model"
    let useWalletAmount = "Use Wallet Amount"
    let scheduleRide = "schedule"
    let rideNow = "ride now"
    let scheduleARide = "Schedule your Ride"
    let select = "Select"
    let driverAccepted = "Driver accepted your request."
    let youAreOnRide = "You are on ride."
    let bookingId = "Booking ID"
    let distanceTravelled = "Distance Travelled"
    let timeTaken = "Time Taken"
    let baseFare = "Base Fare"
    let cash = "Cash"
    let paytm = "Paytm"
    let Payumoney = "PayUmoney"
    let braintree = "Braintree"
    let paynow = "Pay Now"
    let rateyourtrip = "Rate your trip with"
    let writeYourComments = "Additional comments..."
    let distanceFare = "Distance Fare"
    let tax = "Tax"
    let total = "Total"
    let submit = "Submit"
    let driverArrived = "Driver has arrived at your location."
    let peakInfo = "Due to peak hours, charges will be varied based on availability of provider."
    let call = "Call"
    let past = "Past"
    let upcoming = "Upcoming"
    let addCardPayments = "Add card for payments"
    let paymentMethods = "Payment Methods"
    let yourCards = "Your Cards"
    let walletHistory = "Wallet History"
    let couponHistory = "Coupon History"
    let enterCouponCode = "Enter Coupon Code"
    let addCouponCode = "Add Coupon Code"
    let resetPasswordDescription = "Note : Please enter the OTP send to your registered email address"
    let latitude = "latitude"
    let longitude = "longitude"
    let totalDistance = "Total Distance"
    let shareRide = "Share Ride"
    let wouldLikeToShare = "would like to share a ride with you at"
    let profileUpdated = "Profile updated successfully"
    let nameUpdated = "Name updated successfully"
    let emailUpdated = "Email updated successfully"
    let mobileUpdated = "Mobile updated successfully"
    let otp = "OTP"
    let at = "at"
    let favourites = "Favourites"
    let changeLanguage = "Change Language"
    let noFavouritesFound = "No favourite address available"
    let cannotMakeCallAtThisMoment = "Cannot make call at this moment"
    let offer = "Offer"
    let amount = "Amount"
    let creditedBy = "Credited By"
    let CouponCode = "Coupon Code"
    let OFF = "OFF"
    let couldnotOpenEmailAttheMoment = "Could not open Email at the moment."
    let couldNotReachTheHost = "Could not reach th web"
    let wouldyouLiketoMakeaSOSCall = "Would you like to make a SOS Call?"
    let mins = "mins"
    let invoice = "Invoice"
    let viewRecipt = "View Receipt"
    let payVia = "Pay via"
    let comments = "Comments"
    let pastTripDetails = "Past Trip Details"
    let upcomingTripDetails = "Upcoming Trip Details"
    let paymentMethod = "Payment Method"
    let cancelRide = "Cancel Ride"
    let noComments = "no Comments"
    let noPastTrips = "No Past Trips"
    let noUpcomingTrips = "No Upcoming Trips"
    let noWalletHistory = "No Wallet Details"
    let noCouponDetail = "No Coupon Details"
    let fare = "Fare"
    let fareType = "Fare Type"
    let capacity = "Capacity"
    let rateCard = "Rate Card"
    let distance = "Distance"
    let sendMyLocation = "Send my Location"
    let noInternet = "No Internet?"
    let bookNowOffline = "Book Now using SMS"
    let tapForCurrentLocation = "Tap the button below to send your current location by SMS."
    let standardChargesApply = "Standard charges may apply"
    let noThanks = "No thanks, I'll try later"
    let iNeedCab = "I need a cab @"
    let donotEditMessage = "(Please donot edit this SMS. Standard SMS charges of Rs.3 per SMS may apply)"
    let pleaseTryAgain = "Please try again"
    let ADDCOUPON = "ADD COUPON"
    let addAmount = "Add Money"
     let passwordresetMesage = "Password has been changed successfully."
    let ADDAMT = "ADD AMOUNT"
    let yourWalletAmnt = "Your wallet amount is"
    let Support = "Support"
    let helpQuotes = "Our team persons will contact you soon!"
    let areYouSureCard = "Are you sure want to delete this card?"
    let remove = "Remove"
    let discount = "Discount"
    let planChanged = "Plan Changed"
    let bookedAnotherCab = "Booked another cab"
    let driverDelayed = "Driver Delayed"
    let lostWallet = "Lost Wallet"
    let othersIfAny = "Others If Any"
    let reasonForCancellation = "Reason For Cancellation"
    let addCard = "Add Card to continue with wallet"
    let enterValidAmount = "Enter Valid Amount"
    let allPaymentMethodsBlocked = "All payment methods has been blocked"
    let selectCardToContinue = "select card to continue"
    let timeFare = "Time Fare"
    let tips = "Tips"
    let walletDeduction = "Wallet Deduction"
    let toPay = "To Pay"
    let addTips = "Add Tips"
    let proceed = "Proceed"
    let extimationFareNotAvailable = "Estimation fare not available"
    let viewCoupons = "View Coupons"
    let apply = "Apply"
    let validity = "Validity"
    let paid = "Paid"
    let noCoupons = "No Coupons"
    let english = "English"
    let arabic = "Arabic"
    let becomeADriver = "Become a Driver"
    let balance = "Balance"
    let noDriversFound = "No Drivers found,\n Sorry for the inconvenience"
    let newVersionAvailableMessage = "A new version of this App is available in the App Store"
    let changePasswordMsg = "Password changed and please login with new password"
    let MIN = "MIN"
    let HOUR = "HOUR"
    let DISTANCE = "DISTANCE"
    let DISTANCEMIN = "DISTANCEMIN"
    let DISTANCEHOUR = "DISTANCEHOUR"
    
    let WaitingTime = "Waiting Amount"
    let invideFriends = "Invite Friends"
    let referHeading = "Your Referral Code"
    let tollCharge = "Toll Charge"
    
    //Referral
    let referalMessage = "Hey check this app \(AppName)"
    let installMessage = "Install this app with referral code"
    
    let dispute = "Dispute"
    let lostItem = "Lost Items"
    let disputeStatus = "Dispute Status"
    let lostItemStatus = "Lost Item Status"
    let open = "open"
    let you = "You"
    let admin = "Admin"
    
    
    let disputeMsg = "Please choose dispute type"
    let enterComment = "Please enter your comments"
    let disputecreated = "Your Dispute already created"
    let locationChange = "Update Ride? \n If you update your destination your fare may change"
    let withoutDest = "Without destination?"
    let notifications = "Notification Manager"
    let destinationChange = "Want to change destination?"
    
    let scheduleReqMsg = "Schedule request created!"
    
    let rideCreated = "Ride Created Successfully"
    
    let confirmPayment = "Payment not confirmed from the driver."
    
    let warningMsg = "You are using both user and driver apps in same device. So app may not work properly"
    let Continue = "Continue"
    
    //PayTm
    let mid = "MID"
    let orderId = "ORDER_ID"
    let custId = "CUST_ID"
    let mobileNo = "MOBILE_NO"
    let emailId = "EMAIL"
    let channelId = "CHANNEL_ID"
    let website = "WEBSITE"
    let txnAmount = "TXN_AMOUNT"
    let industryType = "INDUSTRY_TYPE_ID"
    let checksumhash = "CHECKSUMHASH"
    let callbackUrl = "CALLBACK_URL"
    
    //PayUMoney
    let sid = "id"
    let spay = "pay"
    let swallet = "wallet"
    let stype = "type"
    let suid = "uid"
    let stxnid = "txnid"
    
    let  roundOff = "Round off"
    
    let readMore = "Show More"
    let readLess = "Show Less"
    
    let waitingAlertText = "**Waiting charge not applicable for this service type"
    
    let noNotifications = "No Notifications"
    
    //COLOUR
    static let BLACK_COLOUR = "#000000"

}


//ENUM TRIP TYPE

enum TripType : String, Codable {
    
    case Business
    case Personal
    
}

//Payment Type

enum  PaymentType : String, Codable {
    
    case CASH = "CASH"
    case CARD = "CARD"
    case PAYTM = "PAYTM"
    case PAYUMONEY = "PAYUMONEY"
    case BRAINTREE = "BRAINTREE"
    case NONE = "NONE"
    
    var image : UIImage? {
        var name = "ic_error"
        switch self {
        case .CARD:
            name = "visa"
        case .CASH:
            name = "money_icon"
        case .BRAINTREE:
            name = "Braintree-logo"
        case .PAYTM:
            name = "Paytm_logo"
        case .PAYUMONEY:
            name = "payumoney-logo"
        case .NONE :
            name = "ic_error"
        }
      return UIImage(named: name)
   }
}


// Date Formats

struct DateFormat {
    
    static let list = DateFormat()
    let yyyy_mm_dd_HH_MM_ss = "yyyy-MM-dd HH:mm:ss"
    let MMM_dd_yyyy_hh_mm_ss_a = "MMM dd, yyyy hh:mm:ss a" 
    let hhmmddMMMyyyy = "hh:mm a - dd:MM:yyyy"
    let ddMMyyyyhhmma = "dd-MM-yyyy hh:mma"
    let ddMMMyyyy = "dd MMM yyyy"
    let hh_mm_a = "hh : mm a"
    let dd_MM_yyyy = "dd/MM/yyyy"
}



// Devices

enum DeviceType : String, Codable {
    
    case ios = "ios"
    case android = "android"
    
}

//Dispute Status

enum DisputeStatus : String, Codable {
    
    case open
    case closed
    
}


//SET IMAGE COLOR
func imgColor (img : UIImageView , colorHex: String){
    let templateImage = img.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    img.image = templateImage
    img.tintColor = hexStringToUIColor(hex: colorHex)
}



func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    let aCString = cString.cString(using: String.Encoding.utf8)
    let length = strlen(aCString!)// returns a UInt
    if (length != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}



//Lanugage

enum Language : String, Codable, CaseIterable {
    case english = "en"
    case arabic = "ar"
    
    var code : String {
        switch self {
        case .english:
            return "en"
        case .arabic:
            return "ar"
        }
    }
    
    var title : String {
        switch self {
        case .english:
            return Constants.string.english
        case .arabic:
            return Constants.string.arabic
        }
    }
    
    static var count: Int{ return 2 }
}



// MARK:- Login Type

enum LoginType : String, Codable {
    
    case facebook
    case google
    case manual
    
}


// MARK:- Ride Status

enum RideStatus : String, Codable {
    
    case searching = "SEARCHING"
    case accepted = "ACCEPTED"
    case started = "STARTED"
    case arrived = "ARRIVED"
    case pickedup = "PICKEDUP"
    case dropped = "DROPPED"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
    case none
    
}

// MARK:- Service Calclulator

enum ServiceCalculator : String, Codable {
    case MIN
    case HOUR
    case DISTANCE
    case DISTANCEMIN
    case DISTANCEHOUR
    case NONE
}



enum Vibration : UInt {
    case weak = 1519
    case threeBooms = 1107
}



//MARK: - Manage function for value save -
extension NSDictionary {
    func getStringForID(key: String) -> String! {
        
        var strKeyValue : String = ""
        if self[key] != nil {
            if (self[key] as? Int) != nil {
                strKeyValue = String(self[key] as? Int ?? 0)
            } else if (self[key] as? String) != nil {
                strKeyValue = self[key] as? String ?? ""
            }else if (self[key] as? Double) != nil {
                strKeyValue = String(self[key] as? Double ?? 0)
            }else if (self[key] as? Float) != nil {
                strKeyValue = String(self[key] as? Float ?? 0)
            }else if (self[key] as? Bool) != nil {
                let bool_Get = self[key] as? Bool ?? false
                if bool_Get == true{
                    strKeyValue = "1"
                }else{
                    strKeyValue = "0"
                }
            }
        }
        return strKeyValue
    }
    
    func getArrayVarification(key: String) -> NSArray {
        
        var strKeyValue : NSArray = []
        if self[key] != nil {
            if (self[key] as? NSArray) != nil {
                strKeyValue = self[key] as? NSArray ?? []
            }
        }
        return strKeyValue
    }
}



extension UITextField{
    
    func addDoneToolbar(TintColor:UIColor = UIColor.black, selector:Selector? = nil, targate:Any? = nil)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.done))
        
        if let selctr = selector{
            done = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: targate, action: selctr)
        }
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        doneToolbar.tintColor = TintColor
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func done() {
        self.endEditing(true)
    }
}


func getCountryPhonceCode (_ country : String) -> String {
    
    var countryDictionary  = ["AF":"93",
                              "AL":"355",
                              "DZ":"213",
                              "AS":"1",
                              "AD":"376",
                              "AO":"244",
                              "AI":"1",
                              "AG":"1",
                              "AR":"54",
                              "AM":"374",
                              "AW":"297",
                              "AU":"61",
                              "AT":"43",
                              "AZ":"994",
                              "BS":"1",
                              "BH":"973",
                              "BD":"880",
                              "BB":"1",
                              "BY":"375",
                              "BE":"32",
                              "BZ":"501",
                              "BJ":"229",
                              "BM":"1",
                              "BT":"975",
                              "BA":"387",
                              "BW":"267",
                              "BR":"55",
                              "IO":"246",
                              "BG":"359",
                              "BF":"226",
                              "BI":"257",
                              "KH":"855",
                              "CM":"237",
                              "CA":"1",
                              "CV":"238",
                              "KY":"345",
                              "CF":"236",
                              "TD":"235",
                              "CL":"56",
                              "CN":"86",
                              "CX":"61",
                              "CO":"57",
                              "KM":"269",
                              "CG":"242",
                              "CK":"682",
                              "CR":"506",
                              "HR":"385",
                              "CU":"53",
                              "CY":"537",
                              "CZ":"420",
                              "DK":"45",
                              "DJ":"253",
                              "DM":"1",
                              "DO":"1",
                              "EC":"593",
                              "EG":"20",
                              "SV":"503",
                              "GQ":"240",
                              "ER":"291",
                              "EE":"372",
                              "ET":"251",
                              "FO":"298",
                              "FJ":"679",
                              "FI":"358",
                              "FR":"33",
                              "GF":"594",
                              "PF":"689",
                              "GA":"241",
                              "GM":"220",
                              "GE":"995",
                              "DE":"49",
                              "GH":"233",
                              "GI":"350",
                              "GR":"30",
                              "GL":"299",
                              "GD":"1",
                              "GP":"590",
                              "GU":"1",
                              "GT":"502",
                              "GN":"224",
                              "GW":"245",
                              "GY":"595",
                              "HT":"509",
                              "HN":"504",
                              "HU":"36",
                              "IS":"354",
                              "IN":"91",
                              "ID":"62",
                              "IQ":"964",
                              "IE":"353",
                              "IL":"972",
                              "IT":"39",
                              "JM":"1",
                              "JP":"81",
                              "JO":"962",
                              "KZ":"77",
                              "KE":"254",
                              "KI":"686",
                              "KW":"965",
                              "KG":"996",
                              "LV":"371",
                              "LB":"961",
                              "LS":"266",
                              "LR":"231",
                              "LI":"423",
                              "LT":"370",
                              "LU":"352",
                              "MG":"261",
                              "MW":"265",
                              "MY":"60",
                              "MV":"960",
                              "ML":"223",
                              "MT":"356",
                              "MH":"692",
                              "MQ":"596",
                              "MR":"222",
                              "MU":"230",
                              "YT":"262",
                              "MX":"52",
                              "MC":"377",
                              "MN":"976",
                              "ME":"382",
                              "MS":"1",
                              "MA":"212",
                              "MM":"95",
                              "NA":"264",
                              "NR":"674",
                              "NP":"977",
                              "NL":"31",
                              "AN":"599",
                              "NC":"687",
                              "NZ":"64",
                              "NI":"505",
                              "NE":"227",
                              "NG":"234",
                              "NU":"683",
                              "NF":"672",
                              "MP":"1",
                              "NO":"47",
                              "OM":"968",
                              "PK":"92",
                              "PW":"680",
                              "PA":"507",
                              "PG":"675",
                              "PY":"595",
                              "PE":"51",
                              "PH":"63",
                              "PL":"48",
                              "PT":"351",
                              "PR":"1",
                              "QA":"974",
                              "RO":"40",
                              "RW":"250",
                              "WS":"685",
                              "SM":"378",
                              "SA":"966",
                              "SN":"221",
                              "RS":"381",
                              "SC":"248",
                              "SL":"232",
                              "SG":"65",
                              "SK":"421",
                              "SI":"386",
                              "SB":"677",
                              "ZA":"27",
                              "GS":"500",
                              "ES":"34",
                              "LK":"94",
                              "SD":"249",
                              "SR":"597",
                              "SZ":"268",
                              "SE":"46",
                              "CH":"41",
                              "TJ":"992",
                              "TH":"66",
                              "TG":"228",
                              "TK":"690",
                              "TO":"676",
                              "TT":"1",
                              "TN":"216",
                              "TR":"90",
                              "TM":"993",
                              "TC":"1",
                              "TV":"688",
                              "UG":"256",
                              "UA":"380",
                              "AE":"971",
                              "GB":"44",
                              "US":"1",
                              "UY":"598",
                              "UZ":"998",
                              "VU":"678",
                              "WF":"681",
                              "YE":"967",
                              "ZM":"260",
                              "ZW":"263",
                              "BO":"591",
                              "BN":"673",
                              "CC":"61",
                              "CD":"243",
                              "CI":"225",
                              "FK":"500",
                              "GG":"44",
                              "VA":"379",
                              "HK":"852",
                              "IR":"98",
                              "IM":"44",
                              "JE":"44",
                              "KP":"850",
                              "KR":"82",
                              "LA":"856",
                              "LY":"218",
                              "MO":"853",
                              "MK":"389",
                              "FM":"691",
                              "MD":"373",
                              "MZ":"258",
                              "PS":"970",
                              "PN":"872",
                              "RE":"262",
                              "RU":"7",
                              "BL":"590",
                              "SH":"290",
                              "KN":"1",
                              "LC":"1",
                              "MF":"590",
                              "PM":"508",
                              "VC":"1",
                              "ST":"239",
                              "SO":"252",
                              "SJ":"47",
                              "SY":"963",
                              "TW":"886",
                              "TZ":"255",
                              "TL":"670",
                              "VE":"58",
                              "VN":"84",
                              "VG":"284",
                              "VI":"340"]
    if countryDictionary[country] != nil {
        return countryDictionary[country]!
    }
        
    else {
        return ""
    }
    
}

func showAlertMessage(titleStr:String, messageStr:String) {
       let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
       UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
   }
