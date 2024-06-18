//
//  MyRecipeController.swift
//  YUMYUM
//
//  Created by 최영서 on 6/15/24.
//

import UIKit
import FirebaseFirestore

class CookShareController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet weak var tableview: UITableView!
    var recipes: [Recipe] = []
    private var firestore: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        TitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        //addbtn에 버튼 탭 액션 추가
        addbtn.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        // Firestore 초기화
        firestore = Firestore.firestore()
        //table의 delegate와 dataSource 설정
        tableview.delegate = self
        tableview.dataSource = self
        // Firestore에서 레시피 데이터 로드
        loadRecipes()
        // Swipe 제스처 추가
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipeLeft.direction = .left
        tableview.addGestureRecognizer(swipeLeft)
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // View가 다시 나타날 때마다 레시피 데이터 다시 로드
            loadRecipes()
    }
    //Firestore에서 레시피 데이터를 로드하는 함수
    func loadRecipes() {
        //Firestore의 "recipes"컬렉션에서 문서들을 가져오는 비동기 메서드를 호출
        firestore.collection("recipes").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else { return }
            //Firestore에서 가져온 문서들을 Recipe 객체로 매핑
            self.recipes = snapshot.documents.compactMap { document -> Recipe? in
                let data = document.data()  //문서의 데이터 가져오기
                let menu = data["menu"] as? String ?? ""
                let ingredients = data["ingredients"] as? String ?? ""
                let recipe = data["recipe"] as? String ?? ""
                let imageUrl = data["image_url"] as? String ?? ""
                return Recipe(menu: menu, ingredients: ingredients, recipe: recipe, imageUrl: imageUrl)
            }
            //테이블 뷰 재로드
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }


    // MARK: - UITableViewDataSource Methods
    //테이블 뷰의 섹션 당 행의 수를 반환하는 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    //각 행에 대한 셀을 구성하는 함수
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRecipeCell", for: indexPath) as! CookShareTableViewCell
        let recipe = recipes[indexPath.row]
        cell.menutitle.text = recipe.menu
        cell.menuimg.image = nil // 기본 이미지를 nil로 설정하여 이전 이미지 재사용 방지
        //비동기로 이미지를 로드하여 셀에 설정
        if let imageUrl = URL(string: recipe.imageUrl) {
            // 현재 셀의 인덱스를 로컬 변수에 저장
            let currentIndex = indexPath.row
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageUrl) {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        // 현재 셀의 인덱스와 로컬 변수의 인덱스가 같은지 확인
                        if currentIndex == indexPath.row {
                            cell.menuimg.image = image
                        }
                    }
                }
            }
        }
        return cell
    }
    //각 행의 높이를 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100 // 적절한 높이 값으로 변경
    }
    // MARK: - Swipe Gesture Handling
    //테이블 뷰의 각 행에 대한 스와이프 액션을 설정하는 함수
    @objc func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        //스와이프한 위치에 해당하는 테이블 뷰의 indexPath 가져옴
        guard let swipeIndexPath = tableview.indexPathForRow(at: gesture.location(in: tableview)) else {
            return
        }    }

    // MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Edit 액션 설정
        let editAction = UIContextualAction(style: .normal, title: "") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            self.editRecipe(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .systemGray6
    
        if let editImage = UIImage(systemName: "minus.circle.fill") {
            // 색상 변경
            let tintedImage = editImage.withRenderingMode(.alwaysOriginal)
            let coloredImage = tintedImage.withTintColor(UIColor(red: 0.89, green: 0.30, blue: 0.36, alpha: 1.0)) // #E54C5C 색상으로 변경
            
            // 이미지 설정
            editAction.image = coloredImage
        }

        //Delete 액션 설정
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            let recipeToDelete = self.recipes[indexPath.row]
            self.deleteRecipe(recipeToDelete, at: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false // optional setting
        return configuration
    }
    // MARK: - Edit Recipe

    func editRecipe(at indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoeditrecipe", sender: indexPath)
    }

    // MARK: - Delete Recipe
    func deleteRecipe(_ recipe: Recipe, at indexPath: IndexPath) {
        showAutoDismissAlert(title: "알림", message: "레시피가 삭제되었습니다")
        let db = Firestore.firestore()
        db.collection("recipes").whereField("menu", isEqualTo: recipe.menu)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error deleting document: \(error.localizedDescription)")
                } else {
                    guard let snapshot = snapshot else { return }
                    for document in snapshot.documents {
                        db.collection("recipes").document(document.documentID).delete { error in
                            if let error = error {
                                print("Error removing document: \(error.localizedDescription)")
                            } else {
                                print("Document successfully removed!")
                                // UI 업데이트: 테이블 뷰에서 해당 행 삭제
                                self.recipes.remove(at: indexPath.row)
                                self.tableview.deleteRows(at: [indexPath], with: .automatic)
                            }
                        }
                    }
                }
            }
    }
    // MARK: - Add Button Action
    //레시피 추가 버튼을 탭했을 때
    @IBAction func addButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoaddrecipe", sender: self)
    }
    // MARK: - Prepare for Segue
    //세그웨이 실행 전 준비 작업
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoeditrecipe",
           let destinationVC = segue.destination as? AddMyRecipeController,
           let indexPath = sender as? IndexPath {
            let recipe = recipes[indexPath.row]
            destinationVC.recipe = recipe   //선택된 레시피 정보를 수정 화면으로 전달
            destinationVC.isEditMode = true //수정 모드로 화면을 설정
        }
    }
    // MARK: - Helper Methods
    //팝업창 함수
    func showAutoDismissAlert(title: String, message: String, duration: TimeInterval = 0.8) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
