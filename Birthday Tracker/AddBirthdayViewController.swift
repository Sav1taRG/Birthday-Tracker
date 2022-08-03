//
//  ViewController.swift
//  Birthday Tracker
//
//  Created by Roman Golubinko on 14.07.2022.
//

import UIKit
import CoreData
import UserNotifications

class AddBirthdayViewController: UIViewController {
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var birthdatePicker: UIDatePicker!
    
    var saveCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdatePicker.maximumDate = Date()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveTapped (_ sender: UIBarButtonItem){
        print("Нажата кнопка сохранения.")
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let birthDate = birthdatePicker.date
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthDate = birthDate
        newBirthday.birthdayID = UUID().uuidString
        if let uniqueID = newBirthday.birthdayID {
            print("birthday ID:\(uniqueID)")
        }
        do {
            try context.save()
            let message = "Сегодня \(firstName) \(lastName) празднует День Рождения!"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthDate)
            dateComponents.hour = 10
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            if let identifier = newBirthday.birthdayID {
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
            } catch let error {
                print("Не удалось сохранить из-за ошибки \(error)")
            }
        
        dismiss(animated: true, completion: saveCompletion)

        
        print("Создана запись о дне рождения")
        print("Имя: \(newBirthday.firstName)")
        print("Фамилия: \(newBirthday.lastName)")
        print("День рождения: \(newBirthday.birthDate)")
        
    }
    @IBAction func cancelTapped (_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

