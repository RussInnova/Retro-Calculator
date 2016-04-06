//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Keith Russell on 3/27/16.
//  Copyright © 2016 Keith Russell. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
        case Clear = "Clear"
    }
    
    @IBOutlet weak var OutputLbl: UILabel!
    var btnSound: AVAudioPlayer!
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOfURL: soundURL)
            btnSound.prepareToPlay()
            } catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    @IBAction func numberPressed (btn: UIButton) {
    playSound()
    runningNumber += "\(btn.tag)"
    OutputLbl.text = runningNumber
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(Operation.Divide)
    }
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(Operation.Subtract)
    }
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }
    @IBAction func onEqualsPressed(sender: AnyObject) {
        processOperation(currentOperation)
    }
    @IBAction func onClearPressed(sender: AnyObject) {
        processOperation(Operation.Clear)
    }

    func processOperation (op: Operation){
        playSound ()
        
        if op == Operation.Clear {
            
            runningNumber = ""
            leftValStr = ""
            rightValStr = ""
            result = ""
            OutputLbl.text = "0"
            currentOperation = Operation.Empty
    
        } else {
            if currentOperation != Operation.Empty {
                //run some math
                if runningNumber != "" {
                    rightValStr = runningNumber
                    runningNumber = ""
                    if currentOperation == Operation.Multiply {
                        result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                    } else if currentOperation == Operation.Divide {
                        result   = "\(Double(leftValStr)! / Double(rightValStr)!)"
                    } else if currentOperation == Operation.Subtract {
                        result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                    } else if currentOperation == Operation.Add {
                        result  = "\(Double(leftValStr)! + Double(rightValStr)!)"
                    }
                    leftValStr = result
                    OutputLbl.text = result
                }
                currentOperation = op
            } else {
                //this is the frst time an operator is pressed
                leftValStr = runningNumber
                runningNumber = ""
                currentOperation = op
            }
        }
    }
    
    func playSound (){
            if btnSound.playing {
                btnSound.stop()
            } else {
                btnSound.play()
            }
        }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

