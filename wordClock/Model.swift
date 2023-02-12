//
//  Model.swift
//  wordClock
//
//  Created by Александр Рахимов on 26.11.2022.
//

import UIKit

class Model: NSObject {
    
    static let model = Model()
    private override init() {
        
    }
    
    //MARK: for first controller prop
    let labelOfWordViews = ["I", "T", ":", "I", "S", "A", "S", "A", "M", "P", "M",
                            "A", "C", "Q", "U", "A", "R", "T", "E", "R", "D", "C",
                            "T", "W", "E", "N", "T", "Y", "F", "I", "V", "E", "X",
                            "H", "A", "L", "F", "B", "T", "E", "N", "F", "T", "O",
                            "P", "A", "S", "T", "E", "R", "U", "N", "I", "N", "E",
                            "O", "N", "E", "S", "I", "X", "T", "H", "R", "E", "E",
                            "F", "O", "U", "R", "F", "I", "V", "E", "T", "W", "O",
                            "E", "I", "G", "H", "T", "E", "L", "E", "V", "E", "N",
                            "S", "E", "V", "E", "N", "T", "W", "E", "L", "V", "E",
                            "T", "E", "N", "S", "E", "O'", "C", "L", "O", "C", "K"]
    
    let labelsOfNomarkMinutesView = Array(repeating: "+", count: 4)
    
    let onePlus = [110]
    let twoPlus = [111]
    let threePlus = [112]
    let fourPlus = [113]
    
    let IndexOfecondsDivision = 2
    
    let itisIndex = [0, 1, 3, 4]
    let amIndex = [7, 8]
    let pmIndex = [9, 10]
    let oneHour = [55, 56, 57]
    let twoHour = [74, 75, 76]
    let threeHour = [61, 62, 63, 64, 65]
    let fourHour = [66, 67, 68, 69]
    let fiveHour = [70, 71, 72, 73]
    let sixHour = [58, 59, 60]
    let sevenHour = [88, 89, 90, 91, 92]
    let eightHour = [77, 78, 79, 80, 81]
    let nineHour = [51, 52, 53, 54]
    let tenHour = [99, 100, 101]
    let elevenHour = [82, 83, 84, 85, 86, 87]
    let twelveHour = [93, 94, 95, 96, 97, 98]
    
    let halfIndex = [33, 34, 35, 36]
    let pastIndex = [44, 45, 46, 47]
    let toIndex = [42, 43]
    
    let fiveMinutes = [28, 29, 30, 31]
    let tenMinutes = [38, 39, 40]
    let fiviteenMinutes = [11, 13, 14, 15, 16, 17, 18, 19]
    let twentyMinutes = [22, 23, 24, 25, 26, 27]
    let twentyfiveMinutes = [22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
    
    let oClock = [104, 105, 106, 107, 108, 109]
    
    let date = Date()
    let dateFormatter = DateFormatter()
    var timeString = ""
    
    var hourInt = 0
    var minutesInt = 0
    var secondsInt = 0
    
    var textColor = UIColor.white
    
    //MARK: For second controller prop
    
    let aboutString = "This watch was made for the enjoyment of people"
    var tapCountForAboutScreen = 0
    
    
    //MARK: for first controller func
    
    func generateStringTime() {

        dateFormatter.dateFormat = "HH:mm:ss"
        timeString = dateFormatter.string(from: Date())
    }
    
    func whatTimeIsIt() -> [Int] {
        
        var resultArray = itisIndex
        let timeArray = timeString.components(separatedBy: ":")
        let hour = timeArray[0]
        let minutes = timeArray[1]
        let seconds = timeArray[2]
        
        guard let temporaryHours = Int(hour), let temporaryMinutes = Int(minutes), let temporarySeconds = Int(seconds) else { return resultArray }
            hourInt = temporaryHours
            minutesInt = temporaryMinutes
            secondsInt = temporarySeconds
        // pm am
        if hourInt >= 12 {
            resultArray += pmIndex
        } else {
            resultArray += amIndex
        }
        //plusMinutes
        resultArray += plusMinutesShow()
        
        if minutesInt < 5 {
            resultArray += transformHoursIntToArrayOfNumbers(param: 0)
            resultArray += oClock
        } else if minutesInt == 30 {
            resultArray += halfIndex + pastIndex
            //hours
            resultArray += transformHoursIntToArrayOfNumbers(param: 0)
        } else if minutesInt < 35 {
            resultArray += pastIndex
            
            switch minutesInt {
            case 31...34: resultArray += halfIndex
            default: break
            }
            //minutes
            var resultMinutes = [Int]()
            switch minutesInt {
            case 5...9: resultMinutes = fiveMinutes
            case 10...14: resultMinutes = tenMinutes
            case 15...19: resultMinutes = fiviteenMinutes
            case 20...24: resultMinutes = twentyMinutes
            case 25...29: resultMinutes = twentyfiveMinutes
            default: break
            }
            resultArray += resultMinutes
            //hours
            resultArray += transformHoursIntToArrayOfNumbers(param: 0)
        } else {
            resultArray += toIndex
            //minutes
            var resultMinutes = [Int]()
            switch minutesInt {
            case 55...59: resultMinutes = fiveMinutes
            case 50...54: resultMinutes = tenMinutes
            case 45...49: resultMinutes = fiviteenMinutes
            case 40...44: resultMinutes = twentyMinutes
            case 35...39: resultMinutes = twentyfiveMinutes
            default: break
            }
            resultArray += resultMinutes
            //hours
            resultArray += transformHoursIntToArrayOfNumbers(param: 1)
        }
        
        return resultArray
    }
    // for hours
    private func transformHoursIntToArrayOfNumbers(param: Int) -> [Int] {
        
        var resultHoursArray = [Int]()
        
        switch hourInt + param {
        case 1, 13: resultHoursArray = oneHour
        case 2, 14: resultHoursArray = twoHour
        case 3, 15: resultHoursArray = threeHour
        case 4, 16: resultHoursArray = fourHour
        case 5, 17: resultHoursArray = fiveHour
        case 6, 18: resultHoursArray = sixHour
        case 7, 19: resultHoursArray = sevenHour
        case 8, 20: resultHoursArray = eightHour
        case 9, 21: resultHoursArray = nineHour
        case 10, 22: resultHoursArray = tenHour
        case 11, 23: resultHoursArray = elevenHour
        case 12, 0: resultHoursArray = twelveHour
        default: break
        }
        
        return resultHoursArray
    }
    //plusMinutesShow
    private func plusMinutesShow() -> [Int] {
        
        var resultOfPlus = [Int]()
        
        switch minutesInt {
        case 1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56: resultOfPlus = onePlus
        case 2, 7, 12, 17, 22, 27, 32, 37, 42, 47, 52, 57: resultOfPlus = onePlus + twoPlus
        case 3, 8, 13, 18, 23, 28, 33, 38, 43, 48, 53, 58: resultOfPlus = onePlus + twoPlus + threePlus
        case 4, 9, 14, 19, 24, 29, 34, 39, 44, 49, 54, 59: resultOfPlus = onePlus + twoPlus + threePlus + fourPlus
        default: break
        }
        return resultOfPlus
    }
}
