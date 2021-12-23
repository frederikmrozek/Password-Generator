//
//  AppDelegate.swift
//  Password Generator
//
//  Created by Frederik Mrozek on 19.12.21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSTextFieldDelegate {

    @IBOutlet var window: NSWindow!
    
    // OUTLETS: Switches
    @IBOutlet weak var numbersSwitch: NSSwitch!
    @IBOutlet weak var lowerCharactersSwitch: NSSwitch!
    @IBOutlet weak var upperCharactersSwitch: NSSwitch!
    @IBOutlet weak var specialCharactersSwitch: NSSwitch!
    @IBOutlet weak var complicatedCharactersSwitch: NSSwitch!
    
    // OUTLETS: Password Editing
    @IBOutlet weak var lengthLabel: NSTextField!
    @IBOutlet weak var lengthSlider: NSSlider!
    @IBOutlet weak var passwordTextField: NSTextField!
    @IBOutlet weak var generateButton: NSButton!
    @IBOutlet weak var strengthIndicator: NSLevelIndicator!
    
    // OUTLETS: Labels
    @IBOutlet weak var lengthTitle: NSTextField!
    @IBOutlet weak var passwordTitle: NSTextField!
    @IBOutlet weak var strengthTitle: NSTextField!
    @IBOutlet weak var weakTitle: NSTextField!
    @IBOutlet weak var fineTitle: NSTextField!
    @IBOutlet weak var safeTitle: NSTextField!
    @IBOutlet weak var strongTitle: NSTextField!
    @IBOutlet weak var numbersTitle: NSTextField!
    @IBOutlet weak var lowerTitle: NSTextField!
    @IBOutlet weak var upperTitle: NSTextField!
    @IBOutlet weak var specialTitle: NSTextField!
    @IBOutlet weak var complicatedTitle: NSTextField!
    @IBOutlet weak var mostCommonLabel: NSTextField!
    
    var containCharaterSelection: ContainCharacterSelection = ContainCharacterSelection()
    var passwordGenerator: PasswordGenerator = PasswordGenerator()
    
    var checkIfPasswordIn10MillionMostCommonTask: DispatchWorkItem!
    var passwordString: String = ""
    var tenMillionMostCommonPasswords: [String] = []

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        passwordTextField.delegate = self
        
        let font: NSFont = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        passwordTextField.font = font
        lengthLabel.font = font
        lengthTitle.font = font
        generateButton.font = font
        passwordTitle.font = font
        strengthTitle.font = font
        weakTitle.font = font
        fineTitle.font = font
        safeTitle.font = font
        strongTitle.font = font
        numbersTitle.font = font
        lowerTitle.font = font
        upperTitle.font = font
        specialTitle.font = font
        complicatedTitle.font = font
        mostCommonLabel.font = NSFont.monospacedSystemFont(ofSize: 10, weight: .regular)
        
        read10MillionMostCommonPasswordFile()
        
        self.generateButton(generateButton)
    }
    
    func newPasswordEntered(password: String) {
        lengthLabel.stringValue = String(password.count)
        lengthSlider.integerValue = password.count
        strengthIndicator.integerValue = passwordGenerator.getStrength(password: password)
        mostCommonLabel.isHidden = true
        passwordString = password
        if self.checkIfPasswordIn10MillionMostCommonTask != nil {
            self.checkIfPasswordIn10MillionMostCommonTask.cancel()
        }
        let queue = DispatchQueue(label: "checkIfPasswordIn10MillionMostCommonTask_Queue")
        let newCheckIfPasswordIn10MillionMostCommonTask: DispatchWorkItem = DispatchWorkItem {
            let passwordMatch: Bool = self.checkIfPasswordIn10MillionMostCommon(password: self.passwordString)
            if passwordMatch {
                DispatchQueue.main.async {
                    self.mostCommonLabel.isHidden = false
                }
            }
        }
        self.checkIfPasswordIn10MillionMostCommonTask = newCheckIfPasswordIn10MillionMostCommonTask
        if password.count > 0 {
            queue.async(execute: self.checkIfPasswordIn10MillionMostCommonTask)
        }
    }

    // ACTIONS: Password Editing
    @IBAction func lengthSlider(_ sender: NSSlider) {
        lengthLabel.stringValue = String(sender.integerValue)
    }
    
    func controlTextDidChange(_ obj: Notification) {
        newPasswordEntered(password: passwordTextField.stringValue)
    }
    
    @IBAction func passwordTextField(_ sender: Any) { }
    
    @IBAction func generateButton(_ sender: NSButton) {
        let password = passwordGenerator.generatePassword(lenght: lengthSlider.integerValue, containCharaterSelection: containCharaterSelection)
        passwordTextField.stringValue = password
        newPasswordEntered(password: password)
    }
    
    @IBAction func copy(_ sender: Any) {        
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(passwordTextField.stringValue, forType: .string)

    }
    
    // ACTIONS: Switches
    @IBAction func numbersSwitch(_ sender: NSSwitch) {
        containCharaterSelection.containNumbers = sender.state == .on
    }
    
    @IBAction func lowerCharactersSwitch(_ sender: NSSwitch) {
        containCharaterSelection.containLowerCharacters = sender.state == .on
    }
    
    @IBAction func upperCharactersSwitch(_ sender: NSSwitch) {
        containCharaterSelection.containUpperCharacters = sender.state == .on
    }
    
    @IBAction func specialCharactersSwitch(_ sender: NSSwitch) {
        containCharaterSelection.containSpecialCharacters = sender.state == .on
    }
    
    @IBAction func complicatedCharactersSwitch(_ sender: NSSwitch) {
        containCharaterSelection.containComplicatedCharacters = sender.state == .on
    }
    
    func read10MillionMostCommonPasswordFile() {
        let path = Bundle.main.path(forResource: "10million_password_list", ofType: "txt") ?? nil
        if path != nil {
            do {
                let tenMillionMostCommonPasswordsString: String = try String(contentsOfFile: path!)
                tenMillionMostCommonPasswords = tenMillionMostCommonPasswordsString.components(separatedBy: "\n")
            } catch {
                print("Could not read file named: \"10million_password_list.txt\"")
            }
        }
        else {
            print("Could not read file named: \"10million_password_list.txt\"")
        }
    }
    
    func checkIfPasswordIn10MillionMostCommon(password: String) -> Bool {
        return tenMillionMostCommonPasswords.contains(password)
    }
}
