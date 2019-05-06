//
//  AuthViewController.swift
//  notez
//
//  Created by Nabyl Bennouri on 5/5/19.
//  Copyright © 2019 Three14. All rights reserved.
//

import UIKit
import Firebase
import NotificationBannerSwift
import SVProgressHUD

class AuthViewController: UIViewController, UITextFieldDelegate {
    
    var passedTitle: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = passedTitle
        authButton.titleLabel?.text = passedTitle
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    @IBAction func onPresAuthButton(_ sender: Any) {
        SVProgressHUD.show()
        if (passedTitle == "Login") {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if (error != nil) {
                    let banner = NotificationBanner(title: "Error", subtitle: error!.localizedDescription as? String, style: .danger)
                    banner.show()
                    print(error!.localizedDescription)
                    SVProgressHUD.dismiss()
                }
                else {
                    print(user!.user)
                    self.performSegue(withIdentifier: "loginUser", sender: self)
                }
            }
        } else if (passedTitle == "Register") {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if (error != nil) {
                    let banner = NotificationBanner(title: "Error", subtitle: error!.localizedDescription as? String, style: .danger)
                    banner.show()
                    print(error!.localizedDescription)
                    SVProgressHUD.dismiss()
                }
                else {
                    print(user!.user)
                    self.performSegue(withIdentifier: "loginUser", sender: self)
                }
            }
        }
    }
    
    @IBAction func onBackPress(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
