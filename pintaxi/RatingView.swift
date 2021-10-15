    //
    //  RatingView.swift
    //  User
    //
    //  Created by CSS on 24/05/18.
    //  Copyright © 2018 Appoets. All rights reserved.
    //
    
    import UIKit
    import FloatRatingView
    
    class RatingView: UIView {
        
        // Mark :- IBOutlets
        
        @IBOutlet private weak var labelRating:UILabel!
        @IBOutlet private weak var lblTitle:UILabel!

        @IBOutlet private weak var imageViewProvider : UIImageView!
        @IBOutlet private weak var viewRating : FloatRatingView!
        @IBOutlet private weak var textViewComments : UITextView!
        @IBOutlet private weak var submitButton : UIButton!

        var ratingCount : String = "5"
        var onclickRating : ((_ rating : Int,_ comments : String)->Void)?
        
        override func awakeFromNib() {
            super.awakeFromNib()
            self.initialLoads()
        }
        
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            self.imageViewProvider.makeRoundedCorner()
        }
        
    }
    
    // Mark :- Local Methods
    extension RatingView : FloatRatingViewDelegate{

        func initialLoads() {
            
            self.textViewComments.delegate = self
            textViewDidEndEditing(textViewComments)
            self.localize()
            self.viewRating.delegate = self
            self.viewRating.minRating = 1
            self.viewRating.maxRating = 5
//            self.viewRating.floatRatings = true
//            self.viewRating.halfRatings = true
            self.viewRating.rating = 1
            self.viewRating.emptyImage = #imageLiteral(resourceName: "StarEmpty")
            self.viewRating.fullImage = #imageLiteral(resourceName: "star-filled")
            self.setDesign()
        }
        
        //  Set Designs
        private func setDesign() {
            
            Common.setFont(to: labelRating, isTitle: true)
            Common.setFont(to: textViewComments)
        }
        
        // Localize
        private func localize() {
            
            self.labelRating.text = Constants.string.rateyourtrip.localize()
        }
        
        @IBAction private func buttonActionRating() {
            self.onclickRating?(Int(ratingCount) ?? 1, textViewComments.text)
        }
        
        func set(request : Request) {

            self.labelRating.text = "Rate your trip with \(String.removeNil(request.provider?.first_name)) \(String.removeNil(request.provider?.last_name))"
            self.lblTitle.text = "Your feedback will help\nimprove driving experience"
            Cache.image(forUrl:Common.getImageUrl(for: "\(baseUrl)\(request.provider?.avatar ?? "")")) { (image) in
                if image != nil {
                    DispatchQueue.main.async {
                        self.imageViewProvider.image = image
                    }
                }
            }
        }
        
        

        func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
            ratingCount = "\(rating)"
        }
    }
    
    
    //MARK:- UITextViewDelegate
    extension RatingView : UITextViewDelegate {
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == Constants.string.writeYourComments.localize() {
                textView.text = .Empty
                textView.textColor = .black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            
            if textView.text == .Empty {
                textView.text = Constants.string.writeYourComments.localize()
                textView.textColor = .lightGray
            }
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    }
