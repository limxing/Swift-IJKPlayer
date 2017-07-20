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
    @IBOutlet weak var buttonImageView: UIButton!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var labelCurrent: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var bacProgressView: UIProgressView!
    @IBOutlet weak var progressSlider: MSProgressSlider!


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  

    @IBOutlet weak var buttonMax: UIButton!
    
    var delaytask:Task?
    
    
    var player:IJKFFMoviePlayerController?{
        didSet{
            player?.play()
            buttonPlay.isSelected = true
//            print("leefengme:\(player?.duration)")
            initPlayerObservers()
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
        }
    }
    
    //刷新进度
    func timeUpdate()  {
        
        let total = player?.duration
        let current = player?.currentPlaybackTime
        
        let able = player?.playableDuration
        
        let dformatter = DateFormatter()
        dformatter.dateFormat = "mm:ss"
        
        let dateDuration = Date(timeIntervalSince1970: (total)!)
        labelDuration.text =  dformatter.string(from: dateDuration)
        
        let dateCurrent = Date(timeIntervalSince1970: (current)!)
        labelCurrent.text = dformatter.string(from: dateCurrent)
        
//        progressSlider.setValue(Float(current!)/Float(total!), animated: true)
        bacProgressView.setProgress(Float(current!)/Float(total!), animated: true)
        
//        bacProgressSlider.setProgress(Float(able!)/Float(total!), animated: true)
        progressSlider.progressValue = Float(able!)/Float(total!)
        
        progressSlider.value = Float(current!)/Float(total!)
        
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
            leefeng_cancel(delaytask)
            delaytask =  leefeng_delay(2){
                if self.player?.isPlaying() ?? true{
                    self.showPlayView(isHidden: true)
                }
            }

            
        }else if player?.playbackState.rawValue == 2 {
            leefeng_cancel(delaytask)
            delaytask =  leefeng_delay(2){
                if !self.viewTop.isHidden && !(self.player?.isPlaying() ?? true){
                    self.showPlayView(isHidden: true)
                    self.buttonPlay.isHidden = false
                }
            }

        }
       print("leefeng:\(player?.playbackState.rawValue)")
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
//                if !self.viewTop.isHidden && self.player?.isPlaying() ?? true {
//                   
//                    self.showPlayView(isShow: true)
//                }
//            }

        viewBottom.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        viewTop.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
//        //渐变颜色
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = viewBottom.frame
//        //设置渐变的主颜色（可多个颜色添加）
//        gradientLayer.colors = [ #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor,#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor]
//        //将gradientLayer作为子layer添加到主layer上
//        viewBottom.layer.addSublayer(gradientLayer)
        
       
        progressSlider.isContinuous = true;//设置为NO,只有在手指离开的时候调用valueChange
        progressSlider.addTarget(self, action: #selector(sliderValuechange), for: .valueChanged)
//        progressSlider.minimumTrackTintColor = #colorLiteral(red: 0.8039215686, green: 0.1764705882, blue: 0.1098039216, alpha: 1)
        progressSlider.maximumTrackTintColor = UIColor.white
        let image = Slider.createImage(with: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        let circleImage = Slider.circleImage(with: image, borderWidth: 0, borderColor: UIColor.clear)
        progressSlider.setThumbImage(circleImage, for: .normal)

        progressSlider.addTarget(self, action: #selector(sliderTap), for: .touchUpInside)
        


    }
    
    //UISlider抬起
   @objc private func sliderTap()  {
         leefeng_cancel(delaytask)
        delaytask =  leefeng_delay(2){
            if self.player?.isPlaying() ?? true{
                self.showPlayView(isHidden: true)
            }
        }
    }
     //UISlider滑动
   @objc private func sliderValuechange(view:UISlider)  {
        
        leefeng_cancel(delaytask)
        print("leefeng:\(view.value)")
    }
    
    //播放按钮点击
    @IBAction func clickPlay(_ sender: Any) {
        if buttonPlay.isSelected {
            player?.pause()
        }else{
            player?.play()
        }
        
        buttonPlay.isSelected = !buttonPlay.isSelected
        

    }
    //点击全屏按钮
    @IBAction func clickMax(_ sender: UIButton) {
      
      
        sender.isSelected = !sender.isSelected
        mixOrMax?(sender.isSelected)
        
        leefeng_cancel(delaytask)
        delaytask = leefeng_delay(2){
            self.showPlayView(isHidden: true)
        }
        
    }


    var beginTouch:CGPoint?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        beginTouch = event?.touches(for: self)?.first?.location(in: self)
//        if (player?.isPlaying() ?? false) {
//            changePlayView()
//        }
//        
//        let m = self.player?.playableDuration
//        print("leefeng:\(m)")
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        let moveTouch = touches.first?.location(in: self)
        print("x:\(moveTouch?.x);y:\(moveTouch?.y)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let endTouch = event?.touches(for: self)?.first?.location(in: self)
        
        if beginTouch?.equalTo(endTouch!) ?? true {
            showPlayView(isHidden:!viewTop.isHidden)
            
            leefeng_cancel(delaytask)
            delaytask =  leefeng_delay(2){
                if !self.viewTop.isHidden  {
                    self.showPlayView(isHidden: true)
                }
            }

        }
    }
    
    
    private func showPlayView(isHidden:Bool){
        viewTop.isHidden = isHidden
        viewBottom.isHidden = isHidden
        buttonPlay.isHidden = isHidden
        bacProgressView.isHidden = !isHidden
        if !(self.player?.isPlaying() ?? true) {
            buttonPlay.isHidden = false

        }
    }
    
}
