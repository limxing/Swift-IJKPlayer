//
//  MSProgressSlider.swift
//
//
//  Created by leefeng.me on 19/07/2017.
//  Copyright (c) 2017 leefeng.me. All rights reserved.
//

import UIKit

public class MSProgressSlider: UISlider {
    
    @IBInspectable public var progressValue: Float = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private weak var _completeColor: UIColor? = UIColor.white
    private weak var _progressColor: UIColor? = UIColor.lightGray
    private weak var _valueColor: UIColor? = UIColor.red
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let progressColor = self.progressColor, let valueColor = self.valueColor, let completeColor = self.completeColor else {
            return
        }
        
        let drawingRect = rect
        let progressWidth = self.progressValue / (self.maximumValue + self.minimumValue)
        
        
        UIGraphicsBeginImageContextWithOptions(drawingRect.size, false, UIScreen.main.scale);
        let context = UIGraphicsGetCurrentContext();
        context?.move(to: CGPoint(x: 0, y:  drawingRect.height/2))
        context?.setStrokeColor(progressColor.cgColor)
        context?.addLine(to: CGPoint(x: drawingRect.size.width * CGFloat(progressWidth), y:  drawingRect.height/2))
      
        context?.strokePath()
        context?.move(to: CGPoint(x: drawingRect.size.width * CGFloat(progressWidth), y:  drawingRect.height/2))
        context?.setStrokeColor(completeColor.cgColor)
        context?.addLine(to: CGPoint(x: drawingRect.size.width , y:  drawingRect.height/2))
        context?.strokePath()
        
       
        let maxTrackImg = UIGraphicsGetImageFromCurrentImageContext()
        context?.move(to: CGPoint(x: 0, y:  drawingRect.height/2))
        context?.setStrokeColor(valueColor.cgColor)
        context?.addLine(to: CGPoint(x: drawingRect.size.width, y:  drawingRect.height/2))
        context?.strokePath()
       
        let minTrackImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        self.setMinimumTrackImage(minTrackImg, for: .normal)
        self.setMaximumTrackImage(maxTrackImg, for: .normal)
    }
    
    // MARK: UIAppearance
    @IBInspectable public dynamic var completeColor: UIColor? {
        get { return self._completeColor }
        set { self._completeColor = newValue }
    }
    
    @IBInspectable public dynamic var progressColor: UIColor? {
        get { return self._progressColor }
        set { self._progressColor = newValue }
    }
    
    @IBInspectable public dynamic var valueColor: UIColor? {
        get { return self._valueColor }
        set { self._valueColor = newValue }
    }
}
