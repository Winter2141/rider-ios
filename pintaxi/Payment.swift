//
//  Payment.swift
//  User
//
//  Created by CSS on 01/06/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct Payment : JSONSerializable {
    
    let id : Int?
    let request_id : String?
    let promocode_id : String?
    let payment_id : String?
    let payment_mode : String?
    let fixed : String?
    let distance : String?
    let commision : String?
    let discount : String?
    let tax : String?
    let wallet : String?
    let surge : String?
    let total : String?
//    let payable : Float?
//    let provider_commission : Float?
//    let provider_pay : Float?
//    let minute : Float?
//    let hour : Float?
//    let tips : Float?
//    let waiting_amount : Float?
//    let toll_charge : Float?
//    let round_of : Float?
//    let waiting_min_charge : Float?
}


