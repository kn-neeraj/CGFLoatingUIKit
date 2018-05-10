//
//  ViewController.swift
//  CGFloatLabelUITextKit
//
//  Created by Neeraj Kumar on 07/12/14.
//  Copyright (c) 2014 Neeraj Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: CGFloatTextField!
    
    @IBOutlet weak var middleNameTextField: CGFloatTextField!
    
    @IBOutlet weak var lastNameTextField: CGFloatTextField!
    
    @IBOutlet weak var floatTextView: CGFloatTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.firstNameTextField.floatingLabelText = "First Name"
        self.firstNameTextField.floatingLabelFontColor = UIColor.blue
        self.firstNameTextField.floatingLabelFont = UIFont.systemFont(ofSize: 15)
        
        self.middleNameTextField.floatingLabelText = "Middle Name"
        self.middleNameTextField.floatingLabelFontColor = UIColor.green
        self.middleNameTextField.animationTime = 1.0
        self.middleNameTextField.floatingLabelOffset = 20.0
        
        self.lastNameTextField.floatingLabelText = "Last Name"
        self.lastNameTextField.animationTime = 0.5
        
        
        self.floatTextView.placeholderText = "Enter text here"
        
        self.floatTextView.floatingLabelText = "Enter text here"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

