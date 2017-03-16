//
//  ViewController.swift
//  ChatBot
//
//  Created by Victoria Zhou on 2/22/17.
//  Copyright © 2017 Victoria Zhou. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    func showAlert() {
        let alertController = UIAlertController(title: "Error", message: "An error has occured :/", preferredStyle: .alert)
        // create a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        
        present(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onSignUpButton(_ sender: Any) {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) -> Void in
            if let error = error {
                self.showAlert()
                print(error.localizedDescription)
                if (error._code == 202) {
                    print("User name is taken")
                }
            } else {
                print("User Registered successfully")
                print("Current user: " + PFUser.current().debugDescription)
                // manually segue to logged in view
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }

    @IBAction func onLoginButton(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) -> Void in
            if let error = error {
                self.showAlert()
                print("User login failed.")
                print(error.localizedDescription)
            } else {
                if user != nil {
                    print("User logged in successfully")
                    print("Current user: " + PFUser.current().debugDescription)
                    // display view controller that needs to shown after successful login
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
        }
    }

}

