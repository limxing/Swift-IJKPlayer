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
    weak var playerProtocol:PlayerProtocol?

    var mixOrMax:((_ isMax:Bool)->())?
    @IBOutlet weak var playView: UIView!
 
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var imageViewCover: UIImageView!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var labelCurrent: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var bacProgressView: UIProgressView!
    @IBOutlet weak var progressSlider: MSProgressSlider!
    @IBOutlet weak var tipsView: UIView!
    @IBOutlet weak var tipsImageView: UIImageView!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var tipsProgressView: UIProgressView!

    @IBOutlet weak var loadviewbac: UIView!

    @IBOutlet weak var loadview: UIActivityIndicatorView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
   private var canTouch = false
   
  

    @IBOutlet weak var buttonMax: UIButton!
    
    var delaytask:Task?
    
    @IBAction func buttonBackClick(_ sender: Any) {
        if buttonMax.isSelected {
            clickMax(buttonMax)
        }
    }
   
    var timer:Timer? 
    
    var player:IJKFFMoviePlayerController?{
        didSet{
//            player?.play()
            buttonPlay.isHidden = false
//            print("leefengme:\(player?.duration)")
            initPlayerObservers()
          
         timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
        }
    }
 
    
    //刷新进度
    func timeUpdate()  {
        guard let p = player else { return  }
        
        if !p.isPlaying(){
            return
        }
        
        let total = player?.duration
        let current = player?.currentPlaybackTime
        
        let able = player?.playableDuration
        
        let dformatter = DateFormatter()
        dformatter.dateFormat = "mm:ss"
        
        let dateDuration = Date(timeIntervalSince1970: round((total)!))
        labelDuration.text =  dformatter.string(from: dateDuration)
        
        let dateCurrent = Date(timeIntervalSince1970:  round((current)!))
        labelCurrent.text = dformatter.string(from: dateCurrent)
        
//        progressSlider.setValue(Float(current!)/Float(total!), animated: true)
        bacProgressView.setProgress(Float(current!)/Float(total!), animated: true)
        
//        bacProgressSlider.setProgress(Float(able!)/Float(total!), animated: true)
        progressSlider.progressValue = Float(able!)/Float(total!)
        
        progressSlider.value = Float(current!)/Float(total!)
        
    }
    func removeAllObserver() {
         print("VideoPlayerView removeAllObserver")
        NotificationCenter.default.removeObserver(self)
        guard let timer1 = self.timer
            else{ return }
        timer1.invalidate()

    }
    deinit {
        
         print("VideoPlayerView deinit")
    }
    func initPlayerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayBackStateDidChange), name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: player)
    
        NotificationCenter.default.addObserver(self, selector: #selector(mediaIsPreparedToPlayDidChange), name: NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: player)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayBackFinish), name: NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: player)
        NotificationCenter.default.addObserver(self, selector: #selector(loadStateDidChange), name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player)
    }
    
    func loadStateDidChange()  {
        let l = player?.loadState
        print("loadStateDidChange:\(l)")
    }
    
    func moviePlayBackFinish(notifycation:Notification)  {
        
       let l = notifycation.userInfo?[IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as! Int
        
        switch (l) {
        case 0:
           break
            
        case 2:

            break
            
        case 1:
            print("播放错误，需要重新播放：\(l)")
            canTouch = false
            buttonPlay.isHidden = true
            break
        default:
            break
        }
    }
    
    func mediaIsPreparedToPlayDidChange() {
        print("状态状态:mediaIsPreparedToPlayDidChange")
        showPlayView(isHidden: false)
        showLoadView(isHidden: true)
        
    }
    
    func moviePlayBackStateDidChange()  {

        canTouch = true
         //播放 1  暂停2  播放完成 0
        print("状态状态：\(player?.playbackState.rawValue)")
        switch player?.playbackState.rawValue ?? 0 {
        case 0:
            buttonPlay.isSelected = false
            buttonPlay.isHidden = false
            playerProtocol?.playerStartComplete()
            break
            
        case 1:
            buttonPlay.isSelected = true
            imageViewCover.isHidden = true
            buttonPlay.isHidden = false
            leefeng_cancel(delaytask)
            delaytask =  leefeng_delay(2){
                if self.player?.isPlaying() ?? true{
                    self.showPlayView(isHidden: true)
                }
            }
            showLoadView(isHidden:true)
           playerProtocol?.playerStartPlay()
            break
            
        case 2:
            buttonPlay.isSelected = false
            leefeng_cancel(delaytask)
            delaytask =  leefeng_delay(2){
                if !self.viewTop.isHidden && !(self.player?.isPlaying() ?? true){
                    self.showPlayView(isHidden: true)
                    self.buttonPlay.isHidden = false
                }
            }
            playerProtocol?.playerStartPause()
            break
        case 4:
            if !loadview.isAnimating {
                showLoadView(isHidden: false)
            }
            break
        default:
            break
            
        }
       
    }
    
    ///是否开启菊花
    func showLoadView(isHidden:Bool)  {
        loadviewbac.isHidden = isHidden
        if isHidden {
             loadview.stopAnimating()
        }else{
             loadview.startAnimating()
             buttonPlay.isHidden = true
        }
       
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
        
//tips init
        tipsView.layer.cornerRadius = 10
        tipsView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        
        loadviewbac.layer.cornerRadius = 10
        loadviewbac.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        

//        loadview.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
//        let transform = CGAffineTransform(scaleX: 2, y: 2)
//        loadview.transform = transform
        
        loadview.center = loadviewbac.center
        loadview.startAnimating()

        showPlayView(isHidden: true)
        showLoadView(isHidden: true)
        
        imageViewCover.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

    }
    
    //UISlider抬起
   @objc private func sliderTap(sender:UISlider)  {
        let d = sender.value * Float((player?.duration)!)
        player?.currentPlaybackTime = TimeInterval(d)
         leefeng_cancel(delaytask)
        delaytask =  leefeng_delay(3){
            if self.player?.isPlaying() ?? true{
                self.showPlayView(isHidden: true)
            }
        }
    }
     //UISlider滑动
   @objc private func sliderValuechange(sender:UISlider)  {
        
        leefeng_cancel(delaytask)
        print("leefeng:\(sender.value)")
        let d = sender.value * Float((player?.duration)!)
//        player?.currentPlaybackTime = TimeInterval(d)
    
        let dformatter = DateFormatter()
        dformatter.dateFormat = "mm:ss"
    
        let dateCurrent = Date(timeIntervalSince1970: TimeInterval(d))
        labelCurrent.text = dformatter.string(from: dateCurrent)
    }
    
    //播放按钮点击
    @IBAction func clickPlay(_ sender: Any) {
        if buttonPlay.isSelected {
            player?.pause()
        }else{
            player?.prepareToPlay()
            player?.play()
            leefeng_delay(0.5, task: { 
                if !(self.player?.isPlaying())! {
                    self.showLoadView(isHidden: false)

                }
            })
          }
        
        buttonPlay.isSelected = !buttonPlay.isSelected
        

    }
    //点击全屏按钮
    @IBAction func clickMax(_ sender: UIButton) {
      
     
        buttonBack.isHidden = sender.isSelected
      
        sender.isSelected = !sender.isSelected
        mixOrMax?(sender.isSelected)
        
        leefeng_cancel(delaytask)
        delaytask = leefeng_delay(3){
            self.showPlayView(isHidden: true)
        }
        
    }


    var beginTouch:CGPoint?
    var total:Double = 0
    var current:Double = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !canTouch {
            return
        }
        
        beginTouch = touches.first?.location(in: self)
        
        lastMoveTouch = beginTouch
//        if (player?.isPlaying() ?? false) {
//            changePlayView()
//        }
//        
//        let m = self.player?.playableDuration
       
         total = Double((player?.duration)!)
         current = Double((player?.currentPlaybackTime)!)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "mm:ss"
        let currentDuration = Date(timeIntervalSince1970: round(current))
        let dateDuration = Date(timeIntervalSince1970: round(total))
        
        tipsLabel.text = dformatter.string(from: currentDuration) + "/" + dformatter.string(from: dateDuration)
        
         print("leefeng touchbegin:\(current)")
    }
    
    var lastMoveTouch:CGPoint?
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !canTouch {
            return
        }
        
        if buttonMax.isSelected {
            let moveTouch = touches.first?.location(in: self)
            if abs((beginTouch?.x)! - (moveTouch?.x)!) < 2{
                return
            }
            if tipsView.isHidden {
                buttonPlay.isHidden = true
                tipsView.isHidden = false
                tipsView.alpha = 0
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipsView.alpha = 1
                })
            }
           
            let dif = Double((moveTouch?.x)! - (lastMoveTouch?.x)!)
            current += dif * 0.2
            if current >= total {
                current = total
            }
            if current <= 0 {
                current = 0
            }
            print("leefnegme:move，\(current) ,dif: \(dif)")
            let dformatter = DateFormatter()
            dformatter.dateFormat = "mm:ss"
            let currentDuration = Date(timeIntervalSince1970: round(current))
            let dateDuration = Date(timeIntervalSince1970: round(total))
            
            if dif > 0 {
                //快进
                tipsImageView.image = UIImage(named: "ic_forword")
            }else if dif < 0{
                //快退
                 tipsImageView.image = UIImage(named: "ic_toback")
            }
            tipsLabel.text = dformatter.string(from: currentDuration) + "/" + dformatter.string(from: dateDuration)
            tipsProgressView.setProgress(Float(current)/Float(total), animated: true)
