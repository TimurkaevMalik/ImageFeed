//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 01.03.2024.
//

import UIKit

final class AlertPresenter {
    
    func showAlert(vc controller: UIViewController, result: AlertModel){
        
        let alert = UIAlertController(title: result.title, message: result.message , preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default){ _ in
            
            result.completion()
        }
        
        alert.addAction(action)
        
        if let secondActionText = result.cancelButtonText {
            let actionCancel = UIAlertAction(title: secondActionText, style: .default)
            alert.addAction(actionCancel)
        }
        
        controller.present(alert, animated: true)
    }
}
