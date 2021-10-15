//
//  LoaderView.swift
//  User
//
//  Created by CSS on 17/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import PopupDialog
import ImageIO

class LoaderView: UIView {
    
    @IBOutlet private weak var buttonCancelRequest : UIButton!
    @IBOutlet private weak var labelFindingDriver : UILabel!
    @IBOutlet private weak var viewLoader : UIView!
    @IBOutlet private weak var btnCancel : UIButton!

  //  private var lottieView : LottieView!
    
    var onCancel : (()->Void)?
    
    // Enable Cancel Button If only request Id available
//    var isCancelButtonEnabled = false {
//        didSet {
//            UIView.animate(withDuration: 0.2) {
//                Common.setFont(to: self.labelFindingDriver, isTitle: !self.isCancelButtonEnabled)
//            }
////            self.buttonCancelRequest.isHidden = !self.isCancelButtonEnabled
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
        self.setDesign()
    }
    
}




extension LoaderView {
    
    private func initialLoads() {
        btnCancel.layer.masksToBounds = true
        btnCancel.layer.cornerRadius = 10.0
        
        //self.gifImageWithName(name: "location_wave")
        guard let confettiImageView = UIImageView.fromGif(frame:CGRect(x: (self.frame.width / 2)-80, y: (self.frame.height / 2)-50, width:200.0, height:200.0), resourceName: "search_location") else { return }
        viewLoader.addSubview(confettiImageView)
        confettiImageView.startAnimating()
//        self.buttonCancelRequest.isHidden = true // Hide Cancel Button Initially
       
//        self.buttonCancelRequest.setTitle("Cancel Request", for: .normal)
//        self.labelFindingDriver.text = "Finding Driver..."
        //Constants.string.findingDriver.localize()
//        self.buttonCancelRequest.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        
//        lottieView = LottieHelper().addLottie(file: "search", with: CGRect(origin: .zero, size: CGSize(width: self.viewLoader.frame.width/2, height: self.viewLoader.frame.width/2)))
//        lottieView.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
//        lottieView.backgroundColor = .clear
//        lottieView.loopAnimation = true
//        lottieView.autoReverseAnimation = true
//        self.viewLoader.addSubview(lottieView)
//        self.lottieView.centerXAnchor.constraint(equalTo: self.viewLoader.centerXAnchor).isActive = true
//        self.lottieView.centerYAnchor.constraint(equalTo: self.viewLoader.centerYAnchor).isActive = true
//        lottieView.play()
    }
    
    // MARK:- Set Design
    
    private func setDesign() {
        
        Common.setFont(to: labelFindingDriver)
//        Common.setFont(to: buttonCancelRequest, isTitle: true)
    }
    
    
    func endLoader(on completion : @escaping (()->Void)){
        
        UIView.animate(withDuration: 0.3, animations: {
          //  self.lottieView.transform = CGAffineTransform(scaleX: 10, y: 10)
          //  self.lottieView.alpha = 0
        }) { (_) in
            completion()
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "ChacelRequesrt"), object: nil)

            self.removeFromSuperview()
        }
    }
    
    @IBAction private func cancelButtonClick(){
        self.onCancel?()
    }
}

extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
     
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
}
