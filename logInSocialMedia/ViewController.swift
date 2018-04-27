//
//  ViewController.swift
//  logInSocialMedia
//
//  Created by Mohammad Farhoudi on 26/04/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    let loginButton = FBSDKLoginButton()
    
    let customButton: UIButton = {
    let button = UIButton(type: .system)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    button.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
    button.setTitle("custom FB Login", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .blue
    return button
    
    }()
    
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        setUpLoginButtons()
        
    }
    
    fileprivate func setUpLoginButtons() {
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        view.addSubview(customButton)
        customButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
    }
    
    
    @objc fileprivate func handleCustomFBLogin() {
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil {
                print("FB Login Failed")
                return
            }
            
            self.showEmail()
            
        }
    
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did Log Out")
    }
    
   
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with FaceBook")
        
        showEmail()

    }

    
    fileprivate func showEmail()  {
        
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials) { (user, err) in
            if err != nil {
                print("Sth went wrong with our FB user:", err ?? "")
                return
            }
            
            print("Successfully logged in with our FB user:", err ?? "")

        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fileds": "email, id, name"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start Graph Request:", err ?? "")
                return
            }
            print(result ?? "")
            
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    
  

}

