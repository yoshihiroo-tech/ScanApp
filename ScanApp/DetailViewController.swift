//
//  DetailViewController.swift
//  ScanApp
//
//  Created by Yoshihiro Uda on 2020/05/25.
//  Copyright © 2020 Yoshihiro Uda. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    //受け取り用の変数
    var nameString = String()
    var companyString = String()
    var memoString = String()
    var cardImage = String()
    var dateString = String()
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    //画像にアニメーションをつける時の初期位置を入れる変数
    var imageView_x = CGFloat()
    var imageView_y = CGFloat()
    var imageView_w = CGFloat()
    var imageView_h = CGFloat()
    var imageView_center_y = CGFloat()
    
    var blackView = UIView()
    var closeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.boundsは画面全体。最初は通常設定。タップした時のみ背景を黒くする為
        blackView.frame = self.view.bounds
        blackView.backgroundColor = .black
        blackView.isHidden = true
        blackView.alpha = 0
        self.view.addSubview(blackView)
        
        //値を受け取る
        imageView.sd_setImage(with: URL(string: cardImage), completed: nil)
        nameLabel.text = nameString
        companyLabel.text = companyString
        memoLabel.text = memoString
        dateLabel.text = dateString
       
        //アニメーションをつける為画像の初期値を入れる
        imageView_x = imageView.frame.origin.x
        imageView_y = imageView.frame.origin.y
        imageView_w = imageView.frame.size.width
        imageView_h = imageView.frame.size.height
        imageView_center_y = imageView.center.y
        
        //画像をタップされた時に自作メソッド（imageViewTapped）が発動
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))
        
        
    }
    
    @objc func imageViewTapped(_ sender:UITapGestureRecognizer){
        
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveLinear], animations: {
            //アニメーション
            self.blackView.isHidden = false
            self.blackView.alpha = 1.0
            self.imageView.center.y = self.view.center.y
            self.imageView.layer.zPosition = 1
            let transAnimation1 = CGAffineTransform(rotationAngle: CGFloat(90 * CGFloat.pi/180))
            
            let transAnimation2 = CGAffineTransform(scaleX: 3, y: 3)
            
            let transAnimation3 = transAnimation1.concatenating(transAnimation2)
            
            self.imageView.transform = transAnimation3
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
        }, completion: {(finished:Bool)in
            //アニメーションが終了した時
            
             //閉じるボタン設置(2でimageViewより上へ＝押せる)
            self.closeButton.layer.zPosition = 2
            self.closeButton.frame = CGRect(x: 0, y: self.view.frame.size.height - 50, width: 50, height: 50)
            self.closeButton.setImage(UIImage(named: ""), for: .normal)
            self.closeButton.addTarget(self, action: #selector(self.tapCloseButton), for: .touchUpInside)
            self.view.addSubview(self.closeButton)
        })
    }
  
    
    
    @objc func tapCloseButton(){
        //closebuttonがタップされた時→画像を元の大きさへ戻す
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveLinear], animations: {
            //アニメーション
            self.blackView.isHidden = true
            self.blackView.alpha = 0
            self.imageView.layer.zPosition = 1
            let transAnimation1 = CGAffineTransform(rotationAngle: CGFloat(0 * CGFloat.pi/180))
            self.imageView.frame = CGRect(x: self.imageView_x, y: self.imageView_y, width: self.imageView_w, height: self.imageView_h)
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
        }, completion: {(finished:Bool)in
            //アニメーションが終了した時
            self.closeButton.removeFromSuperview()
            self.blackView.isHidden = true
            
        })
        
        
    }
    
    
    
    
}
