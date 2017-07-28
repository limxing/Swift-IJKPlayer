//
//  PlayerViewController.swift
//  Swift-IJKPlayer
//
//  Created by 李利锋 on 2017/7/21.
//  Copyright © 2017年 leefeng. All rights reserved.
//

import UIKit
import IJKMediaFramework

class PlayerViewController: UIViewController {
 var player:IJKFFMoviePlayerController!
    var playerController:PlayerViewController!
  
    var videoPlayerView:VideoPlayerView?
    
    var height:CGFloat = 200
    
    var url:String?{
        didSet{
            if let p = player,let v = videoPlayerView {
                p.shutdown()
                p.view.removeFromSuperview()
                v.removeFromSuperview()
            }
            
            let options = IJKFFOptions.byDefault()
            options?.setPlayerOptionIntValue(5, forKey: "framedrop")
            player = IJKFFMoviePlayerController(contentURLString: url, with: options)
            player?.view.frame = view.frame
            view.addSubview((player?.view)!)
            videoPlayerView = UINib(nibName: "VideoPlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? VideoPlayerView
            videoPlayerView?.frame = view.frame
            videoPlayerView?.player = player
            view.addSubview(videoPlayerView!)
            
            videoPlayerView?.mixOrMax = { (isMax) in
                self.rotateScreen(isMax:isMax)
            }
            
            player.prepareToPlay()

        }
    }
    
    var frame:CGRect?{
        didSet{
            guard let f = frame else { return  }
            view.frame = f
//            let options = IJKFFOptions.byDefault()
//            options?.setPlayerOptionIntValue(5, forKey: "framedrop")
//            
//            //视频源地址
//            let url = URL(string: "http://baobab.wandoujia.com/api/v1/playUrl?vid=2614&editionType=normal")
//            //        let url = NSURL(string: "http://wms2.pkudl.cn/jsj/08281013/video/300k/Vc08281013C00S00P00-300K.mp4")
//            //        let url = NSURL(string: "http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8")
//            //let url = NSURL(string: "http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8")
//            
//            //初始化播放器，播放在线视频或直播（RTMP）
//             player = IJKFFMoviePlayerController(contentURL: url as URL!, with: options)
//            //播放页面视图宽高自适应
//            player?.view.frame = view.frame
//            
//            //        player?.shouldAutoplay = true //开启自动播放
//            
//            //        self.view.autoresizesSubviews = true
//            view.addSubview((player?.view)!)
//            
//            
//            
//            videoPlayerView = UINib(nibName: "VideoPlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? VideoPlayerView
//            videoPlayerView?.frame = view.frame
//            
//            videoPlayerView?.player = player
//            
//            view.addSubview(videoPlayerView!)
//            
//            videoPlayerView?.mixOrMax = { (isMax) in
//                self.rotateScreen(isMax:isMax)
//            }
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                
                
                self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                //                self.player.
                self.player.view.frame = (self.view.frame)
                self.videoPlayerView?.frame = (self.view.frame)
                //                self.playerView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
                //                self.playerView.player.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
                
                
            })
        }else{//全屏->小屏
            
            UIView.animate(withDuration: 0.25, animations: {
                let value = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                
                self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.height)
                
                self.player.view.frame = self.view.frame
                self.videoPlayerView?.frame = self.view.frame
            })
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //开始播放
//        guard let p = player else { return  }
//        p.prepareToPlay()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //关闭播放器
        guard let p = player else { return  }
        p.shutdown()
    }

}
