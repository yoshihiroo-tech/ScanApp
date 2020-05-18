//
//  CardViewController.swift
//  ScanApp
//
//  Created by Yoshihiro Uda on 2020/05/16.
//  Copyright © 2020 Yoshihiro Uda. All rights reserved.
//

import UIKit
import SDWebImage


class CardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var displayName = String()
    var pictureURLString = String()
    let refleshControl = UIRefreshControl()

    @IBOutlet weak var myProfileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ログインしました痕跡(1が入ってたらログインの画面を飛ばす構造ができる）
        UserDefaults.standard.set(1, forKey: "loginOK")
        //ナビバーを隠す
        navigationController?.setNavigationBarHidden(true, animated: true)
        //引っ張って更新機能
        refleshControl.attributedTitle = NSAttributedString(string: "引っ張って更新!")
        refleshControl.addTarget(self, action: #selector(reflesh), for: .valueChanged)
        
        tableView.addSubview(refleshControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        displayName = UserDefaults.standard.object(forKey: "displayName") as! String
        pictureURLString = UserDefaults.standard.object(forKey: "pictureURLString") as! String
        
        displayNameLabel.text = displayName
        
        let url = URL(string: pictureURLString)
        myProfileImageView.sd_setImage(with: url, completed: nil)
        
    }
    
    @objc func reflesh(){
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           return cell
       }
    
    
    
    

}
