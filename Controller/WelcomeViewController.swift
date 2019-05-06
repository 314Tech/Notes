//
//  WelcomeViewController.swift
//  notez
//
//  Created by Nabyl Bennouri on 5/5/19.
//  Copyright © 2019 Three14. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class WelcomeViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Login if already logged in
        if Auth.auth().currentUser != nil {
            SVProgressHUD.show()
            self.performSegue(withIdentifier: "loginDirectly", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier != "loginDirectly") {
            let nextSegue = segue.destination as! AuthViewController
            nextSegue.passedTitle = ( segue.identifier! == "login") ? "Login" : "Register"
        }
    }
    @IBAction func onAuthButtonPress(_ sender: Any) {
    }
}
