//
//  ViewController.swift
//  BeiVideo
//
//  Created by 李利锋 on 2017/7/19.
//  Copyright © 2017年 leefeng. All rights reserved.
//

import UIKit
import IJKMediaFramework



class ViewController: UIViewController {
    
   
   
    let height:CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playerController = PlayerViewController()

        if let playerView = playerController.view {
            
            playerController.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,height: height)
            addChildViewController(playerController)
            view.addSubview(playerView)
            
        }
        playerController.url = "http://wms2.pkudl.cn/jsj/08281013/video/300k/Vc08281013C00S00P00-300K.mp4"
          
    }
    
   
}

