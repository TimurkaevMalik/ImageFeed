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
        
        controller.present(alert, animated: true)
    }
    
    func showAlert2(vc controller: UIViewController, result: AlertModel){
        
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
        
        let actionRestart = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion()
        }
        
        let actionCancel = UIAlertAction(title: result.cancelButtonText, style: .default)
        
        alert.addAction(actionCancel)
        alert.addAction(actionRestart)
        
        controller.present(alert, animated: true)
    }
}
