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
import GoogleSignIn

class ViewController: UIViewController, FBSDKLoginButtonDelegate , GIDSignInUIDelegate{
    
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
    
 
    let GoogleButton = GIDSignInButton()
    
    let customGoogleButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                button.addTarget(self, action: #selector(handleCustomGoogleLogin), for: .touchUpInside)
        button.setTitle("custom Google Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        setupFacebookLoginButtons()
        setupGoogleLoginButtons()
    }
    
    fileprivate func setupFacebookLoginButtons() {
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        view.addSubview(customButton)
        customButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
    }
    
    fileprivate func setupGoogleLoginButtons() {
        
        view.addSubview(GoogleButton)
        GoogleButton.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32, height: 50)
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        view.addSubview(customGoogleButton)
        customGoogleButton.frame = CGRect(x: 16, y: 116 + 66 + 66, width: view.frame.width - 32, height: 50)
    
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
    
    
    @objc fileprivate func handleCustomGoogleLogin() {
    
      GIDSignIn.sharedInstance().signIn()
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

