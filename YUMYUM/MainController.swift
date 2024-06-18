//
//  MainController.swift
//  YUMYUM
//
//  Created by 최영서 on 6/14/24.
//

import UIKit

class MainController: UIViewController {

    @IBOutlet weak var recommendedRecipePicker: UIPickerView!
    // APIManager 인스턴스 생성
    let apiManager = APIManager.shared
    // 피커뷰에서 사용할 데이터 소스
    var menuItems: [FoodRecipeItem] = []
    
    @IBOutlet weak var recipeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 피커뷰 데이터 소스 설정
        recommendedRecipePicker.dataSource = self
        recommendedRecipePicker.delegate = self
        // 추천 메뉴 데이터 가져오기
        fetchRecommendedRecipes()
    }
    // MARK: - Fetch Recommended Recipes
    //오늘의 추천 레시피 데이터를 APIManager를 통해 가져오는 함수
    func fetchRecommendedRecipes() {
            apiManager.fetchRecommendedRecipes { [weak self] result in
                switch result {
                case .success(let recipes):
                    // 데이터를 가져오면 UI 업데이트
                    DispatchQueue.main.async {
                        self?.menuItems = recipes
                        self?.recommendedRecipePicker.reloadAllComponents()
                    }
                case .failure(let error):
                    print("Failed to fetch menu items: \(error)")
                }
            }
    }
    // MARK: - Format Recipe Name
    func formattedRecipeName(_ name: String) -> String {
            if name.count > 15 {
                let index = name.index(name.startIndex, offsetBy: 15)
                let firstPart = name[..<index]
                let secondPart = name[index...]
                return "\(firstPart)\n\(secondPart)"
            }
            return name
    }
    // MARK: - Button Actions
    //레시피 버튼 눌렀을 떄
    @IBAction func recipeButtonTapped(_ sender: UIButton) {
        let selectedRow = recommendedRecipePicker.selectedRow(inComponent: 0)
        let selectedRecipe = menuItems[selectedRow]
                
        performSegue(withIdentifier: "showRecipeDetail", sender: selectedRecipe)
    }
    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showRecipeDetail" {
                if let recipeDetailVC = segue.destination as? RecipeDetailController,
                   let selectedRecipe = sender as? FoodRecipeItem {
                    recipeDetailVC.recipe = selectedRecipe
                }
            }
    }
}
extension MainController: UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - UIPickerViewDataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // 하나의 컴포넌트만 사용
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return menuItems.count // 데이터의 개수만큼 행을 반환
    }
    // MARK: - UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let recipe = menuItems[row]
                    
            // 이미지와 레이블을 포함하는 뷰 생성
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 350))
        
            // 이미지 뷰 생성
            let imageView = UIImageView(frame: CGRect(x: (containerView.frame.width - 200) / 2, y: 60, width: 200, height: 200))
            imageView.contentMode = .scaleAspectFit
            
            // 레이블 생성
            let label = UILabel(frame: CGRect(x: 0, y: 260, width: containerView.frame.width, height: 50))
            label.text = formattedRecipeName(recipe.RCP_NM)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.textAlignment = .center
            label.font=UIFont.boldSystemFont(ofSize: 16)
            // 이미지 다운로드 및 표시
            if let imageUrl = URL(string: recipe.ATT_FILE_NO_MAIN) {
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    guard let data = data, error == nil else {
                        print("Failed to download image: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    // 메인스레드에서 이미지 표시
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: data)
                    }
                }.resume()
            }
            // 이미지 뷰와 레이블을 컨테이너 뷰에 추가
            containerView.addSubview(imageView)
            containerView.addSubview(label)
            
            return containerView
        }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 350 // 각 행의 높이 설정
    }
}
