import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var brain = CalculatorBrain()
    
    var userIsCurrentlyTyping = false
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        let buttonText = sender.currentTitle!
        
        if userIsCurrentlyTyping {
            let currentText = display.text!
            display.text = currentText + buttonText
        } else {
            display.text = buttonText
            userIsCurrentlyTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }

    @IBAction func operationButtonPressed(_ sender: UIButton){
        userIsCurrentlyTyping = false
        brain.setOperand(displayValue)
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
    
    @IBAction func clearButton(_ sender: Any) {
        display.text = "0"
        brain.reset()
        //decimalFlag = brain.performDecimalCheck(source: display.text!)
    }

    @IBAction func decimalButton(_ sender: Any) {
        if (!(brain.performDecimalCheck(source: display.text!))){
            display.text = display.text! + "."
            brain.setDecimalFlag()
        }
    }
    
}