//            bacProgressView.setProgress(Float(current)/Float(total), animated: true)
            lastMoveTouch = moveTouch
           
        }
       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !canTouch {
            return
        }
        let endTouch = touches.first?.location(in: self)
        
        if beginTouch?.equalTo(endTouch!) ?? true {
            showPlayView(isHidden:!viewTop.isHidden)
            
            leefeng_cancel(delaytask)
            delaytask =  leefeng_delay(3){
                if !self.viewTop.isHidden  {
                    self.showPlayView(isHidden: true)
                }
            }

        }
        if !tipsView.isHidden {
            
            UIView.animate(withDuration: 0.25, animations: {
                self.tipsView.alpha = 0

            }, completion: { [weak self] (_)  in
                 self?.tipsView.isHidden = true
            })
        }
        
        
        if abs(current - Double((player?.currentPlaybackTime)!)) > 5 {
            player?.currentPlaybackTime = TimeInterval(current)
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
    
    func coverImageView() -> UIImageView {
        return imageViewCover
    }
    
    func playOrPause(isPlay:Bool) {
        
        if isPlay {
            if !(player?.isPlaying())! {
                clickPlay(buttonPlay)
            }
        }else{
            if (player?.isPlaying())! {
                clickPlay(buttonPlay)
            }
        }
    }
    func isMax(_ isMax:Bool) {
        buttonMax.isSelected = isMax
    }
    
    var playerTitle:String?{
        didSet{
            titleLabel.text = playerTitle
        }
    }
    
    
}
