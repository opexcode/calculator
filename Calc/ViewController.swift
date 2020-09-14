import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var displayLabel: UILabel!
    
    
    // MARK: - Properties
    
    var firstOperand: String?
    var secondOperand: String?
    var operatorSign = ""
    
    var userTyping = false
    var separator = false
    var continueСalculation = false
    var equalButtonPressed = false
    
    var display = "0" {
        didSet {
            // Дисплей моргает при повторении вывода
            if displayLabel.text == display && userTyping {
                displayLabel.blink()
            }
            displayLabel.text = display
        }
    }
    
    
    // MARK: - Lifecircle
    
    override func viewDidLoad() {
        setCorrectionSwipe()
    }
    
    
    // MARK: - Methods
    
    private func setCorrectionSwipe() {
        let leftCorrectSwipe = UISwipeGestureRecognizer(target: self, action: #selector(inputCorrection))
        let rightCorrectSwipe = UISwipeGestureRecognizer(target: self, action: #selector(inputCorrection))
        
        leftCorrectSwipe.direction = UISwipeGestureRecognizer.Direction.left
        rightCorrectSwipe.direction = UISwipeGestureRecognizer.Direction.right
        
        displayLabel.isUserInteractionEnabled = true
        displayLabel.addGestureRecognizer(leftCorrectSwipe)
        displayLabel.addGestureRecognizer(rightCorrectSwipe)
    }
    
    @objc
    func inputCorrection(sender: UITapGestureRecognizer) {
        let length = display.count
        guard let displayValue = Decimal(string: display) else { return }
        
        if length == 1 || (display == "0.") || (display == "-0")
            || (displayValue < 0 && length == 2) {
            display = "0"
            userTyping = false
            separator = false
        } else {
            // Стираем последний символ свайпом
            let lastSimbol = display.last
            
            if lastSimbol == "." {
                separator = false
            }
            
            let simbol = display.dropLast()
            display = String(simbol)
        }
    }
    
    func clearAll() {
        firstOperand = nil
        secondOperand = nil
        operatorSign = ""
        userTyping = false
        separator = false
        continueСalculation = false
        equalButtonPressed = false
    }
    
    func showResult() {
        var result: Decimal = 0.0
        
        if let first = firstOperand, let second = secondOperand {
            
            if let decimalFirst = Decimal(string: first),
                let decimalSecond = Decimal(string: second) {
                switch operatorSign {
                case "÷":
                    result = decimalFirst / decimalSecond
                case "×":
                    result = decimalFirst * decimalSecond
                case "-":
                    result = decimalFirst - decimalSecond
                case "+":
                    result = decimalFirst + decimalSecond
                default:
                    break
                }
                
                if operatorSign == "÷" && result.isNaN  {
                    display = "Ошибка"
                    clearAll()
                } else {
                    display = "\(result)"
                }
            }
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func clearButton(_ sender: UIButton) {
        sender.flash()
        display = "0"
        clearAll()
    }
    
    @IBAction func mathSignInverseButton(_ sender: UIButton) {
        sender.flash()
        
        guard let displayValue = Decimal(string: display) else { return }
        if Decimal(string: display)! == 0 {
            
            // Форматируем строковый ввод типа "-0.0000"
            if display.first == "-" {
                display = String(display.dropFirst())
            } else {
                display = "-\(display)"
            }
        } else {
            display = "\(-displayValue)"
        }
        
        secondOperand = display
    }
    
    @IBAction func percentButton(_ sender: UIButton) {
        sender.flash()
        
        if equalButtonPressed {
            firstOperand = nil
        }
        
        if let display = Decimal(string: display) {
            
            if firstOperand == nil {
                self.display = "\(display / 100)"
            } else {
                guard let decimalFirst = Decimal(string: firstOperand!) else { return }
                secondOperand = "\(decimalFirst * display / 100)"
                self.display = secondOperand!
            }
        }
        
        userTyping = false
    }
    
    @IBAction func digitButtons(_ sender: UIButton) {
        sender.flash()
        
        if let count = Decimal(string: display) {
            
            // при отрицательном значении добавляем дополнительный символ на display
            let inputLimit = (count < 0) ? 10 : 9
            
            if let digit = sender.currentTitle {
                
                if (userTyping && display != "0") {
                    if display.count < inputLimit {
                        display = display + digit
                    }
                } else {
                    display = digit
                    userTyping = true
                }
            }
        }
        
        continueСalculation = true
    }
    
    @IBAction func operationButtons(_ sender: UIButton) {
        sender.flash()
        
        if equalButtonPressed {
            clearAll()
        }
        
        if continueСalculation {
            secondOperand = display
            showResult()
        }
        
        if let mathOperator = sender.currentTitle {
            operatorSign = mathOperator
        }
        
        firstOperand = display
        userTyping = false
        continueСalculation = false
        separator = false
    }
    
    @IBAction func equalityButton(_ sender: UIButton) {
        sender.flash()
        
        if userTyping {
            secondOperand = display
        }
        
		if operatorSign != "" {
			showResult()
		}
		
        firstOperand = display
        userTyping = false
        continueСalculation = false
        equalButtonPressed = true
    }
    
    @IBAction func separatorButton(_ sender: UIButton) {
        sender.flash()
        
        if !separator {
            display = userTyping ? (display + ".") : "0."
            userTyping = true
            separator = true
        }
    }
    
}

