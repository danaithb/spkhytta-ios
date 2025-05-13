//
//  UIViewController+Extension.swift
//  Spkhytta-iOS
//
//  Created by Jana Carlsson on 30/04/2025.
//Här har vi fått hjälp av spk att modifiera tilbake så att den behåller sin Swipe funktion. Hade i en framtida version så hade vi lagt till språk setttings för att undgå att hårdkoda den med "tilbake"
import UIKit

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
