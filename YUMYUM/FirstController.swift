//
//  ViewController.swift
//  YUMYUM
//
//  Created by 최영서 on 6/13/24.
//

import UIKit
import FirebaseAuth

class FirstController: UIViewController {
    var loginEmail: String? //로그인 성공 시 이메일을 저장할 변수
    @IBOutlet weak var email: UITextField!  //이메일 입력 필드
    @IBOutlet weak var password: UITextField!   //비밀번호 입력 필드
    @IBOutlet weak var loginbtn: UIButton!  //로그인 버튼
    @IBOutlet weak var signupbtn: UIButton! //회원가입 버튼
    override func viewDidLoad() {
        super.viewDidLoad()
        password.isSecureTextEntry = true   //비밀번호 필드를 보안 텍스트로 설정
        loginbtn.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside) //로그인 버튼 클릭 시 액션 설정
        signupbtn.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)   //회원가입 버튼 클릭 시 액션 설정
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            //화면이 나타날 때 이메일과 비밀번호 필드 초기화
            email.text = ""
            password.text = ""
    }
    //로그인 버튼 눌렀을때
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = email.text, let pw = password.text else {
                    print("이메일 또는 비밀번호가 입력되지 않았습니다.")
                    return
                }
                Auth.auth().signIn(withEmail: email, password: pw) { authResult, error in
                    if let error = error {
                        print("로그인 실패:", error.localizedDescription)
                        self.showAutoDismissAlert(title: "알림", message: "로그인 실패")
                    } else if let authResult = authResult {
                        print("로그인 성공:", authResult.user.email ?? "이메일 없음")
                        self.loginEmail = authResult.user.email //로그인 성공 시 이메일 저장
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "gotomain", sender: self) //메인 화면으로 전환
                            self.showAutoDismissAlert(title: "알림", message: "로그인 성공")
                        }
                    }
                }

    }
    //회원가입 버튼 눌렀을때
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        if let email = email.text ,let pw = password.text {
                Auth.auth().createUser(withEmail: email, password: pw) { authResult, error in // 회원가입을 위한 함수
                    if let e = error{
                        print(e.localizedDescription)  // 유저가 알아들을 수 있는 피드백
                        self.showAutoDismissAlert(title: "알림", message: "회원가입 실패")
                    } else{
                        print("회원가입성공")
                        self.showAutoDismissAlert(title: "알림", message: "회원가입 성공")
                    }
                }
            }
    }
    //팝업창 함수
    func showAutoDismissAlert(title: String, message: String, duration: TimeInterval = 0.8) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
                alert.dismiss(animated: true, completion: nil)
            }
        }
    // MARK: - Prepare for Segue
    //화면 전환 준비를 위한 함수
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "gotomain",
               let tabBarVC = segue.destination as? MainTabBarController {
                if let lastTabVC = tabBarVC.viewControllers?.last as? MyPageController{
                        //로그인 이메일을 MyPageController에 전달
                        lastTabVC.loginEmail = loginEmail
                    }
            }
    }
}

