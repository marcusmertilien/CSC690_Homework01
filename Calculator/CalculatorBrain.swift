import Foundation

struct CalculatorBrain {
    
    var accumulator: Double?
    var decimalFlag = false
    
    private var currentPendingBinaryOperation: PendingBinaryOperation?
    
    enum Operation {
        case constant(Double)
        case unaryOperation( (Double) -> Double )
        case binareOperation( (Double,Double) -> Double )
        case equals
        case decimal
    }
    
    
    var operations: [String: Operation] = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),
        "tan": Operation.unaryOperation(tan),
        "log": Operation.unaryOperation(log),
        "x^2": Operation.unaryOperation() {
            return $0 * $0
        },
        "x^3": Operation.unaryOperation( {
            return $0 * $0 *  $0
        }),
        
        "=": Operation.equals,
        
        
        "10^x": Operation.unaryOperation({
            var returnVal = 1.0;
            var count = 0.0;
            
            while (count < $0)
            {
                returnVal = returnVal * 10
                count += 1;
            }
            return returnVal;
        }),
        "sec": Operation.unaryOperation({
            return (1/cos($0))
        }),
        "csc": Operation.unaryOperation({
            return (1/sin($0))
        }),
        "cot": Operation.unaryOperation({
            return (1/tan($0))
        }),
        "+/-": Operation.unaryOperation({
            return ($0 * -1)
        }),
        ".": Operation.decimal,
        
        
        
        "*": Operation.binareOperation({ $0 * $1 }),
        "/": Operation.binareOperation({ $0 / $1 }),
        "-": Operation.binareOperation({ $0 - $1 }),
        "+": Operation.binareOperation({ $0 + $1 })
        
        
        
    ]
    
    mutating func performOperation(_ mathematicalSymbol: String) {
        if let operation = operations[mathematicalSymbol] {
            switch operation {
            case Operation.constant(let value):
                accumulator = value
            case Operation.unaryOperation(let function):
                if let value = accumulator {
                    accumulator = function(value)
                }
            case .binareOperation(let function):
                if let firstOperand = accumulator {
                    currentPendingBinaryOperation = PendingBinaryOperation(firstOperand: firstOperand, function: function)
                    accumulator = nil
                }
            case .equals:
                perfomrBinaryOperation()
            case .decimal:
                if let source = accumulator {
                   decimalFlag = performDecimalCheck(source: String (source))
                }
            }
        }
    }
    
    mutating func perfomrBinaryOperation() {
        if let operation = currentPendingBinaryOperation, let secondOperand = accumulator {
            accumulator = operation.perform(secondOperand: secondOperand)
        }
    }
    mutating func performDecimalCheck(source: String)->Bool{
        //Check for Decimal in existing string
        if(source == "0.0"){
            
            return true;
        }
        else if source.contains("."){
            decimalFlag = true;
            return true;
        }else{
            return false
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    private struct PendingBinaryOperation {
        let firstOperand: Double
        let function: (Double, Double) -> Double
        
        func perform(secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    mutating func reset (){
        accumulator = 0
        decimalFlag = false
    }
    
    func getDecimalFlag() -> Bool{
        return decimalFlag
    }
    mutating func setDecimalFlag(){
        decimalFlag = true
    }
    
    
    
}
