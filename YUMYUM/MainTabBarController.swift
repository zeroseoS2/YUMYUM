//
//  MainTabBarController.swift
//  YUMYUM
//
//  Created by 김원재 on 6/15/24.
//

import UIKit

class MainTabBarController: UITabBarController,UITabBarControllerDelegate {
    var loginEmail: String?

    override func viewDidLoad() {
            super.viewDidLoad()
            self.delegate = self
        }
        
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let myPageNavVC = viewController as? UINavigationController,
                   let myPageVC = myPageNavVC.viewControllers.first as? MyPageController {
                    myPageVC.loginEmail = loginEmail
        }
    }

}
