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
    var playerController:PlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         playerController = PlayerViewController()

        if let playerView = playerController?.view {
            
            playerController?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,height: height)
            addChildViewController(playerController!)
            view.addSubview(playerView)
            
        }
        playerController?.url = "http://wms2.pkudl.cn/jsj/08281013/video/300k/Vc08281013C00S00P00-300K.mp4"
        
        
        let button = UIButton()
        button.setTitle("切换路径", for: .normal)
        button.center = view.center
        button.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
        button.sizeToFit()
        view.addSubview(button)
    }
    func click()  {
        playerController?.url = "http://baobab.wandoujia.com/api/v1/playUrl?vid=2614&editionType=normal"
    }
   
}

