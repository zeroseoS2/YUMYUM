//
//  RecipeDetailController.swift
//  YUMYUM
//
//  Created by 최영서 on 6/14/24.
//

import UIKit

class RecipeDetailController: UIViewController {
    var isStarSelected = false

    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var recipeTextView: UITextView!
    var recipe: FoodRecipeItem?
    private let starButton=UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupStarButton()
    }
    //별 버튼 설정하는 메서드
    private func setupStarButton() {
           let emptyStar = UIImage(systemName: "star")
           let filledStar = UIImage(systemName: "star.fill")
           // 버튼 프레임 설정
           starButton.frame = CGRect(x: 310, y: 70, width: 50, height: 50)
           // 초기 상태 설정
           starButton.setImage(emptyStar, for: .normal)
           starButton.setImage(filledStar, for: .selected)
           // 버튼 액션 설정
           starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
           // 뷰에 버튼 추가
           view.addSubview(starButton)
    }
    //UI 설정 메서드
    func configureUI() {
        guard let recipe = recipe else { return }
        //레시피 정보 설정
        menuLabel.text = recipe.RCP_NM  //메뉴명
        menuLabel.font = UIFont.boldSystemFont(ofSize: 20.0) // 원하는 폰트 사이즈로 설정
        
        ingredientsTextView.text = recipe.RCP_PARTS_DTLS    //재료
        ingredientsTextView.layer.cornerRadius=10
        ingredientsTextView.layer.masksToBounds=true
        //레시피
        recipeTextView.text = "\(recipe.MANUAL01)\n\(recipe.MANUAL02)\n\(recipe.MANUAL03)\n\(recipe.MANUAL04)\n\(recipe.MANUAL05)\n\(recipe.MANUAL06)\n\(recipe.MANUAL07)\n\(recipe.MANUAL08)\n\(recipe.MANUAL09)\n\(recipe.MANUAL10)\n\(recipe.MANUAL11)\n\(recipe.MANUAL12)\n\(recipe.MANUAL13)\n\(recipe.MANUAL14)\n\(recipe.MANUAL15)" // 필요한 만드는 방법 추가
        recipeTextView.layer.cornerRadius=10
        recipeTextView.layer.masksToBounds=true
        //레시피 이미지 다운로드 및 표시
        if let imageUrl = URL(string: recipe.ATT_FILE_NO_MAIN) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                guard let data = data, error == nil else {
                    print("Failed to download image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                DispatchQueue.main.async {
                    self.menuImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    // MARK: - Actions
    //별 버튼 눌렀을 떄
    @objc func starButtonTapped(_ sender: UIButton) {
        isStarSelected.toggle() // 별 상태 토글
        sender.isSelected = isStarSelected // 버튼의 선택 상태에 따라 이미지 변경
    }
}
