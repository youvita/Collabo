/*
 * JLToastView.swift
 *
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *                    Version 2, December 2004
 *
 * Copyright (C) 2013-2014 Su Yeol Jeon
 *
 * Everyone is permitted to copy and distribute verbatim or modified
 * copies of this license document, and changing it is allowed as long
 * as the name is changed.
 *
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 *
 *  0. You just DO WHAT THE FUCK YOU WANT TO.
 *
 */

import UIKit

@objc public class JLToastView: UIView {
    
    var _backgroundView: UIView?
    var _textLabel: UILabel?
    var _textInsets: UIEdgeInsets?
    
    override init() {
        super.init(frame: CGRectMake(0, 0, 64, 64))
        _backgroundView = UIView(frame: self.bounds)
        _backgroundView!.backgroundColor = UIColor(white: 0, alpha: 0.6)
        _backgroundView!.layer.cornerRadius = 5
        _backgroundView!.clipsToBounds = true
        self.addSubview(_backgroundView!)
        
        _textLabel = UILabel(frame: CGRectMake(0, 0, 64, 64))
        _textLabel!.textColor = UIColor.whiteColor()
        _textLabel!.backgroundColor = UIColor.clearColor()
        _textLabel!.font = UIFont.systemFontOfSize(JLToastViewValue.FontSize)
        _textLabel!.numberOfLines = 0
        _textLabel!.textAlignment = NSTextAlignment.Center;
        self.addSubview(_textLabel!)
        
        _textInsets = UIEdgeInsetsMake(6, 10, 6, 10)
    }
    
    required convenience public init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func updateView() {
        let deviceWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let font = self._textLabel!.font
        let constraintSize = CGSizeMake(deviceWidth * (280.0 / 320.0), CGFloat.max)
        var textLabelSize = self._textLabel!.sizeThatFits(constraintSize)
        self._textLabel!.frame = CGRect(
            x: self._textInsets!.left,
            y: self._textInsets!.top,
            width: textLabelSize.width,
            height: textLabelSize.height
        )
        self._backgroundView!.frame = CGRect(
            x: 0,
            y: 0,
            width: self._textLabel!.frame.size.width + self._textInsets!.left + self._textInsets!.right,
            height: self._textLabel!.frame.size.height + self._textInsets!.top + self._textInsets!.bottom
        )

        var x: CGFloat
        var y: CGFloat
        var width:CGFloat
        var height:CGFloat

        let screenSize = UIScreen.mainScreen().bounds.size
        let backgroundViewSize = self._backgroundView!.frame.size

        let orientation = UIApplication.sharedApplication().statusBarOrientation
        let systemVersion = (UIDevice.currentDevice().systemVersion as NSString).floatValue

        if UIInterfaceOrientationIsLandscape(orientation) && systemVersion < 8.0 {
            width = screenSize.height
            height = screenSize.width
            y = JLToastViewValue.LandscapeOffsetY
        } else {
            width = screenSize.width
            height = screenSize.height
            if UIInterfaceOrientationIsLandscape(orientation) {
                y = JLToastViewValue.LandscapeOffsetY
            } else {
                y = JLToastViewValue.PortraitOffsetY
            }
        }

        x = (width - backgroundViewSize.width) * 0.5
        y = height - (backgroundViewSize.height + y)
        self.frame = CGRectMake(x, y, width, height);
    }
    
    override public func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView? {
        return nil
    }
}
