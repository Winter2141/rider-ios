//
//  Identifiers.swift
//  User
//
//  Created by imac on 12/19/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation

// MARK:- Storyboard Id
struct Storyboard {
    
    static let Ids = Storyboard()
    let Walkthrou = "WalkthrouViewController"

    let LaunchViewController = "LaunchViewController"
    let homeView = "HomeViewController"
     let LaunchNavigationController = "LaunchNavigationController"
      let SignUPViewController = "SignUPViewController"
    let UpdateNameVC = "UpdateNameVC"
    let UpdateEmailVC = "UpdateEmailVC"
     let WorkLocationVC = "WorkLocationVC"
    let UpdateMobileVC = "UpdateMobileVC"
     let UpdateProfileVC = "UpdateProfileVC"
    let ChangePasswordVC = "ChangePasswordVC"
    let EmailViewController = "EmailViewController"
    let PasswordViewController = "PasswordViewController"
    let ForgotPasswordViewController = "ForgotPasswordViewController"
    let SocialLoginViewController = "SocialLoginViewController"
     let ForgotPasswordResetVC = "ForgotPasswordResetVC"
    let ReviewVC = "ReviewVC"
   
    let WalkThroughPreviewController = "WalkThroughPreviewController"
    let DrawerController = "DrawerController"
    let ProfileViewController = "ProfileViewController"
    let LocationSelectionViewController = "LocationSelectionViewController"
    let PaymentViewController = "PaymentViewController"
    let YourTripsPassbookViewController = "YourTripsPassbookViewController"
    let CouponViewController = "CouponViewController"
    let WalletViewController = "WalletViewController"
    let HelpViewController = "HelpViewController"
    let SettingTableViewController = "SettingTableViewController"
    let ChangeResetPasswordController = "ChangeResetPasswordController"
    let YourTripsDetailViewController = "YourTripsDetailViewController"
    let OfflineBookingViewController = "OfflineBookingViewController"
    let ChatVC = "ChatVC"
    let AddCardViewController = "AddCardViewController"
    let SideBarTableViewController = "SideBarTableViewController"
    let PaymentsViewController = "PaymentsViewController"
    let ReferalController = "ReferalController"
    let NotificationController = "NotificationsViewController"
    let OngoingViewController = "OngoingViewController"

    
}

//MARK:- XIB Cell Names
struct XIB {
    
    static let Names = XIB()
    let WalkThroughView = "WalkThroughView"
    let LocationTableViewCell = "LocationTableViewCell"
    let LocationHeaderTableViewCell = "LocationHeaderTableViewCell"
    let ServiceSelectionCollectionViewCell = "ServiceSelectionCollectionViewCell"
    let LocationSelectionView = "LocationSelectionView"
    let ServiceSelectionView = "ServiceSelectionView"
    let RequestSelectionView = "RequestSelectionView"
    let LoaderView = "LoaderView"
    let RideStatusView = "RideStatusView"
    let InvoiceView = "InvoiceView"
    let RatingView = "RatingView"
    let YourTripCell = "YourTripCell"
    let PassbookTableViewCell = "PassbookTableViewCell"
    let RateView = "RateView"
    let RideNowView = "RideNowView"
    let status = "StatusTypeView"
    let CancelListTableViewCell = "CancelListTableViewCell"
    let ReasonView = "ReasonView"
    let CouponCollectionViewCell = "CouponCollectionViewCell"
    let CouponView = "CouponView"
    let PassbookWalletTransaction = "PassbookWalletTransaction"
    let disputeCell = "DisputeCell"
    let DisputeLostItemView = "DisputeLostItemView"
    let DisputeSenderCell = "DisputeSenderCell"
    let DisputeReceiverCell = "DisputeReceiverCell"
    let DisputeStatusView = "DisputeStatusView"
    let NotificationTableViewCell = "NotificationTableViewCell"
    let QRCodeView = "QRCodeView"
    let StatusTypeView = "StatusTypeView"
    
}

//MARK:- Notification
extension Notification.Name {
    
   public static let providers = Notification.Name("providers")
    public static let index = Notification.Name("index")
}



