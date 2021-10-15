//
//  Router.swift
//  User
//
//  Created by imac on 12/19/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation
import UIKit


class Router {
    
    static let main = UIStoryboard(name: "Main", bundle: Bundle.main)
    static let user = UIStoryboard(name: "User", bundle: Bundle.main)
    
    class func setWireFrame()->(UIViewController){
        
        let presenter : PostPresenterInputProtocol&PostPresenterOutputProtocol = Presenter()
        let interactor : PostInteractorInputProtocol&PostInteractorOutputProtocol = Interactor()
        let webService : PostWebServiceProtocol = Webservice()
        if let view : (PostViewProtocol & UIViewController) = user.instantiateViewController(withIdentifier: Storyboard.Ids.EmailViewController) as? EmailViewController {
          
            presenter.controller = view
            view.presenter = presenter
            presenterObject = view.presenter
            
        }
        
        webService.interactor = interactor
        interactor.webService = webService
        interactor.presenter = presenter
        presenter.interactor = interactor
        
       
        if retrieveUserData() == true{
            let vc = main.instantiateViewController(withIdentifier: Storyboard.Ids.homeView)
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.isNavigationBarHidden = true
            return navigationController
        }
        else
        {
            let vc = user.instantiateViewController(withIdentifier: Storyboard.Ids.EmailViewController)
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.isNavigationBarHidden = true
            return navigationController
        }
    }
    
}
