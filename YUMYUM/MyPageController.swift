//
//  MyPageController.swift
//  YUMYUM
//
//  Created by 최영서 on 6/14/24.
//

import UIKit
import FirebaseAuth

class MyPageController: UIViewController {

    @IBOutlet weak var userEmail: UILabel!
    var loginEmail: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI() // viewDidLoad에서 UI를 업데이트하는 메서드 호출
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI() // 화면이 나타날 때마다 UI를 업데이트하는 메서드 호출
    }
    
    func updateUI() {
        userEmail.text=loginEmail
    }
    // MARK: - Actions
    //로그아웃 버튼 눌렀을 때
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let firebaseAuth=Auth.auth()
        do{
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }catch let signOutError as NSError{
            print("Error signing out: %@",signOutError)
        }
    }
    
}
