//
//  AddMyRecipeController.swift
//  YUMYUM
//
//  Created by 최영서 on 6/15/24.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
class AddMyRecipeController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var editmenu: UITextField!
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var editingredients: UITextView!
    @IBOutlet weak var editrecipe: UITextView!
    @IBOutlet weak var savebtn: UIButton!
    let imagePicker = UIImagePickerController()
    var recipe: Recipe?
    var isEditMode = false
    var documentID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageViewTap()
        editingredients.layer.cornerRadius=10
        editingredients.layer.masksToBounds=true
        editrecipe.layer.cornerRadius=10
        editrecipe.layer.masksToBounds=true
        if isEditMode, let recipe = recipe {
            setupEditMode(with: recipe)
        }
    }
    //이미지 뷰에 탭 제스처를 설정하는 함수
    func setupImageViewTap() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            editImage.isUserInteractionEnabled = true
            editImage.addGestureRecognizer(tapGesture)
        }
    // MARK: - Image Picker Methods
    //이미지 뷰를 탭했을 때
    @objc func imageTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Photo library not available")
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            editImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Save Button Action
    //저장버튼을 눌렀을 때
    @IBAction func saveButtonTapped(_ sender: Any) {
        //모든 필드가 비어 있지 않은지 확인
        guard let menuText = editmenu.text, !menuText.isEmpty,
            let ingredientsText = editingredients.text, !ingredientsText.isEmpty,
            let recipeText = editrecipe.text, !recipeText.isEmpty,
            let image = editImage.image else {
                print("All fields are required.")
                return
        }
        //Firebase Storage에 이미지 업로드를 위한 참조 생성
        let storageRef = Storage.storage().reference().child("recipe_images/\(UUID().uuidString).jpg")
        //이미지 데이터 업로드
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Failed to upload image: \(error)")
                    return
                }
                //이미지 업로드 성공 후 다운로드 URL 획득
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Failed to get download URL: \(error)")
                        return
                    }
                    guard let downloadURL = url?.absoluteString else { return }
                    let db = Firestore.firestore()
                    //기존 레시피가 수정 모드인 경우
                    if self.isEditMode, let recipe = self.recipe {
                        // 기존 레시피 업데이트
                        db.collection("recipes").whereField("menu", isEqualTo: recipe.menu).getDocuments { (snapshot, error) in
                        if let error = error {
                            print("Error updating document: \(error)")
                                return
                        }
                        //첫번째 문서 가져와 document변수에 할당
                        guard let snapshot = snapshot, let document = snapshot.documents.first else { return }
                        //업데이트할 데이터 준비
                        let updatedData: [String: Any] = [
                            "menu": menuText,
                            "ingredients": ingredientsText,
                            "recipe": recipeText,
                            "image_url": downloadURL
                        ]
                        //Firestore 문서 업데이트
                        db.collection("recipes").document(document.documentID).updateData(updatedData) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Document successfully updated!")
                                //이전페이지로 돌아감 AddMyRecipeController->CookShareController
                                self.navigationController?.popViewController(animated: true)
                                self.showAutoDismissAlert(title: "알림", message: "레시피가 수정되었습니다")
                                }
                            }
                        }
                    } else {    //레시피 추가 모드일 경우
                    // 새로운 레시피 저장
                    let newData: [String: Any] = [
                        "menu": menuText,
                        "ingredients": ingredientsText,
                        "recipe": recipeText,
                        "image_url": downloadURL
                    ]
                    db.collection("recipes").addDocument(data: newData) { error in
                        if let error = error {
                            print("Error saving document: \(error)")
                        } else {
                            print("Document successfully saved!")
                            //이전페이지로 돌아감 AddMyRecipeController->CookShareController
                            self.navigationController?.popViewController(animated: true)
                            self.showAutoDismissAlert(title: "알림", message: "레시피가 추가되었습니다")
                        }
                    }
                }
            }
        }
    }
}
    // MARK: - Helper Methods
    func clearFields() {
        editmenu.text = ""
        editingredients.text = ""
        editrecipe.text = ""
        editImage.image = nil
    }
    func setupEditMode(with recipe: Recipe) {
        editmenu.text = recipe.menu
        editingredients.text = recipe.ingredients
        editrecipe.text = recipe.recipe
        if let imageUrl = URL(string: recipe.imageUrl) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        self.editImage.image = UIImage(data: imageData)
                    }
                }
            }
        }
        // Get the document ID for the recipe
        let db = Firestore.firestore()
        db.collection("recipes").whereField("menu", isEqualTo: recipe.menu)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting document: \(error.localizedDescription)")
                } else {
                    self.documentID = snapshot?.documents.first?.documentID
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
}
