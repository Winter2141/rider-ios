//
//  PinInfoView.swift
//  PooperPickerUpperKids
//
//  Created by Apple on 22/11/18.
//  Copyright © 2018 v. All rights reserved.
//

import UIKit

class PinInfoView: UIView {

    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!

   
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "PinInfoView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }

}
