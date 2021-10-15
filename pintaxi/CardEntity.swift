//
//  CardEntity.swift
//  User
//
//  Created by CSS on 23/07/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct CardEntity : JSONSerializable {
    var id : Int?
    var user_id : String?
    var stripe_cust_id : String?
    var card_fingerprint : String?
    var last_four : String?
    var card_id : String?
    var brand : String?
    var is_default : String?
//    var _method : String?
//    var strCardID : String?
//    var amount : String?
//    var user_type: String?
//    var payment_mode: String?
}


struct AddMoneyEntity : JSONSerializable {
    var amount : String?
    var type : String?
    var payment_mode : String?
}

