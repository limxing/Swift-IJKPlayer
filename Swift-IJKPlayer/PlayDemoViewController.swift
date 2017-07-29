//
//  PlayDemoViewController.swift
//  Swift-IJKPlayer
//
//  Created by 李利锋 on 2017/7/29.
//  Copyright © 2017年 leefeng. All rights reserved.
//

import UIKit

class PlayDemoViewController: UIViewController,PlayerProtocol  {
    internal func playerStartComplete() {
        print("playerStartComplete")
        playerController?.url = "http://baobab.wandoujia.com/api/v1/playUrl?vid=2614&editionType=normal"
    }
    
    internal func playerStartPause() {
        print("playerStartPause")
    }
    
    internal func playerStartPlay() {
        print("playerStartPlay")
    }
    
    let height:CGFloat = 200
    var playerController:PlayerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //以下必须配置
        //得到控制器
        playerController = PlayerViewController()
        if let playerView = playerController?.view {
            //初始化播放界面的大小
            playerController?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,height: height)
            //添加控制器
            addChildViewController(playerController!)
            //添加播放界面
            view.addSubview(playerView)
            
        }
        //设置路径后立即播放,默认true
        playerController?.isAutoPlay = false
        //设置路径
        playerController?.url = "http://baobab.wandoujia.com/api/v1/playUrl?vid=2616&editionType=normal"
        //以下选配
        //设置封面
        playerController?.coverImageView()?.image = UIImage(named: "cover")
        playerController?.playerTitle = "leefeng.me"
        //协议
        playerController?.playerProtocol = self
        
        

        
        let button = UIButton(frame:CGRect(x: 50, y: UIScreen.main.bounds.height/3 * 2, width: 50, height: 20))
        button.setTitle("关闭", for: .normal)
//        button.center = view.center
        button.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
        button.sizeToFit()
        view.addSubview(button)
        

    }
   
    func click()  {
        dismiss(animated: true)
        
    }

}
