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
    
    var player:IJKFFMoviePlayerController!
    
    
    var playerView:UIView?
    var videoPlayerView:VideoPlayerView?
    let height:CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         playerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        
        let options = IJKFFOptions.byDefault()
        options?.setPlayerOptionIntValue(5, forKey: "framedrop")
        
        //视频源地址
        let url = NSURL(string: "http://wms2.pkudl.cn/jsj/08281013/video/300k/Vc08281013C00S00P00-300K.mp4")
//        let url = NSURL(string: "http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8")
        //let url = NSURL(string: "http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8")
        
        //初始化播放器，播放在线视频或直播（RTMP）
        let player = IJKFFMoviePlayerController(contentURL: url as URL!, with: options)
        //播放页面视图宽高自适应

        
        
        player?.view.frame = (playerView?.frame)!
        
//        player?.shouldAutoplay = true //开启自动播放
        
//        self.view.autoresizesSubviews = true
        playerView?.addSubview((player?.view)!)
        self.view.addSubview(playerView!)
        self.player = player
        
         videoPlayerView = UINib(nibName: "VideoPlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? VideoPlayerView
        videoPlayerView?.frame = (self.playerView?.frame)!
        videoPlayerView?.player = player
        playerView?.addSubview(videoPlayerView!)
        
        videoPlayerView?.mixOrMax = { (isMax) in
           self.rotateScreen(isMax:isMax)
        }
        
        
        
       
    
    }
    
    func rotateScreen(isMax:Bool) {
//        print("旋转")
//        var value:Int
//        if button.isSelected {
//            value = UIInterfaceOrientation.portrait.rawValue
//             button.isSelected = false
//            self.player.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180)
//           
//        }else{
//            value = UIInterfaceOrientation.landscapeLeft.rawValue
//            button.isSelected = true
//            self.player.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
//        }
//        
//         UIDevice.current.setValue(value, forKey: "orientation")
//        

        
        if (isMax) {//小屏->全屏
            
            UIView.animate(withDuration: 0.25, animations: { 
                let value = UIInterfaceOrientation.landscapeRight.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                
                
                  self.playerView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//                self.player.
                self.player.view.frame = (self.playerView?.frame)!
                 self.videoPlayerView?.frame = (self.playerView?.frame)!
//                self.playerView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
//                self.playerView.player.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
                
                
            })
        }else{//全屏->小屏
          
            UIView.animate(withDuration: 0.25, animations: {
                let value = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                
                self.playerView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.height)
      
                self.player.view.frame = (self.playerView?.frame)!
                self.videoPlayerView?.frame = (self.playerView?.frame)!
            })
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        //开始播放
        self.player.prepareToPlay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //关闭播放器
        self.player.shutdown()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

