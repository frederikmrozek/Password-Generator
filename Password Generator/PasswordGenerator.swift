//
//  PasswordGenerator.swift
//  Password Generator
//
//  Created by Frederik Mrozek on 19.12.21.
//

import Foundation
import AppKit

struct ContainCharacterSelection {
    var containNumbers: Bool = true
    var containLowerCharacters: Bool = true
    var containUpperCharacters: Bool = true
    var containSpecialCharacters: Bool = true
    var containComplicatedCharacters: Bool = false
}

class PasswordGenerator {
    
    let numbers = ["0","1","2","3","4","5","6","7","8","9"]
    let lowerCharacters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    let upperCharacters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    let specialCharacters = ["!","\"","§","$","%","&","/","(",")","=","?","+","*","#",",",";",".",":","-","_","@","<",">"]
    let complicatedCharacters = ["^","[","]","{","}","\\","'","`","´"]
    
    func generatePassword(lenght: Int, containCharaterSelection: ContainCharacterSelection) -> String {
        
        let characterSelection: [String] = createCharacterSelection(containCharaterSelection: containCharaterSelection)
        
        var password: String = ""
        
        for _ in 0..<lenght {
            password.append(characterSelection.randomElement() ?? "")
        }
        
        return password
    }
    
    func createCharacterSelection(containCharaterSelection: ContainCharacterSelection) -> [String] {
        
        var characterSelection: [String] = []
        
        if containCharaterSelection.containNumbers {
            characterSelection.append(contentsOf: numbers)
        }
        if containCharaterSelection.containLowerCharacters {
            characterSelection.append(contentsOf: lowerCharacters)
        }
        if containCharaterSelection.containUpperCharacters {
            characterSelection.append(contentsOf: upperCharacters)
        }
        if containCharaterSelection.containSpecialCharacters {
            characterSelection.append(contentsOf: specialCharacters)
        }
        if containCharaterSelection.containComplicatedCharacters {
            characterSelection.append(contentsOf: complicatedCharacters)
        }
        
        return characterSelection
    }
    
    func getStrength(password: String) -> Int {
        var strength: Double = 100.0
        
        // Length of password
        strength = strength*doLengthCheck(password: password)
        
        // Selection of password
        strength = strength*doSelectionCheck(password: password)
        
        // Diversity of password
        strength = strength*doDiversityCheck(password: password)
        
        return Int(strength)
    }
    
    func doLengthCheck(password: String) -> Double {
        return Double(password.count)/20.0
    }
    
    func doSelectionCheck(password: String) -> Double {
        var containsNumbers: Bool = false
        var containsLowerCharacters: Bool = false
        var containsUpperCharacters: Bool = false
        var containsSpecialCharacters: Bool = false
        var containsComplicatedCharacters: Bool = false
        
        if numbers.contains(where: password.contains) {
            containsNumbers = true
        }
        if lowerCharacters.contains(where: password.contains) {
            containsLowerCharacters = true
        }
        if upperCharacters.contains(where: password.contains) {
            containsUpperCharacters = true
        }
        if specialCharacters.contains(where: password.contains) {
            containsSpecialCharacters = true
        }
        if complicatedCharacters.contains(where: password.contains) {
            containsComplicatedCharacters = true
        }
        var selection: Int = 0
        if containsNumbers {
            selection += numbers.count
        }
        if containsLowerCharacters {
            selection += lowerCharacters.count
        }
        if containsUpperCharacters {
            selection += upperCharacters.count
        }
        if containsSpecialCharacters {
            selection += specialCharacters.count
        }
        if containsComplicatedCharacters {
            selection += complicatedCharacters.count
        }
        return Double(selection)/90.0
    }
    
    func doDiversityCheck(password: String) -> Double {
        let characterSelection: [String] = createCharacterSelection(containCharaterSelection: ContainCharacterSelection(containNumbers: true, containLowerCharacters: true, containUpperCharacters: true, containSpecialCharacters: true, containComplicatedCharacters: true))
        var diversity: Int = 0
        for letter in characterSelection {
            if password.contains(letter) {
                diversity += 1
            }
        }
        return 7*Double(diversity)/Double(characterSelection.count)
    }
}

