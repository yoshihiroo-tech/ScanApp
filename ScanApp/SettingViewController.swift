//
//  SettingViewController.swift
//  ScanApp
//
//  Created by Yoshihiro Uda on 2020/05/26.
//  Copyright © 2020 Yoshihiro Uda. All rights reserved.
//

import UIKit
import EMAlertController

class SettingViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var album: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //中心まで移動させる
        UIView.animate(withDuration: 0.3, delay: 0.2, options:[.curveLinear], animations: {
            //アニメーション処理
            self.camera.center.x = self.view.center.x
            self.album.center.x = self.view.center.x
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            
        }, completion:{ (finished:Bool) in
            
            
            
        })
    }

    
    @IBAction func openCamera(_ sender: Any) {
        
        let sourceType:UIImagePickerController.SourceType = .camera
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func openAlbum(_ sender: Any) {
        
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
    }
    
    //カメラ、アルバムの画像を受け取る
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage{
            
            imageView.image = pickedImage
            
            //アラートを出す(これで良いですか？）
            checkAlert()
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //キャンセルボタンが押された時
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func checkAlert(){
        let alert = EMAlertController(icon: UIImage(named: ""), title: "確認", message: "この背景画像でよろしいですか？")
        let action1 = EMAlertAction(title: "はい", style: .normal) {
            
            self.imageView.contentMode = .scaleAspectFill
            var data = Data()
            data = (self.imageView.image?.pngData())!
            //cardViewControllerでも表示するためアプリに格納
            UserDefaults.standard.set(data, forKey: "image")
        }
        
        let action2 = EMAlertAction(title: "もう1度", style: .normal)
            
            alert.addAction(action1)
            alert.addAction(action2)
            self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
}
