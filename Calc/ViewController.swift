import UIKit

class ViewController: UIViewController {
	
	// MARK: - IBOutlets
	
	@IBOutlet weak var displayLabel: UILabel!
	
	
	// MARK: - Properties
	
	var firstOperand = 0.0
	var secondOperand = 0.0
	var userTyping = false
	var separator = false
	var operatorSign = ""
	var continueСalculation = false
	var displayValue: Double {
		get {
			var value = 0.0
			if let optionalValue = Double(displayLabel.text!) {
				value = optionalValue
			}
			return value
		}
		set {
			// Если число целое выводим его без точки
			let doubleValue = String(newValue)
			if doubleValue.contains(".") {
				let intValues = doubleValue.components(separatedBy: ".")
				displayLabel.text = (intValues[1] == "0") ? intValues[0] : doubleValue
				userTyping = false
			}
		}
	}
	
	
	// MARK: - Lifecircle
	
	override func viewDidLoad() {
		setCorrectSwipe()
	}
	
	
	// MARK: - Methods
	
	private func setCorrectSwipe() {
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
		if displayLabel.text != "0" || displayLabel.text == "0."  {
			if displayLabel.text?.count == 1 {
				displayLabel.text = "0"
				userTyping = false
			} else {
				// Стираем последний символ свайпом
				displayLabel.text = String(displayLabel.text!.dropLast())
			}
		}
	}
	
	
	func showResult() {
		if userTyping {
			secondOperand = displayValue
		}
		
		switch operatorSign {
			case "÷":
				if secondOperand == 0 {
					displayLabel.text = "Ошибка"
				} else {
					displayValue = firstOperand / secondOperand
			}
			case "×":
				displayValue = firstOperand * secondOperand
			case "-":
				displayValue = firstOperand - secondOperand
			case "+":
				displayValue = firstOperand + secondOperand
			default:
				break
		}
		
		firstOperand = displayValue
		userTyping = false
		separator = false
	}
	
	
	// MARK: - IBActions
	
	@IBAction func clearButton(_ sender: UIButton) {
		displayLabel.text = "0"
		userTyping = false
		separator = false
		continueСalculation = false
		firstOperand = 0.0
		secondOperand = 0.0
		operatorSign = ""
	}
	
	@IBAction func mathSignInverseButton(_ sender: UIButton) {
		if displayValue != 0 {
			displayValue = -displayValue
		}
	}
	
	@IBAction func percentButton(_ sender: UIButton) {
		if firstOperand == 0 {
			displayValue = displayValue / 100
		} else {
			secondOperand = firstOperand * displayValue / 100
			displayValue = secondOperand
		}
		userTyping = false
	}
	
	@IBAction func digitButtons(_ sender: UIButton) {
		let digit = sender.currentTitle!
		
		if userTyping {
			// Ограничиваем количество вводимых символов (до 10)
			// и запрещаем повторять 0
			if (displayLabel.text?.count)! < 10 && displayLabel.text != "0" {
				displayLabel.text = displayLabel.text! + digit
			}
		} else {
			displayLabel.text = digit
			userTyping = true
		}
	}
	
	@IBAction func operationButtons(_ sender: UIButton) {
		// Выводим промежуточный результат
		if continueСalculation {
			showResult()
		}
		
		if let mathOperator = sender.currentTitle {
			operatorSign = mathOperator
		}
		
		userTyping = false
		separator = false
		firstOperand = displayValue
		continueСalculation = true
	}
	
	@IBAction func equalityButton(_ sender: UIButton) {
		showResult()
		continueСalculation = false
	}
	
	@IBAction func separatorButton(_ sender: UIButton) {
		if !separator {
			displayLabel.text = userTyping ? (displayLabel.text! + ".") : "0."
			userTyping = true
			separator = true
		}
	}
	
}




