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
    var attributedPlaceHolder: NSMutableAttributedString {
        didSet {
            self.attributedPlaceholder = attributedPlaceHolder
        }
    }
    
    // MARK: Animation constants.
    var animationTime:TimeInterval = 0.3
    var floatingLabelOffset:CGFloat  = 12.0
    
    // MARK: Delegate
    weak var textFieldDelegate: UITextFieldDelegate?
    
    // MARK: Private instance variables.
    private var floatingLabel:UILabel
    private var floatingLabelState:Bool
    
    private var floatingLabelShownFrame: CGRect
    private var floatingLabelHiddenFrame: CGRect
    private var attributedPlaceHolderEmpty: NSMutableAttributedString = NSMutableAttributedString(string: "")
    
    required init?(coder aDecoder: NSCoder) {
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.floatingLabel.alpha = 0.0
        self.floatingLabelText = ""
        
        self.floatingLabelFont = UIFont.systemFont(ofSize: 12.0)
        self.floatingLabelFontColor = UIColor.blue
        self.floatingLabelState = false
        
        self.floatingLabelShownFrame = CGRect.zero
        self.floatingLabelHiddenFrame = CGRect.zero
        self.attributedPlaceHolder = NSMutableAttributedString()
        
        super.init(coder: aDecoder)
        self.addSubview(self.floatingLabel)
        self.sendSubview(toBack: self.floatingLabel)
        self.delegate = self
        self.clipsToBounds = false
        self.floatingLabel.frame = CGRect(x: 0, y: self.frame.height / 2, width: CGRect.zero.width, height: CGRect.zero.height)
    }
    
    override init(frame: CGRect) {
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.floatingLabel.alpha = 0.0
        self.floatingLabelText = ""
        
        self.floatingLabelFont = UIFont.systemFont(ofSize: 12.0)
        self.floatingLabelFontColor = UIColor.blue
        self.floatingLabelState = false
        
        self.floatingLabelShownFrame = CGRect.zero
        self.floatingLabelHiddenFrame = CGRect.zero
        self.attributedPlaceHolder = NSMutableAttributedString()
        
        super.init(frame: frame)
        self.addSubview(self.floatingLabel)
        self.sendSubview(toBack: self.floatingLabel)
        self.delegate = self
        self.clipsToBounds = false
        self.floatingLabel.frame = CGRect(x: 0, y: self.frame.height / 2, width: CGRect.zero.width, height: CGRect.zero.height)
    }
    
}

// MARK: Private Extension

private extension CGFloatTextField {
    func editingBeginAnimation() {
        self.attributedPlaceholder = self.attributedPlaceHolderEmpty
        UIView.animate(withDuration: self.animationTime, animations: { () -> Void in
            if self.floatingLabelShownFrame.isEmpty {
                let oldFrame = self.floatingLabel.frame
                self.floatingLabelShownFrame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y - (self.floatingLabelOffset + oldFrame.height), width: oldFrame.width, height: oldFrame.height)
            }
            self.floatingLabel.frame = self.floatingLabelShownFrame
            self.floatingLabel.alpha = 1.0
            self.floatingLabelState = true
        })
    }
    
    func editingEndAnimation() {
        UIView.animate(withDuration: self.animationTime, animations: {
            if self.floatingLabelHiddenFrame.isEmpty {
                let oldFrame = self.floatingLabel.frame
                self.floatingLabelHiddenFrame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y + (self.floatingLabelOffset + oldFrame.height), width: oldFrame.width, height: oldFrame.height)
            }
            self.floatingLabel.frame = self.floatingLabelHiddenFrame
            self.floatingLabel.alpha = 0.0;
            self.floatingLabelState = false
        }) { (result) in
            if result == true {
                self.attributedPlaceholder = self.attributedPlaceHolder
            }
        }
    }
    
    func adjustFloatingLabelFrame() {
        let oldFrame = self.floatingLabel.frame
        let textFieldBounds:CGRect = self.bounds
        let floatingLabelReqSize: CGSize = self.floatingLabel.sizeThatFits(CGSize(width: textFieldBounds.width, height: textFieldBounds.height))
        if (self.floatingLabelState) {
            self.floatingLabel.frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: floatingLabelReqSize.width, height: floatingLabelReqSize.height)
        }
        else {
            self.floatingLabel.frame = CGRect(x: oldFrame.origin.x, y: self.frame.size.height / 2 - floatingLabelReqSize.height / 2, width: floatingLabelReqSize.width, height: floatingLabelReqSize.height)
        }
    }
}


// MARK: UITextFieldDelegate Methods extension
extension CGFloatTextField:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var result: Bool = false
        if let uwTextfieldDelegate = self.textFieldDelegate {
            result = uwTextfieldDelegate.textFieldShouldBeginEditing!(textField)
        } else {
            result = true
        }
        
        if result == true {
            self.editingBeginAnimation()
        }
        return result
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if  textField.text!.count > 0 && !self.floatingLabelState {
            self.editingBeginAnimation()
        }
        if let uwTextfieldDelegate = self.textFieldDelegate {
            uwTextfieldDelegate.textFieldDidBeginEditing!(textField)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let uwTextfieldDelegate = self.textFieldDelegate {
            return uwTextfieldDelegate.textFieldShouldEndEditing!(textField)
        }
        else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = self.text else {
            return
        }
        
        if text.count == 0 {
            if self.floatingLabelState {
                self.editingEndAnimation()
            }
            if let uwTextfieldDelegate = self.textFieldDelegate {
                uwTextfieldDelegate.textFieldDidBeginEditing!(textField)
            }
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if  string.count > 0 && !self.floatingLabelState {
            self.editingBeginAnimation()
        }
        if let uwTextfieldDelegate = self.textFieldDelegate {
            return uwTextfieldDelegate.textField!(textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        else {
            return true
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if let uwTextfieldDelegate = self.textFieldDelegate {
            return uwTextfieldDelegate.textFieldShouldClear!(textField)
        }
        else {
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let uwTextfieldDelegate = self.textFieldDelegate {
            return uwTextfieldDelegate.textFieldShouldReturn!(textField)
        }
        else {
            return true
        }
    }
}
