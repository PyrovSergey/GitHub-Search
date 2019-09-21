//
//  AlertController.swift
//  GitHub Search
//
//  Created by Sergey on 21/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import SwiftMessages
import JDStatusBarNotification


public class AlertController {
    public static let shared = AlertController()
}

// MARK: - Public interface
public extension AlertController {
    
    func showAlert(withText text: String,
                   icon: UIImage? = nil,
                   buttonTitle: String,
                   buttonPressHandler: (() -> ())? = nil) {
        
        var config = SwiftMessages.Config()
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark,
                               alpha: 1.0,
                               interactive: true)
        
        config.interactiveHide = false
        config.preferredStatusBarStyle = .lightContent
        
        let messageView = MessageView.viewFromNib(layout: .messageView)
        messageView.configureTheme(.info)
        
        messageView.configureContent(title: nil,
                                     body: text,
                                     iconImage: icon,
                                     iconText: nil,
                                     buttonImage: nil,
                                     buttonTitle: buttonTitle) { _ in
                                        
                                        buttonPressHandler?()
                                        SwiftMessages.hide()
        }
        
        SwiftMessages.show(config: config, view: messageView)
    }
    
    func showErrorToast(error: String, autoHide: Bool = true) {
        
        setErrorToastStyle()
        
        if autoHide {
            JDStatusBarNotification.show(withStatus: error,
                                         dismissAfter: Constants.toastShowDuration,
                                         styleName: Constants.toastErrorStyle)
        } else {
            JDStatusBarNotification.show(withStatus: error,
                                         styleName: Constants.toastErrorStyle)
        }
    }
    
    func hideToast() {
        JDStatusBarNotification.dismiss(animated: true)
    }
    
    func hideProgress() {
        JDStatusBarNotification.dismiss(animated: true)
    }
    
    func showToast(message: String) {
        
        JDStatusBarNotification.show(withStatus: message,
                                     dismissAfter: Constants.toastShowDuration,
                                     styleName: JDStatusBarStyleSuccess)
    }
    
    func showProgress() {
        JDStatusBarNotification.show(withStatus: "Loading", styleName: JDStatusBarStyleDefault)
        JDStatusBarNotification.showActivityIndicator(true, indicatorStyle: .gray)
    }

}

// MARK: - Private
private extension AlertController {
    
    func present(_ alertViewController: UIViewController) {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.topViewController?.present(alertViewController, animated: true, completion: nil)
        } else {
            rootViewController?.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func setErrorToastStyle() {
        
        JDStatusBarNotification.addStyleNamed(Constants.toastErrorStyle) { (style) -> JDStatusBarStyle? in
            
            style.barColor = UIColor(red: 240.0 / 255.0,
                                     green: 90.0 / 255.0,
                                     blue: 103.0 / 255.0,
                                     alpha: 1.0)
            style.textColor = .white
            return style
        }
    }
}


// MARK: - Constants
private extension AlertController {
    
    enum Constants {
        
        static let toastShowDuration: TimeInterval = 1
        static let toastErrorStyle = "ToastErrorStyle"
    }
}



