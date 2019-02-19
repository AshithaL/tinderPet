//
//  ViewController.swift
//  tinderPet
//
//  Created by Ashitha L on 09/02/19.
//  Copyright © 2019 Ashitha L. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import AlamofireObjectMapper
import Poi
import Kingfisher

class ViewController: UIViewController {
    
    
   
@IBOutlet weak var userName: UITextField!
    
@IBOutlet weak var upassword: UITextField!
    
@IBOutlet weak var loginButton: UIButton!

    // enabling keyboard
override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
      
        }
    
    @objc func keyboardWillShow (notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide (notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn( _ textField: UITextField) -> Bool {
        if textField == userName {
            textField.resignFirstResponder()
            upassword.becomeFirstResponder()
        } else if textField == upassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
   @IBAction func loginButton(_ sender: Any) {
        let Params = [ "username" : userName.text, "password" : upassword.text ]
        let urlString = URL(string: "http://ec2-3-91-83-117.compute-1.amazonaws.com:3000/login")
    Alamofire.request(urlString!, method:.post, parameters: Params as Parameters , encoding: JSONEncoding.default, headers: nil).responseObject { (response: DataResponse<TokenResponse>) in
            
        if response.response?.statusCode == 200 {
                
          let loginrep = response.result.value
          let retrievedToken = loginrep?.eresponse?.data?.token!
          let _ : Bool = KeychainWrapper.standard.set(retrievedToken!, forKey: "retrievedToken")
                let _ : String? = KeychainWrapper.standard.string(forKey: "retrievedToken")
                self.performSegue(withIdentifier: "homepage", sender: self)
         } else if response.response?.statusCode == 404 {
                let alert = UIAlertController(title: "Invalid credentials", message: "Either Username or Password is incorrect", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                  self.present(alert,animated: true, completion: nil)

                } else if response.response?.statusCode == 400 {
                    let alert = UIAlertController( title: "Login", message: "Please enter the details to login", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                
            }
            else{
                print ("Something is Wrong...")
            }
        }
        
    }
    
}
