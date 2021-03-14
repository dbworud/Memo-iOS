## Introduction
- Third-party 라이브러리를 사용하지 않고 간단한 메모장 구현하기    
- NotificationCenter에 observer를 등록하여 메모 업데이트 관찰하기
- Core Data에 내용, 날짜, 이미지를 저장할 수 있는 Memo 모델을 구현하여 Data Manager에서 save & fetch를 수행한다.

(완성된 메모 gif 첨부)

## Feature
iOS 기본앱인 메모 UI를 참고하여 비슷하게 구현하고자함 
- 기본적인 CRUD 구현 
- 메모가 데이터베이스에 남아있어 앱을 재시동해도 그대로 남아있음(Core Data)
- 메모 내용에 따른 검색 기능(UISearchController)
- 사진 첨부 기능(UIImagePickerDelegate)

## Architecture
Storyboard + MVC 패턴
- 간단한 앱인 만큼 UI를 빠르게 디자인 할 수 있고 시각적으로 뷰 컨트롤러 간의 관계를 잘 나타낼 수 있도록 스토리보드를 사용
- Core Data 로 데이터를 저장하고 가져오기 때문에 MVC로도 구현이 가능하다고 생각   
-> 다만 기능이 더욱 복잡하고 모델의 종류가 많고 여러 사람과 협업해야하는 상황엥서는 MVVM이 추후 리팩토링과 테스트 코드 작성에 있어서 유리할 것이라 생각

## TroubleShooting


## Possible Refactoring/Added
- [ ] Storyboard -> programmatically  
- [ ] RxSwift로 변형  
- [ ] SwiftUI로 변형   
- [ ] Unit/UI Test 추가      


## Reference
https://developer.apple.com/kr/  
https://devmjun.github.io/archive/SearchController   
https://betterprogramming.pub/how-to-save-an-image-to-core-data-with-swift-a1105ae2cf04  
KxCoding유튜브
