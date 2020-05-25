//
//  EditViewController.swift
//  ScanApp
//
//  Created by Yoshihiro Uda on 2020/05/23.
//  Copyright © 2020 Yoshihiro Uda. All rights reserved.
//

import UIKit
import Firebase
import Lottie
import Pastel

class EditViewController: UIViewController,UITextFieldDelegate {
    
    var cardImage = UIImage()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = cardImage
        nameTextField.delegate = self
        cardNameTextField.delegate = self
        memoTextField.delegate = self
        
    }
    
    //データをDBへ入れる一連の流れ(画像はstorageを経由)
    func addData(){
        //データをFirebaseへ送信するときはキーボード閉じている必要
        nameTextField.resignFirstResponder()
        cardNameTextField.resignFirstResponder()
        memoTextField.resignFirstResponder()
        //post階層作成
        let rootRef = Database.database().reference(fromURL: "https://scanapp-66253.firebaseio.com/").child("post")
        let storage = Storage.storage().reference(forURL: "gs://scanapp-66253.appspot.com/")
        //post階層の下にUsersという階層を作成
        let key = rootRef.child("Users").childByAutoId().key
        let imageRef = storage.child("Users").child("\(String(describing:key!)).jpg")
        
        var data:Data = Data()
        //imageView.imageに何かあれば圧縮してdataへ入れる
        if let image = imageView.image{
            data = image.jpegData(compressionQuality: 0.5)! as Data
        }
        //putDataで画像をStorageへ入れる
        let uploadTask = imageRef.putData(data, metadata: nil) { (metaData, error) in
            
            if error != nil{
                //showで遷移したときの戻り
                self.navigationController?.popViewController(animated: true)
                return
            }
            //Storageに入っているurlを戻すのがdownloadURL。urlへ値が入った時
            imageRef.downloadURL(completion: { (url, error) in
                //storageサーバにurlが何かしら存在する場合
                if url != nil{
                    
                    let feed = ["company":self.cardNameTextField.text as Any,"userName":self.nameTextField.text as Any,"imageString":url?.absoluteURL as Any,"memo":self.memoTextField.text as Any,"createAt":ServerValue.timestamp()] as [String:Any]
                    let postFeed = ["\(key!)":feed]
                    //DBサーバへ入れる
                    rootRef.updateChildValues(postFeed)
                    //戻る
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        uploadTask.resume()
        self.dismiss(animated: true, completion: nil)
    }
    
    //タッチでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        nameTextField.resignFirstResponder()
        cardNameTextField.resignFirstResponder()
        memoTextField.resignFirstResponder()
        
    }
    
    
    

}
