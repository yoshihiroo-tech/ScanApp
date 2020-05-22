//
//  Element.swift
//  ScanApp
//
//  Created by Yoshihiro Uda on 2020/05/18.
//  Copyright © 2020 Yoshihiro Uda. All rights reserved.
//

import UIKit

class Element: NSObject {
    
    var userName:String?
    var company:String?
    var imageString:String?
    var memo:String?
    var createAt:CLong?
    
    init(userName:String,company:String,imageString:String,memo:String,createAt:CLong) {
        
        self.userName = userName
        self.company = company
        self.imageString = imageString
        self.memo = memo
        self.createAt = createAt
        
    }

}
