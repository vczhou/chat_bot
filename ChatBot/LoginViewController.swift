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

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        let user = PFUser()
        //user.username = emailTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text
        user.username = "ex"
        
        
        user.signUpInBackground(block: {
            (succeeded: Bool, error: Error?) -> Void in
            if let error = error {
                // Show the errorString somewhere and let the user try again.
                print(error.localizedDescription)
                self.showAlert()
            } else {
                // Hooray! Let them use the app now.
                print("Sign up was successful!")
                self.emailTextField.becomeFirstResponder()
            }
        })

    }

    @IBAction func onLoginButton(_ sender: Any) {
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!{
            self.showAlert()
        }
        PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: {
            (user: PFUser?, error: Error?) -> Void in
            if let user = user {
                // Hooray! Let them use the app now.
                print("Login was successful!")
                print("\(user.email)")
            } else {
                // Show the errorString somewhere and let the user try again.
                if let error = error {
                    print(error.localizedDescription)
                }
                self.showAlert()
            }
        })
    }

}

