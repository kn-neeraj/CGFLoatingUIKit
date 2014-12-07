//  CGFloatTextView.swift
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

class CGFloatTextView: UITextView {

    // MARK: Instance variables
    var placeholderText:String = ""  {
        didSet {
            self.placeHolderLabel.text = placeholderText
            self.adjustPlaceholderFrame()
        }
    }
    
    override var font: UIFont! {
        didSet {
            self.placeHolderLabel.font = font
            self.floatingLabel.font = font
        }
    }
    
    override var textColor: UIColor! {
        didSet {
            self.placeHolderLabel.textColor = textColor
            self.floatingLabel.textColor = textColor
        }
    }
    
    private var placeHolderLabel:UILabel
    
    // MARK: FLoatLabel constants.
    
    var floatingLabelText:String = "" {
        didSet {
            self.floatingLabel.text = floatingLabelText
            self.adjustFloatingHolderFrame()
        }
    }
    
    // MARK: Animation constants.
    var animationTime:NSTimeInterval = 0.3
    var floatingLabelOffset:CGFloat  = 10.0
    


     private var floatingLabel:UILabel
     private var floatingLabelState:Bool = false
    
    
    // MARK: Delegate
    weak var textViewDelegate: UITextViewDelegate?

    // MARK: Initializers
    required init(coder aDecoder: NSCoder) {
        self.placeHolderLabel = UILabel(frame: CGRectZero)
        self.floatingLabel = UILabel(frame: CGRectZero)
        super.init(coder: aDecoder)
        self.commonInitializer()
    }
    
    override init(frame: CGRect) {
        self.placeHolderLabel = UILabel(frame: CGRectZero)
        self.floatingLabel = UILabel(frame: CGRectZero)
        super.init(frame: frame)
        self.commonInitializer()
    }
    
    override init() {
        self.placeHolderLabel = UILabel(frame: CGRectZero)
        self.floatingLabel = UILabel(frame: CGRectZero)
        super.init()
        self.commonInitializer()
    }
    
}

private extension CGFloatTextView {
    func commonInitializer() {
        self.addSubview(self.placeHolderLabel)
        self.sendSubviewToBack(self.placeHolderLabel)
        self.addSubview(self.floatingLabel)
        self.sendSubviewToBack(self.floatingLabel)
        self.delegate = self
        self.placeHolderLabel.font = self.font
        self.placeHolderLabel.textColor = self.textColor
        self.floatingLabel.alpha = 0.0
        self.clipsToBounds = false
    }
    
    func handleTextChanged() {
        if (countElements(self.text) == 0) {
            self.placeHolderLabel.text = self.placeholderText
        }
        else {
            self.placeHolderLabel.text = ""
        }
    }
    
    func adjustPlaceholderFrame() {
        let oldFrame = self.placeHolderLabel.frame
        let textFieldBounds:CGRect = self.bounds
        let placeholderLabelReqSize:CGSize = self.placeHolderLabel.sizeThatFits(CGSizeMake(textFieldBounds.width, textFieldBounds.height))
        self.placeHolderLabel.frame = CGRectMake(2.7, 5.0, placeholderLabelReqSize.width, placeholderLabelReqSize.height)
    }
    
    func adjustFloatingHolderFrame() {
        let oldFrame = self.floatingLabel.frame
        let textFieldBounds:CGRect = self.bounds
        let floatingLabelReqSize:CGSize = self.floatingLabel.sizeThatFits(CGSizeMake(textFieldBounds.width, textFieldBounds.height))
        self.floatingLabel.frame = CGRectMake(2.7, 5.0, floatingLabelReqSize.width, floatingLabelReqSize.height)
    }
    
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

}


extension CGFloatTextView:UITextViewDelegate {
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if let uwTextFieldDelegate = self.textViewDelegate {
            return uwTextFieldDelegate.textViewShouldBeginEditing!(textView)
        }
        else {
            return true
        }
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        self.handleTextChanged()
        if let uwTextFieldDelegate = self.textViewDelegate {
            return uwTextFieldDelegate.textViewShouldEndEditing!(textView)
        }
        else {
            return true
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.placeHolderLabel.text = ""
        if  countElements(textView.text) > 0 && !self.floatingLabelState {
            self.editingBeginAnimation()
        }
        if let uwTextFieldDelegate = self.textViewDelegate {
            uwTextFieldDelegate.textViewDidBeginEditing!(textView)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if self.floatingLabelState {
            self.editingEndAnimation()
        }
        if let uwTextFieldDelegate = self.textViewDelegate {
             uwTextFieldDelegate.textViewDidEndEditing!(textView)
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if  countElements(text) > 0 && !self.floatingLabelState {
            self.editingBeginAnimation()
        }
        if let uwTextFieldDelegate = self.textViewDelegate {
            return uwTextFieldDelegate.textView!(textView, shouldChangeTextInRange: range, replacementText: text)
        }
        else {
            return true
        }
    }
    
    func textViewDidChange(textView: UITextView) {
          self.handleTextChanged()
        if let uwTextFieldDelegate = self.textViewDelegate {
             uwTextFieldDelegate.textViewDidChange!(textView)
        }
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if let uwTextFieldDelegate = self.textViewDelegate {
             uwTextFieldDelegate.textViewDidChangeSelection!(textView)
        }
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        if let uwTextFieldDelegate = self.textViewDelegate {
            return uwTextFieldDelegate.textView!(textView, shouldInteractWithURL: URL, inRange: characterRange)
        }
        else {
            return true
        }
    }
    
    func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        if let uwTextFieldDelegate = self.textViewDelegate {
            return uwTextFieldDelegate.textView!(textView, shouldInteractWithTextAttachment: textAttachment, inRange: characterRange)
        }
        else {
            return true
        }
    }

}
