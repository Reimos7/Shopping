//
//  ViewController+Extension.swift
//  Shopping
//
//  Created by Reimos on 7/27/25.
//

import UIKit

// VC에 네비게이션 컨트롤러러 -> push , present (fullscreen등등 enum)
enum ScreenTransition {
    case present
    case push
}

extension UIViewController {
    // 닫기 버튼만 있는 alert
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let cancel = UIAlertAction(title: "닫기", style: .cancel)
        
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    // 에러 전용 alert
    // NetworkError는 네트워크 전용 Enum
    func showErrorAlert(error: NetworkError) {
        let alert = UIAlertController(title: error.networkErrorTitle, message: error.networkErrorDescription, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "닫기", style: .cancel)
        
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    // VC에 네비게이션 컨트롤러 -> push , present
    func transitionVC(_ vc: UIViewController, style: ScreenTransition) {
        switch style {
        case .push:
            self.navigationController?.pushViewController(vc, animated: true)
        case .present:
            self.present(vc, animated: true)
        }
    }
}
