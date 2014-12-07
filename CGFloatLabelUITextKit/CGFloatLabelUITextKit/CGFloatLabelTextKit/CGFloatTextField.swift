//  CGFloatTextField.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) Neeraj Kumar
//  Original Concept by Matt D. Smith
//  http://dribbble.com/shots/1254439--GIF-Mobile-Form-Interaction?list=users
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import UIKit

class CGFloatTextField: UITextField {
    
    //MARK: Internal instance variables.
    
    //MARK: FloatText constants.
    
    var floatingLabelText:String {
        didSet {
            self.floatingLabel.text = floatingLabelText
            self.adjustFloatingLabelFrame()
        }
    }
    var floatingLabelFont:UIFont {
        didSet {
            self.floatingLabel.font = floatingLabelFont
            self.adjustFloatingLabelFrame()
        }
    }
    var floatingLabelFontColor:UIColor {
        didSet {
            self.floatingLabel.textColor = floatingLabelFontColor
        }
    }

    // MARK: Animation constants.
    var animationTime:NSTimeInterval = 0.3
    var floatingLabelOffset:CGFloat  = 10.0
    
    // MARK: Delegate
    weak var textFieldDelegate: UITextFieldDelegate?
    
    // MARK: Private instance variables.
    private var floatingLabel:UILabel
    private var floatingLabelState:Bool
    
    

    required init(coder aDecoder: NSCoder) {
        self.floatingLabel = UILabel(frame: CGRectZero)
        self.floatingLabel.alpha = 0.0
        self.floatingLabelText = ""
        
        self.floatingLabelFont = UIFont.systemFontOfSize(12.0)
        self.floatingLabelFontColor = UIColor.blueColor()
        self.floatingLabelState = false
        
        super.init(coder: aDecoder)
        self.addSubview(self.floatingLabel)
        self.sendSubviewToBack(self.floatingLabel)
        self.delegate = self
        self.clipsToBounds = false
        self.floatingLabel.frame = CGRectMake(0, CGRectGetHeight(self.frame)/2.0, CGRectZero.width, CGRectZero.height)
    }
    
    override init(frame: CGRect) {
        self.floatingLabel = UILabel(frame: CGRectZero)
        self.floatingLabel.alpha = 0.0
        self.floatingLabelText = ""
        
        self.floatingLabelFont = UIFont.systemFontOfSize(12.0)
        self.floatingLabelFontColor = UIColor.blueColor()
        self.floatingLabelState = false
        super.init(frame: frame)
        self.addSubview(self.floatingLabel)
        self.sendSubviewToBack(self.floatingLabel)
        self.delegate = self
        self.clipsToBounds = false
        self.floatingLabel.frame = CGRectMake(0, CGRectGetHeight(self.frame)/2.0, CGRectZero.width, CGRectZero.height)
    }
    
    override init() {
        self.floatingLabel = UILabel(frame: CGRectZero)
        self.floatingLabel.alpha = 0.0
        self.floatingLabelText = ""
        
        self.floatingLabelFont = UIFont.systemFontOfSize(12.0)
        self.floatingLabelFontColor = UIColor.blueColor()
        self.floatingLabelState = false
        
        
        super.init()
        self.addSubview(self.floatingLabel)
        self.sendSubviewToBack(self.floatingLabel)
        self.delegate = self
        self.clipsToBounds = false
        self.floatingLabel.frame = CGRectMake(0, CGRectGetHeight(self.frame)/2.0, CGRectZero.width, CGRectZero.height)    }
    
}

// MARK: Private Extension

private extension CGFloatTextField {
    func editingBeginAnimation() {
        UIView.animateWithDuration(self.animationTime, animations: { () -> Void in
            let oldFrame = self.floatingLabel.frame
           self.floatingLabel.frame = CGRectMake(oldFrame.origin.x,oldFrame.origin.y - (self.floatingLabelOffset + CGRectGetHeight(oldFrame)) , CGRectGetWidth(oldFrame), CGRectGetHeight(oldFrame))
           self.floatingLabel.alpha = 1.0
            self.floatingLabelState = true
        });
    }
    
    func editingEndAnimation() {
        UIView.animateWithDuration(self.animationTime, animations: { () -> Void in
            let oldFrame = self.floatingLabel.frame
            self.floatingLabel.frame = CGRectMake(oldFrame.origin.x,oldFrame.origin.y + (self.floatingLabelOffset + CGRectGetHeight(oldFrame)) , CGRectGetWidth(oldFrame), CGRectGetHeight(oldFrame))
            self.floatingLabel.alpha = 0.0;
            self.floatingLabelState = false
        });
    }
    
    func adjustFloatingLabelFrame() {
        let oldFrame = self.floatingLabel.frame
        let textFieldBounds:CGRect = self.bounds
        let floatingLabelReqSize:CGSize = self.floatingLabel.sizeThatFits(CGSizeMake(textFieldBounds.width, textFieldBounds.height))
        if (self.floatingLabelState) {
            self.floatingLabel.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, floatingLabelReqSize.width, floatingLabelReqSize.height)
        }
        else {
            self.floatingLabel.frame = CGRectMake(oldFrame.origin.x, self.frame.size.height/2.0 - floatingLabelReqSize.height/2.0 , floatingLabelReqSize.width, floatingLabelReqSize.height)
        }
    }
}


// MARK: UITextFieldDelegate Methods extension
extension CGFloatTextField:UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if let uwTextfieldDelegate = self.textFieldDelegate {
            return uwTextfieldDelegate.textFieldShouldBeginEditing!(textField)
        }
        else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if  countElements(textField.text) > 0 && !self.floatingLabelState {
            self.editingBeginAnimation()
        }
        if let uwTextfieldDelegate = self.textFieldDelegate {
          uwTextfieldDelegate.textFieldDidBeginEditing!(textField)
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if let uwTextfieldDelegate = self.textFieldDelegate {
            return uwTextfieldDelegate.textFieldShouldEndEditing!(textField)
        }
        else {
            return true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if self.floatingLabelState {
           self.editingEndAnimation()
        }
        if let uwTextfieldDelegate = self.textFieldDelegate {
            uwTextfieldDelegate.textFieldDidBeginEditing!(textField)
        }
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if  countElements(string) > 0 && !self.floatingLabelState {
            self.editingBeginAnimation()
        }
        if let uwTextfieldDelegate = self.textFieldDelegate {
            return uwTextfieldDelegate.textField!(textField, shouldChangeCharactersInRange: range, replacementString: string)
        }
        else {
            return true
        }
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        if let uwTextfieldDelegate = self.textFieldDelegate {
            return uwTextfieldDelegate.textFieldShouldClear!(textField)
        }
        else {
            return false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let uwTextfieldDelegate = self.textFieldDelegate {
            return uwTextfieldDelegate.textFieldShouldReturn!(textField)
        }
        else {
            return true
        }
    }
}
