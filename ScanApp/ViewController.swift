//
//  ViewController.swift
//  ScanApp
//
//  Created by Yoshihiro Uda on 2020/05/16.
//  Copyright © 2020 Yoshihiro Uda. All rights reserved.
//

import UIKit
import LineSDK
import Photos



class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var lineLoginButton: LoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ユーザーに許可を促す
        PHPhotoLibrary.requestAuthorization { (status) in
            switch(status){
                
            case .authorized:
                break
                
            case .denied:
                break
                
            case .notDetermined:
                break
                
            case .restricted:
                break
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ナビバーを消す
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    @IBAction func loginAction(_ sender: Any) {
        
        //ログインを実装
        LoginManager.shared.login(permissions: [.profile], in: self) { (result) in
            
            switch result{
                
            case .success(let loginResult):
                if let profile = loginResult.userProfile{
                    
                    UserDefaults.standard.set(profile.displayName, forKey: "displayName")
                    UserDefaults.standard.set(String(describing: profile.pictureURL), forKey: "pictureURLString")
                    
                    //画面遷移
                    let cardVC = self.storyboard?.instantiateViewController(withIdentifier: "cardVC") as! CardViewController
                    self.navigationController?.pushViewController(cardVC, animated: true)
            
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

