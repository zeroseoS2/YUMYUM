# 🍽️YUMYUM

YUMYUM은 사용자가 원하는 레시피를 제공하며 자신의 레시피를 공유할 수 있는 앱


## 개요
<div style="border: 1px solid #e1e4e8; color:#000000; padding: 16px; border-radius: 8px; background-color: #d4e7fa;">
이 앱은 사용자가 원하는 메뉴의 레시피를 한눈에 보기 쉽게 제공한다. Swift를 사용해 iOS 앱을 개발한다. 공공데이터OpenAPI에서 조리식품의 레시피를 사용하여 레시피 정보를 제공하고, Firebase를 백엔드로 활용하여 사용자 인증, 데이터를 저장하여 구현한 앱이다.</div>


## 주요 기능
- Firebase Authentication를 활용한 로그인과 회원가입
- pickerview를 통해 오늘의 메뉴 랜덤 제공
- 메뉴명, 재료 검색 기능
- firestore와 storage를 활용한 레시피 추가, 수정, 삭제 기능


### Memo 실행 화면
<div align="center">
  <img width="210" alt="KakaoTalk_20240708_010022106" src="https://github.com/user-attachments/assets/80cc6cb3-85a3-4fbf-ab90-ca4e71954f9d">
  <img width="210" alt="KakaoTalk_20240708_010022106_01" src="https://github.com/user-attachments/assets/0a90f0ec-2b37-4b18-bc26-a4442d64447f">
  <img width="210"" alt="KakaoTalk_20240708_010022106_02" src="https://github.com/user-attachments/assets/fdc04145-99f4-4d1f-93fb-ac4fbc95b8fb">
  <img width="210"" alt="KakaoTalk_20240708_010022106_03" src="https://github.com/user-attachments/assets/781ae0c8-3237-439a-a4cd-f1eab1c1f4d6">
  <img width="210" alt="KakaoTalk_20240708_010022106_04" src="https://github.com/user-attachments/assets/34a743b6-0ddc-4022-bbc2-107b58b46930">
  <img width="210" alt="KakaoTalk_20240708_010022106_05" src="https://github.com/user-attachments/assets/6b9858f4-00b1-44b0-b83b-389dfa91798d">
  <img width="200"" alt="KakaoTalk_20240708_010022106_06" src="https://github.com/user-attachments/assets/4d887408-4538-4072-b198-5c1907c2a0db">
  <img width="210" alt="KakaoTalk_20240708_010022106_07" src="https://github.com/user-attachments/assets/893e346e-ac42-45e1-9e32-5e23794b5b2b">
  <img width="210" alt="KakaoTalk_20240708_010022106_08" src="https://github.com/user-attachments/assets/1e1ba5e2-c1c0-412a-9251-a16eaf8ef380">
  <img width="210" alt="KakaoTalk_20240708_010022106_09" src="https://github.com/user-attachments/assets/bd3407de-5368-41c1-8213-3c2f2178b7c5">
</div>


## 사용 기술

- **프론트엔드:**
  - 개발 언어: Swift
  - 플랫폼: iOS
  - UI/UX: UIKit를 사용하여 사용자 인터페이스 구현
- **백엔드:**
  - 플랫폼: Firebase
  - 서비스: Firebase Authentication, Firebase Firestore, Firebase Storage

 
## 기대효과

- **사용자 편의성 향상:** 복잡한 요리 레시피를 간단하고 직관적인 UI를 통해 한눈에 확인할 수 있어, 요리 초보자부터 전문가까지 손쉽게 레시피를 검색하고 이용할 수 있습니다.
- **효율적인 검색 기능:** 메뉴명이나 재료를 기반으로 검색할 수 있어 사용자가 원하는 레시피를 빠르게 찾을 수 있습니다. 검색 결과는 테이블 뷰에 정렬되어 제공되므로 손쉬운 탐색이 가능합니다.
- **사용자 간 레시피 공유:** 사용자가 직접 레시피를 추가하고 공유할 수 있어, 다양한 사용자들의 요리 노하우를 나누며 커뮤니티 형성에 기여할 수 있습니다. 레시피를 수정하거나 삭제할 수 있는 기능도 있어 관리가 용이합니다.
- **공공 데이터를 활용한 레시피 제공:** OpenAPI에서 제공하는 공공 데이터를 사용하여 다양한 조리식품의 레시피를 제공함으로써 신뢰성과 다양성을 확보할 수 있습니다.


## 기여 방법

1. 이 저장소를 포크합니다.
2. 새로운 브랜치를 만듭니다 (`git checkout -b feature/your-feature`).
3. 변경 사항을 커밋합니다 (`git commit -m 'Add some feature'`).
4. 브랜치에 푸시합니다 (`git push origin feature/your-feature`).
5. 풀 리퀘스트를 작성합니다.


## 문의

프로젝트에 대한 문의 사항은 [netism5g5952@gmail.com](mailto:netism5g5952@gmail.com)으로 연락해 주세요.
