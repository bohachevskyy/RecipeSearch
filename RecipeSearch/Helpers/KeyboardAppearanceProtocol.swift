//
//  KeyboardAppearanceProtocol.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import UIKit

protocol KeyboardAppearanceProtocol {
    func keyboardWillChangeHeight(height: CGFloat, duration: TimeInterval, show: Bool)
    func keyboardDidChangeHeight(height: CGFloat, show: Bool)
}

fileprivate extension UIViewController {
    @objc func keyboardWillShow(_ sender: Notification) {
        guard let viewController = self as? KeyboardAppearanceProtocol,
            let userInfo = sender.userInfo,
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
                return
        }
        viewController.keyboardWillChangeHeight(height: frame.cgRectValue.height, duration: duration.doubleValue, show: true)
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        guard let viewController = self as? KeyboardAppearanceProtocol,
            let userInfo = sender.userInfo,
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
                return
        }
        viewController.keyboardWillChangeHeight(height: frame.cgRectValue.height, duration: duration.doubleValue, show: false)
    }
    
    @objc func keyboardDidShow(_ sender: Notification) {
        guard let viewController = self as? KeyboardAppearanceProtocol,
            let userInfo = sender.userInfo,
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        viewController.keyboardDidChangeHeight(height: frame.cgRectValue.height, show: true)
    }
    
    @objc func keyboardDidHide(_ sender: Notification) {
        guard let viewController = self as? KeyboardAppearanceProtocol,
            let userInfo = sender.userInfo,
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        viewController.keyboardDidChangeHeight(height: frame.cgRectValue.height, show: false)
    }
}

extension KeyboardAppearanceProtocol where Self: UIViewController {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(_:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide(_:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
    
    func deRegisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
}
