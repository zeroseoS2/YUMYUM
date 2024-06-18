//
//  SearchController.swift
//  YUMYUM
//
//  Created by 최영서 on 6/14/24.
//

import UIKit

class SearchController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var search: UISearchBar!
    var recipes: [FoodRecipeItem] = [] // 모든 레시피를 저장할 배열
    var searchResults: [FoodRecipeItem] = [] // 검색 결과를 저장할 배열
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate=self
        tableview.dataSource=self
        search.delegate=self
        //세그먼트 값 변경시 액션 설정
        segment.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        fetchRecipes()
    }
    // MARK: - Fetch Recipes
    //모든 레시피 가져오는 함수
    func fetchRecipes() {
            APIManager.shared.fetchAllRecipes { [weak self] result in
                switch result {
                case .success(let recipes):
                    self?.recipes = recipes
                    //메인 스레드에서 테이블 뷰 리로드
                    DispatchQueue.main.async {
                        self?.tableview.reloadData()
                    }
                case .failure(let error):
                    print("Failed to fetch recipes: \(error)")
                }
            }
        }
    // MARK: - Search Recipes
    //검색 기능 구현 함수
    func searchRecipes(with keyword: String) {
            if segment.selectedSegmentIndex == 0 {
                // 메뉴명으로 검색
                searchResults = recipes.filter { $0.RCP_NM.contains(keyword) }
            } else {
                // 재료로 검색
                searchResults = recipes.filter { $0.RCP_PARTS_DTLS.contains(keyword) }
            }
            //검색 결과로 테이블 뷰 리로드
            tableview.reloadData()
    }
    // MARK: - Segment Value Changed
    //세그먼트 값이 변경되었을 때 호출되는 함수
    @IBAction func segmentValueChanged() {
        if let searchText = search.text, !searchText.isEmpty {
                    searchRecipes(with: searchText) //검색어가 있을 경우 검색 실행
        }
    }
    // MARK: - Prepare for Segue
    //화면 전환 준비를 위한 함수
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showRecipeDetail", let destinationVC = segue.destination as? RecipeDetailController {
                if let indexPath = tableview.indexPathForSelectedRow {
                    let selectedRecipe = searchResults[indexPath.row]
                    destinationVC.recipe = selectedRecipe   //선택된 레시피 상세 화면으로 전달
                }
            }
    }
}
// MARK: - UISearchBarDelegate Extension
//UISearchBarDelegate 프로프로토콜 구현
extension SearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchRecipes(with: searchText)
        searchBar.resignFirstResponder()
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource Extensions
// UITableViewDelegate 및 UITableViewDataSource 프로토콜 구현
extension SearchController: UITableViewDelegate, UITableViewDataSource {
    //테이블 뷰의 행 수를 반환하는 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    //각 행에 대한 셀을 구성하는 함수
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        let recipe = searchResults[indexPath.row]
        
        cell.menutitle.text = recipe.RCP_NM //메뉴 제목 설정
        
        if let imageUrl = URL(string: recipe.ATT_FILE_NO_MAIN) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        //이미지를 비동기적으로 다운로드하여 설정
                        cell.menuimg.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        
        return cell
    }
    // MARK: - UITableViewDelegate Methods
    //각 행의 높이를 설정하는 함수
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 140 // 적절한 높이 값으로 변경
    }
    //행이 선택되었을 때 호출되는 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //SearchController->RecipeDetailController(레시피 상세 페이지)
        performSegue(withIdentifier: "showRecipeDetail", sender: self)
    }
}
