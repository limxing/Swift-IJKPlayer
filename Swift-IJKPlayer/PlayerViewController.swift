//
//  PlayerViewController.swift
//  Swift-IJKPlayer
//
//  Created by 李利锋 on 2017/7/21.
//  Copyright © 2017年 leefeng. All rights reserved.
//

import UIKit
import IJKMediaFramework
protocol PlayerProtocol:class {
    func playerStartPlay()
    func playerStartPause()
    func playerStartComplete()
}

class PlayerViewController: UIViewController {
    private weak var player:IJKFFMoviePlayerController!
    private  var playerController:PlayerViewController!
  
    private  weak var videoPlayerView:VideoPlayerView?
    
    var height:CGFloat = 200
    
    private var attendToPlay = false
    private var isMax = false
    
    var playerTitle:String?{
        didSet{
            videoPlayerView?.playerTitle = playerTitle
        }
    }
    
    
    var url:String?{
        didSet{
            attendToPlay = false
            
            if let p = player,let v = videoPlayerView {
                p.shutdown()
               
                p.view.removeFromSuperview()
                v.removeAllObserver()
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
            videoPlayerView?.isMax(isMax)
            view.addSubview(videoPlayerView!)
            
            videoPlayerView?.mixOrMax = { [weak self] (isMax) in
                self?.rotateScreen(isMax:isMax)
            }
            
            if isAutoPlay {
                player.prepareToPlay()
            }

        }
    }
    
    var frame:CGRect?{
        didSet{
            guard let f = frame else { return  }
            view.frame = f
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
        
        self.isMax = isMax
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
//    override func viewWillAppear(_ animated: Bool) {
//        //开始播放
//        guard let p = player else { return  }
//        p.prepareToPlay()
//    }
    
    
//    override func viewWillDisappear(_ animated: Bool) {
//       
//    }
    
    ///获取封面ImageView
    func coverImageView() -> UIImageView? {
        return videoPlayerView?.coverImageView();
    }
    var isAutoPlay = true
    
    ///是否自动播放
    func isAutoPlay(autoPlay:Bool)  {
        self.isAutoPlay = autoPlay
    }
    ///播放器代理
   weak var playerProtocol:PlayerProtocol?{
        didSet{
            videoPlayerView?.playerProtocol = playerProtocol
        }
    }
    
    func play()  {
        videoPlayerView?.playOrPause(isPlay:true)
//        player.prepareToPlay()
    }
    func pause()  {
         videoPlayerView?.playOrPause(isPlay:false)
//        player.pause()
    }
    func shutDown()  {
        player.shutdown()
    }
    deinit {
        onDestory()
        print("PlayerViewController deinit")
    }
    
    //生命周期，必须要调用的
   private func onDestory() {
        //关闭播放器
        guard let p = player else { return  }
        p.shutdown()
        
        videoPlayerView?.removeAllObserver()
    }


}
