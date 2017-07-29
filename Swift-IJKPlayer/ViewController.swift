//
//  ViewController.swift
//  BeiVideo
//
//  Created by 李利锋 on 2017/7/19.
//  Copyright © 2017年 leefeng. All rights reserved.
//

import UIKit
import IJKMediaFramework



class ViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.setTitle("打开播放", for: .normal)
        button.sizeToFit()
        button.center = view.center
        button.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
        
        view.addSubview(button)


    }
    func click()  {
        
       present(PlayDemoViewController(), animated: true)
        
    }
   
}

