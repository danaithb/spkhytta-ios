//
//  UIViewController+Extension.swift
//  Spkhytta-iOS
//
//  Created by Mariana and Abigail on 30/04/2025.
//fått hjelp av Danial på spk å modifiere "tilbake" så att den fortsatt har sin Swipe funksjon. I en framtide verssjon så hade vi lagt til språk setttings för att undgå att hårdkoda den med "tilbake"
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
