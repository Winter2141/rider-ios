//
//  AppData.swift
//  User
//an
import UIKit

let AppName = "pinTaxi"
var deviceTokenString = Constants.string.noDevice
let stripePublishableKey = "pk_test_DbfzA8Pv1MDErUiHakK9XfLe"
let googleMapKey = "AIzaSyAzLQV6fkxY1F1r9AMMfLWF4uq4AQbj778"
let appSecretKey = "WifS1rMi3LvuorP1G2UdtKZairUNSH2iMqrKivPf"
let appClientId = 2
let passwordLengthMax = 10
let defaultMapLocation = LocationCoordinate(latitude: 31.037933, longitude: 31.381523)
let baseUrl = "https://taxi.developerz.net/"

var supportNumber = "+201000503064"
var supportEmail = "support@pintaxi.xyz"
var offlineNumber = "+201000503064"
let helpSubject = "\(AppName) Help"

let requestInterval : TimeInterval = 60
let requestCheckInterval : TimeInterval = 5
let driverBundleID = "com.pinkcar.providers"

// AppStore URL

enum AppStoreUrl : String {
    
    case user = "https://itunes.apple.com/us/app/pintaxi"
    case driver = "https://itunes.apple.com/us/app/pintaxi-driver"
    
}
