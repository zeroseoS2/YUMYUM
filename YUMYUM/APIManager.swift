//
//  APIManager.swift
//  YUMYUM
//
//  Created by 최영서 on 6/14/24.
//

import Foundation

class APIManager {
    static let shared = APIManager()  // Singleton 인스턴스

    private let baseURL = "http://openapi.foodsafetykorea.go.kr/api"
    private let keyId = "9cd1dc014fd640c8839d"
    private let serviceId = "COOKRCP01"
    private let dataType = "json"
    private let startIdx = "1"  // 시작 인덱스 설정
    private let endIdx = "100"    // 종료 인덱스 설정

    // MARK: - Fetch All Recipes
    //전체 레시피 목록을 가져오는 메서드
    func fetchAllRecipes(completion: @escaping (Result<[FoodRecipeItem], Error>) -> Void) {
        let urlString = "\(baseURL)/\(keyId)/\(serviceId)/\(dataType)/\(startIdx)/\(endIdx)"
        fetchRecipes(with: urlString, completion: completion)
    }

    // MARK: - Fetch Recipes by Name (Search by name)
    //이름으로 레시피를 점색하는 메서드
    func fetchRecipesByName(_ name: String, completion: @escaping (Result<[FoodRecipeItem], Error>) -> Void) {
        var urlString = "\(baseURL)/\(keyId)/\(serviceId)/\(dataType)/\(startIdx)/\(endIdx)"
        urlString += "?RCP_NM=\(name)"
        fetchRecipes(with: urlString, completion: completion)
    }

    // MARK: - Fetch Recommended Recipes (Random selection)
    //랜덤으로 추천 레시피를 가져오는 메서드
    func fetchRecommendedRecipes(completion: @escaping (Result<[FoodRecipeItem], Error>) -> Void) {
        let randomStartIdx = getRandomNumber()
        let randomEndIdx = randomStartIdx + 3  // endIdx는 startIdx보다 크게 설정
        let urlString = "\(baseURL)/\(keyId)/\(serviceId)/\(dataType)/\(randomStartIdx)/\(randomEndIdx)"
        fetchRecipes(with: urlString, completion: completion)
    }

    // Private method to fetch recipes from URL
    //URL을 이용해 레시피를 가져오는 메서드
    private func fetchRecipes(with urlString: String, completion: @escaping (Result<[FoodRecipeItem], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "ServerError", code: -2, userInfo: nil)))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -3, userInfo: nil)))
                return
            }
            do {
                // JSON 데이터를 파싱하여 FoodRecipeItem 객체 배열로 변환
                let response = try JSONDecoder().decode(RecipeResponse.self, from: data)
                let recipes = response.COOKRCP01.row  // RESULT의 row에 접근
                completion(.success(recipes))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    // Helper method to generate random number
    private func getRandomNumber() -> Int {
        let randomNumber = Int(arc4random_uniform(95)) + 1
        return randomNumber
    }
}
// MARK: - API Response Models
struct RecipeResponse: Codable {
    let COOKRCP01: APIResult
}

struct APIResult: Codable {
    let RESULT: ResultInfo
    let row: [FoodRecipeItem]
}

struct ResultInfo: Codable {
    let CODE: String
    let MSG: String
}
