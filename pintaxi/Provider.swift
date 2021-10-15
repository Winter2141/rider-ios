//
//  Provider.swift
//  User
//
//  Created by CSS on 01/06/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
//
//struct Provider : JSONSerializable {
//
//    var id : Int?
//    var avatar : String?
//    var first_name : String?
//    var last_name : String?
//    var rating : String?
//    var mobile : String?
//    var service : ServiceDetails?
//
//}


struct Provider : JSONSerializable {
    
    var id : Int?
    var zone_id :String?
    var first_name :String?
    var last_name : String?
    var email : String?
    var mobile : String?
    var avatar : String?
    var device_id : String?
    var rating : String?
    var status : String?
    var fleet : String?
    var latitude :String?
    var longitude :String?
    var otp : String?
    var created_at : String?
    var login_by : String?
    var social_unique_id : String?
    var device_type : String?
    var device_token : String?
    var term_n : String?
    var logged_in : String?
    var service : ServiceDetails?
}


struct ServiceDetails : JSONSerializable {
    
    var id : Int?
    var service_model :String?
    var service_type_id :Int?
  
    
}
