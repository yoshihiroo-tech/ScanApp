//
//  CardViewController.swift
//  ScanApp
//
//  Created by Yoshihiro Uda on 2020/05/16.
//  Copyright © 2020 Yoshihiro Uda. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase


class CardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var displayName = String()
    var pictureURLString = String()
    let refleshControl = UIRefreshControl()

    @IBOutlet weak var myProfileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //Element型の配列を準備
    weak var element:Element?
    var listOfData = [Element]()
    
    //カード
    var cardImageView = UIImageView()
    
    
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
        
        return listOfData.count
        
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //タグ１をuserNameLabelとし、ElementのuserNameを入れる
        let userNameLabel = cell.viewWithTag(1) as! UILabel
        userNameLabel.text = listOfData[indexPath.row].userName
        
        let companyNameLabel = cell.viewWithTag(2) as! UILabel
        companyNameLabel.text = listOfData[indexPath.row].company
        
        cardImageView = cell.viewWithTag(3) as! UIImageView
        let profileImageURL = URL(string: listOfData[indexPath.row].imageString as! String)
        cardImageView.sd_setImage(with: profileImageURL, completed: nil)
        cardImageView.layer.cornerRadius = 10.0
        cardImageView.clipsToBounds = true
        
        let createAtLabel = cell.viewWithTag(4) as! UILabel
        //データベースへは文字の羅列で入っているので整形する
        let dateUnix = Double(listOfData[indexPath.row].createAt!) as! TimeInterval
        //ミリ秒単位まで記録されているので1000で割る
        let date = Date(timeIntervalSince1970: dateUnix/1000)
        //DSDatte型を日時文字列に変換するため
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateStr:String = formatter.string(from: date)
        createAtLabel.text = dateStr
        
           return cell
       }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.view.frame.size.height/3
        
    }
    
    //https://scanapp-66253.firebaseio.com/
    //データをFirebaseから取ってくる
    func fetchData(){
        //データベースサーバーからpost(点、場所,自分で決める)というノードから最新100件を古い順に取ってくる
        //snapshotへ入っている
        let ref = Database.database().reference(fromURL: "https://scanapp-66253.firebaseio.com/").child("post").queryLimited(toLast: 100).queryOrdered(byChild: "postDate").observe(.value) { (snapshot) in
            //まず配列の中身を全て消す
            self.listOfData.removeAll()
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshot{
                    
                    if let postData = snap.value as? [String:Any]{
                        let userName = postData["userName"] as? String
                        let company = postData["company"] as? String
                        let imageString = postData["imageString"] as? String
                        let memo = postData["memo"] as? String
                        
                        //上でpostDateの順に並べている。日付が入ってこないとそもそもエラーなのでifを使っている
                        var postDate:CLong?
                        if let postedDate = postData["createAt"] as? CLong{
                            postDate = postedDate
                        }
                        
                        self.listOfData.append(Element(userName: userName!, company: company!, imageString: imageString!, memo: memo!, createAt: postDate!))
                        
                    }
                }
                
                self.tableView.reloadData()
                
                
            }
            
            
            
            
        }
        
    }
    
    
    
    
    

}
