//
//  ErrorMessages.swift
//  User
//
//  Created by CSS on 11/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct ErrorMessage {
    
    static let list = ErrorMessage()
    
    let serverError = "Server Could not be reached. \n Try Again"
    let notReachable = "The Internet connection appears to be offline."
    let enterEmail = "Enter Email Id"
    let enterValidEmail = "Enter Valid Email Id"
    let enterPassword = "Enter Password"
     let emptySourceLocation = "Please enter both picku and drop location"
     let emptyDestinationLocation = "Destination location should not be empty"
    let enterNewPassword = "Enter New Password"
    let enterName = "Enter Name"
    let enterFirstName = "Enter FirstName"
    let enterLastName = "Enter LastName"
    let enterMobileNumber = "Enter Mobile Number"
    let enterCountry = "Enter Country"
    let enterTimezone = "Enter TimeZone"
    let enterConfirmPassword = "Enter Confirm Password"
    let passwordDonotMatch = "Password and Confirm password do not match"
}
struct SuccessMessage {
    
    static let list = SuccessMessage()
    let ridePosted = "Your ride has been posted successfully."
    let rideCancelled = "Your ride has been cancelled successfully."
    let seatBooked = "Booking has been successfully done."
    let seatAccepted = "Seat has been successfully accepted."
    let requestSent = "Booking request has been successfully sent to car owner."
    let passwordChanged = "Password has been changed successfully."
    let profileUpdated = "Profile has been updated successfully."
     let AddressUpdated = "Address has been updated successfully."
    let noDataFound = "No Data Found."
    let comingSoon = "Coming Soon."
    let sureToLogout = "Are you sure to Logout?"
    
}
