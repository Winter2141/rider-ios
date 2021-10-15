//
//  WalkthrouViewController.swift
//  TranxitUser
//
//  Created by khatri Jigar on 28/11/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class WalkthrouViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Button Event -
    @IBAction func btnSkip(_ sender:Any){
//        UserDefaults.standard.set(true, forKey: "setInfo")
//        UserDefaults.standard.synchronize()
        let main = UIStoryboard(name: "Main", bundle: Bundle.main)
        let user = UIStoryboard(name: "User", bundle: Bundle.main)
        
        if retrieveUserData() == true{
            let vc = main.instantiateViewController(withIdentifier: Storyboard.Ids.homeView)
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.isNavigationBarHidden = true
            self.navigationController?.pushViewController(navigationController, animated: true)
        }
        else
        {
            let vc = user.instantiateViewController(withIdentifier: Storyboard.Ids.EmailViewController)
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.isNavigationBarHidden = true
            self.navigationController?.pushViewController(navigationController, animated: true)
        }
        
    }
}



//MARK: - Collection View -
extension WalkthrouViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        //sET IMAGE
        let img_Icon : UIImageView = cell.viewWithTag(100) as! UIImageView
        img_Icon.image = UIImage(named: "\(indexPath.row + 1)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      }
}


