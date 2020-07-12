//
//  ViewController.swift
//  ContactTracing
//
//  Created by Sai swaroop Pamidi on 7/3/20.
//  Copyright © 2020 Sai swaroop Pamidi. All rights reserved.
//

import UIKit
import FirebaseUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        //get default auth UI object
        let authUI = FUIAuth.defaultAuthUI()
        guard authUI != nil else {
            //log error
            return
        }
        //setting delegate
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth()]
        
        //get reference to auth UI controller
        let authViewController = authUI!.authViewController()
        
        //display
        present(authViewController,animated: true,completion: nil)
        
    }
    
}
extension ViewController : FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        //check error
        if error != nil {
            //log error
        }
        // authDataResult?.user.uid
        performSegue(withIdentifier: "goHome", sender: self)
    }
    
}

