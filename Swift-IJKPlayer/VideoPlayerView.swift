//
//  VideoPlayerView.swift
//  BeiVideo
//
//  Created by 李利锋 on 2017/7/19.
//  Copyright © 2017年 leefeng. All rights reserved.
//

import UIKit
import IJKMediaFramework

class VideoPlayerView: UIView {
    var mixOrMax:((_ isMax:Bool)->())?
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var buttonImageView: PlayControButton!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var labelCurrent: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewTop: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  

    @IBOutlet weak var buttonMax: UIButton!
    
   
    
    var player:IJKFFMoviePlayerController?{
        didSet{
            player?.play()
            buttonPlay.isSelected = true
//            print("leefengme:\(player?.duration)")
            initPlayerObservers()
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
        }
    }
    
    
    func timeUpdate()  {
        
        let dformatter = DateFormatter()
        dformatter.dateFormat = "mm:ss"
        
        let dateDuration = Date(timeIntervalSince1970: (player?.duration)!)
        labelDuration.text =  dformatter.string(from: dateDuration)
        
        let dateCurrent = Date(timeIntervalSince1970: (player?.currentPlaybackTime)!)
        labelCurrent.text = dformatter.string(from: dateCurrent)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func initPlayerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayBackStateDidChange), name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: player)
    }
    func moviePlayBackStateDidChange()  {
        //播放 1  暂停2
        if player?.playbackState.rawValue == 1 {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                //code
                if !self.buttonImageView.isSelected && self.player?.isPlaying() ?? true{
                    self.buttonImageView.isSelected = true
                    self.playView.alpha = 0
                }
            }
            
        }else if player?.playbackState.rawValue == 2 {
            
        }
       print("leefeng:\(player?.playbackState.rawValue)")
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonImageView.showPlayView = {
            self.changePlayView()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                //code
                if !self.buttonImageView.isSelected && self.player?.isPlaying() ?? true {
                    self.buttonImageView.isSelected = true
                    self.playView.alpha = 0
                }
            }
        }
        
        
        viewBottom.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        viewTop.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
//        //渐变颜色
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = viewBottom.frame
//        //设置渐变的主颜色（可多个颜色添加）
//        gradientLayer.colors = [ #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor,#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor]
//        //将gradientLayer作为子layer添加到主layer上
//        viewBottom.layer.addSublayer(gradientLayer)
        
    }
    
    @IBAction func clickPlay(_ sender: Any) {
        if buttonPlay.isSelected {
            player?.pause()
        }else{
            player?.play()
        }
        
        buttonPlay.isSelected = !buttonPlay.isSelected
        

    }
    @IBAction func clickMax(_ sender: UIButton) {
      
      
        sender.isSelected = !sender.isSelected
          mixOrMax?(sender.isSelected)
        
    }

//    @IBAction func clickImageView(_ sender: Any) {
//        
//      changePlayView()
//        
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (player?.isPlaying() ?? false) {
            changePlayView()
        }
        
        let m = self.player?.playableDuration
        print("leefeng:\(m)")
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !buttonImageView.isSelected {
            buttonImageView.isSelected = true
        }
    }
    
    
    func changePlayView()  {
        if (buttonImageView.isSelected) {
            playView.alpha = 1
        }else{
            playView.alpha = 0
        }
        buttonImageView.isSelected = !buttonImageView.isSelected

    }
    
}
