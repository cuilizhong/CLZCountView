//
//  CLZCountView.swift
//  swift_tableView
//
//  Created by clz on 16/4/17.
//  Copyright © 2016年 CLZ. All rights reserved.
//

import UIKit

typealias DownBlock = (count:NSInteger) -> Void

typealias UpBlock = (count:NSInteger) -> Void

typealias TipErrorBlock = (errorMessage:NSString) -> Void

class CLZCountView: UIView,UITextFieldDelegate {
    
    var downBlock:DownBlock?
    
    var upBlock:UpBlock?
    
    var tipErrorBlock:TipErrorBlock?
    
    var tipUpLimitErrorMessage:NSString?
    
    var tipDownLimitErrorMessage:NSString?
    
    var count:NSInteger = 0
    
    var upLimit:NSInteger = 0
    
    var downLimit:NSInteger = 0
    
    var textField:UITextField?
    
    convenience init(frame: CGRect,tipUpLimitErrorMessage:NSString,tipDownLimitErrorMessage:NSString,count:NSInteger,upLimit:NSInteger,downLimit:NSInteger,downBlock:DownBlock,upBlock:UpBlock,tipErrorBlock:TipErrorBlock) {
        
        self.init(frame: frame)
        
        self.initUI(frame.size.width/3.0, height: frame.size.height)

        self.tipUpLimitErrorMessage = tipUpLimitErrorMessage
        
        self.tipDownLimitErrorMessage = tipDownLimitErrorMessage
        
        self.count = count
        
        self.upLimit = upLimit
        
        self.downLimit = downLimit
        
        self.downBlock = downBlock
        
        self.upBlock = upBlock
        
        self.tipErrorBlock = tipErrorBlock
        
        self.textField!.text = String(count)
        
    }
    
    override func awakeFromNib() {
        
        let viewWidth:CGFloat = self.frame.size.width / 3.0
        
        let viewHeight:CGFloat = self.frame.size.height
        
        self.initUI(viewWidth, height: viewHeight)
        
     }
    
    func handTextField(textField:UITextField){
        
        textField.delegate = self;
        
        textField.font = UIFont.systemFontOfSize(14)
        
        textField.textAlignment = NSTextAlignment.Center
        
        textField.borderStyle = UITextBorderStyle.None
        
        textField.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        textField.layer.borderWidth = 0.5
        
        textField.keyboardType = UIKeyboardType.NumberPad
        
        textField.delegate = self;
        
    }
    
    func setDownButton(downButton:UIButton){
        
        downButton.setImage(UIImage.init(named: "icon_des_jian"), forState: UIControlState.Normal)
        
        downButton.addTarget(self, action:#selector(self.downButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func setUpButton(upButton:UIButton){
        
        upButton.setImage(UIImage.init(named: "icon_add_jia"), forState: UIControlState.Normal)
        
        upButton.addTarget(self, action: #selector(self.upButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func downButtonAction(sender:AnyObject){
        
        self.textField?.resignFirstResponder()
        
        let tmp = count - 1
        
        if tmp < downLimit {
            
            tipErrorBlock!(errorMessage:tipDownLimitErrorMessage!)
            
        }else{
            
            count = tmp
            
            textField!.text = String(count)
            
            upBlock!(count:count)
        }
        
    }
    
    func upButtonAction(sender:AnyObject){
        
        self.textField?.resignFirstResponder()
        
        let tmp = count + 1
        
        if tmp > upLimit{
            
            tipErrorBlock!(errorMessage:tipUpLimitErrorMessage!)
            
        }else{
            
            count = tmp
            
            textField!.text = String(count)
            
            downBlock!(count:count)
            
        }
    }
    
    func initUI(width:CGFloat,height:CGFloat) {
        
        let downButton:UIButton = UIButton.init(frame: CGRectMake(0, 0, width, height))
        
        self.addSubview(downButton)
        
        self.setDownButton(downButton)
        
        
        textField = UITextField.init(frame: CGRectMake(width, 0, width, height))
        
        self.handTextField(textField!)
        
        self.addSubview(textField!)
        
        
        let upButton:UIButton = UIButton.init(frame: CGRectMake(width*2, 0, width, height))
        
        self.setUpButton(upButton)
        
        self.addSubview(upButton)
    }
    
    func showCountView(tipUpLimitErrorMessage:NSString,tipDownLimitErrorMessage:NSString,count:NSInteger,upLimit:NSInteger,downLimit:NSInteger,downBlock:DownBlock,upBlock:UpBlock,tipErrorBlock:TipErrorBlock){
        
        textField!.text = String(count)
        
        self.tipUpLimitErrorMessage = tipUpLimitErrorMessage
        
        self.tipDownLimitErrorMessage = tipDownLimitErrorMessage
        
        self.count = count
        
        self.upLimit = upLimit
        
        self.downLimit = downLimit
        
        self.downBlock = downBlock
        
        self.upBlock = upBlock
        
        self.tipErrorBlock = tipErrorBlock
    }
    
    
    
    //TODO:UITextFieldDelegate
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.text?.characters.count < 1 {
            
            textField.text = String(self.downLimit)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let predictionString:String = textField.text! + string
        
        if Int(predictionString) > self.upLimit {
            
            tipErrorBlock!(errorMessage:tipUpLimitErrorMessage!)
            
            
            return false
        }
        
        count = Int(predictionString)!
        
        return true
    }
    
    
    
    
    

}
