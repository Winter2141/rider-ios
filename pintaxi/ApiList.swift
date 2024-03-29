//
//  ApiList.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation

//Http Method Types

enum HttpType : String{
    
    case GET = "GET"
    case POST = "POST"
    case PATCH = "PATCH"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

// Status Code

enum StatusCode : Int {
    
    case notreachable = 0
    case success = 200
    case multipleResponse = 300
    case unAuthorized = 401
    case notFound = 404
    case ServerError = 500
}

enum Base : String{
    
    case zone = "/api/user/getvalidzone"
     case promocodes = "/api/user/promocodes"
     case addPromocode = "/api/user/promocode/add"
     case addCard = "///api/user/card"
     case servicesList = "/api/user/services"
     case estimateFare = "/api/user/estimated/fare?"
     case sendRequest = "/api/user/send/request"
     case pastHistory = "/api/user/trip/details?"
     case upcomingHistory = "/api/user/upcoming/trip/details?"
    
    case chatGet = "/api/user/firebase/getChat"
    case chatSend = "/api/user/firebase/getChatRider"

    case signUp = "/api/user/signup"
    case login = "/oauth/token"
    case userReview = "/api/user/review"
    case googleLogin = "/api/user/auth/google"
    case facebookLogin = "/api/user/auth/facebook"
    case getProfile = "/api/user/details"
    case updateProfile = "/api/user/update/profile"
    case resetPassword = "/api/user/reset/password"
    case changePassword = "/api/user/change/password"
    case forgotPassword = "/api/user/forgot/password"
    case googleMaps = "https://maps.googleapis.com/maps/api/geocode/json"
   
    case getProviders = "/api/user/show/providers"
   
    case cancelRequest = "/api/user/cancel/request"
    case checkRequest = "/api/user/request/check"
    case updateRequest = "/api/user/update/request"
    case updateAddress = "/api/user/createDefaultLocation"
  //  case pastRides = "/api/user/trips"
  //  case upcomingRides = "/api/user/upcoming/trips"
    case payNow = "/api/user/payment"
    case rateProvider = "/api/user/rate/provider"
    case historyList = "/api/user/trips"
    case upcomingList = "/api/user/upcoming/trips"
    case locationService = "/api/user/location"
    case locationServicePostDelete = "//api/user/location"
    //case addPromocode = "/api/user/promocode/add"
    case walletPassbook = "/api/user/wallet/passbook"
    case couponPassbook = "/api/user/promo/passbook"
    case logout = "/api/user/logout"
    case pastTripDetail = "/api/user/trip/details"
    case upcomingTripDetail = "/api/user/upcoming/trip/details"
    case getCards = "/api/user/card"
    case postCards = "/api/user/card11"
    case deleteCard = "/api/user/card/destory"
    case userVerify = "/api/user/verify"
    case addMoney = "/api/user/add/money"
    case chatPush = "/api/user/chat"
   // case promocodes = "/api/user/promocodes_list"
    case updateLanguage = "/api/user/update/language"
    case versionCheck = "/api/user/checkversion"
    case help = "/api/user/help"
    case settings = "/api/user/settings"
    case cancelReason = "/api/user/reasons"
    case phoneNubVerify = "/api/user/verify-credentials"
    case postDispute = "/api/user/dispute"
    case getDisputeList = "/api/user/dispute-list"
    case lostItem = "/api/user/drop-item"
    case extendTrip = "/api/user/extend/trip"
    case notificationManager = "/api/user/notification"
    
    case getbraintreenonce = "/api/user/braintree/token"
    
    case payUMoneySuccessResponse = "/user/api/payment/response"
    
    case getAdmobSetting = "/api/user/setting/ad_show"
    case getPersonAdmob = "/api/user/setting/personal_ad"
    
    init(fromRawValue: String){
        self = Base(rawValue: fromRawValue) ?? .signUp
    }
    
    static func valueFor(Key : String?)->Base{
        
        guard let key = Key else {
            return Base.signUp
        }
        
        if let base = Base(rawValue: key) {
            return base
        }
        
        return Base.signUp
        
    }
}
