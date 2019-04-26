//
//  ViewController.swift
//  My Resume
//
//  Created by Георгий Кашин on 24/04/2019.
//  Copyright © 2019 Georgii Kashin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userName = ""
    var password = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotUserNameButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBAction func logInButtonPressed() {
        guard userNameTextField.text != "" else { return }
        guard passwordTextField.text != "" else { return }
        
        guard userNameTextField.text == userName else {
            showAlert(title: "Не удалось войти", message: "Неправильное имя пользователя")
            return
        }
        guard passwordTextField.text == password else {
            showAlert(title: "Не удалось войти", message: "Неправильный пароль")
            return
        }
        
        performSegue(withIdentifier: "dvc", sender: logInButton)
    }
    
     @IBAction func signInButtonPressed() {
        guard userNameTextField.text != "" else { return }
        guard passwordTextField.text != "" else { return }
        
        userName = userNameTextField.text!
        password = passwordTextField.text!
        
        logInButton.isEnabled = true
        forgotUserNameButton.isEnabled = true
        forgotPasswordButton.isEnabled = true
    }
    
    @IBAction func forgotUserNamePressed() {
        performSegue(withIdentifier: "dvc", sender: forgotUserNameButton)
    }
    
    @IBAction func forgotPasswordPressed() {
        performSegue(withIdentifier: "dvc", sender: forgotPasswordButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInButton.isEnabled = false
        forgotUserNameButton.isEnabled = false
        forgotPasswordButton.isEnabled = false

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        registerForKeyboardNotifications()
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}           

// MARK: - Navigation
extension ViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let dvc = segue.destination as? SecondViewController else { return }
        guard let button = sender as? UIButton else { return }
        
        switch button.tag {
        case 0:
            dvc.information = userNameTextField.text!
            dvc.isHidden = false
        case 1:
            dvc.information = "Ваше имя '\(userName)'"
        case 2:
            dvc.information = "Ваш пароль '\(password)'"
        default:
            break
        }
    }
}

//MARK: - Text field delegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            logInButtonPressed()
        }
        return true
    }
}

//MARK: - Alerts
extension ViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Notifications (тут хотел использовать notifications, чтобы сдвигать содержимое, но что-то пошло не так)
extension ViewController {

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardFrameSize.height / 4)
    }

    @objc func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
}
