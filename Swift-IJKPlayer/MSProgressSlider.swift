//
//  MSProgressSlider.swift
//  Pods
//
//  Created by messeb on 03/05/2016.
//  Copyright (c) 2016 messeb. All rights reserved.
//

import UIKit

public class MSProgressSlider: UISlider {
    
    @IBInspectable public var progressValue: Float = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private var _completeColor: UIColor? = UIColor.white
    private var _progressColor: UIColor? = UIColor.lightGray
    private var _valueColor: UIColor? = UIColor.red
    
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
//        CGContextMoveToPoint(context, 0, CGRectGetHeight(drawingRect)/2);
//        CGContextSetStrokeColorWithColor(context!, progressColor.cgColor);
        context?.setStrokeColor(progressColor.cgColor)
//        CGContextAddLineToPoint(context, drawingRect.size.width * CGFloat(progressWidth), CGRectGetHeight(drawingRect)/2);
        
        context?.addLine(to: CGPoint(x: drawingRect.size.width * CGFloat(progressWidth), y:  drawingRect.height/2))
//        CGContextStrokePath(context);
        
        context?.strokePath()
         context?.move(to: CGPoint(x: drawingRect.size.width * CGFloat(progressWidth), y:  drawingRect.height/2))
         context?.setStrokeColor(completeColor.cgColor)
         context?.addLine(to: CGPoint(x: drawingRect.size.width , y:  drawingRect.height/2))
         context?.strokePath()
        
        
//        CGContextMoveToPoint(context, drawingRect.size.width * CGFloat(progressWidth), CGRectGetHeight(drawingRect)/2);
//        CGContextSetStrokeColorWithColor(context, completeColor.CGColor);
//        CGContextAddLineToPoint(context, drawingRect.size.width, CGRectGetHeight(drawingRect)/2)
//        CGContextStrokePath(context);
        
        let maxTrackImg = UIGraphicsGetImageFromCurrentImageContext()
        context?.move(to: CGPoint(x: 0, y:  drawingRect.height/2))
        context?.setStrokeColor(valueColor.cgColor)
        context?.addLine(to: CGPoint(x: drawingRect.size.width, y:  drawingRect.height/2))
        context?.strokePath()
//        CGContextMoveToPoint(context, 0, CGRectGetHeight(drawingRect)/2);
//        CGContextAddLineToPoint(context, drawingRect.size.width, CGRectGetHeight(drawingRect)/2);
//        CGContextSetStrokeColorWithColor(context, valueColor.CGColor);
//        CGContextStrokePath(context);
        
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
