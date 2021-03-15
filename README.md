## Introduction
- 2021/3/10~
- Third-party 라이브러리를 사용하지 않고 간단한 메모장 구현    
- NotificationCenter에 observer를 등록하여 메모 업데이트 관찰
- Core Data에 내용, 날짜, 이미지를 저장할 수 있는 Memo 모델을 구현하여 Data Manager에서 save & fetch

<img width="30%" src="https://user-images.githubusercontent.com/59492694/111099209-5bf8a380-8588-11eb-9915-a6770ed8ed2d.mov"/>

## Feature
iOS 기본앱인 메모 UI를 참고하여 비슷하게 구현하고자함 
- 기본적인 CRUD 구현 
- 메모가 데이터베이스에 남아있어 앱을 재시동해도 그대로 남아있음(Core Data)
- 메모 내용에 따른 검색 기능(UISearchController)
- 사진 첨부 기능(UIImagePickerDelegate)
- swipeAction으로 share, delete 구현 
- Dark Mode 지원


## Architecture
**Storyboard + MVC 패턴**
- 간단한 앱인 만큼 UI를 빠르게 디자인 할 수 있고 시각적으로 뷰 컨트롤러 간의 관계를 잘 나타낼 수 있도록 스토리보드를 사용
- Core Data 로 데이터를 저장하고 가져오기 때문에 MVC로도 구현이 가능하다고 생각   
-> 다만 기능이 더욱 복잡하고 모델의 종류가 많고 여러 사람과 협업해야하는 상황엥서는 MVVM이 추후 리팩토링과 테스트 코드 작성에 있어서 유리할 것이라 생각  

<img width="40%" src="https://user-images.githubusercontent.com/59492694/111099099-1f2cac80-8588-11eb-926f-7e48a448a567.jpeg"/>



## TroubleShooting
**- UIImagePickerDelegate 이용해서 이미지를 저장했으나, DetailViewController에서 이미지를 가져오지 못하는 오류 발생**   
breakpoint를 걸어서 확인  
<이미지와 함께 메모를 저장>   
<img width="723" alt="breakpoint1" src="https://user-images.githubusercontent.com/59492694/111097173-5e58fe80-8584-11eb-9903-11a2a0f97fc0.png">

<DetailViewController에서 이미지를 불러올 때 nil로 나타남> 
<img width="581" alt="breakpoint2" src="https://user-images.githubusercontent.com/59492694/111097272-906a6080-8584-11eb-8e3b-742ab19e23c0.png">

-> 원인: 메모를 저장할 때, 내용+날짜+이미지를 한번에 저장하는 메소드를 구현했어야하는데 메소드를 분리해서 구현한 점이 문제의 원인   
-> 해결방법: StackOverflow에 질문 올려서 해결    
https://stackoverflow.com/questions/66621005/how-can-i-fix-error-that-cant-fetch-image-from-core-data/66622315#66622315


**- UISearchController의 searchBar를 탭하면 unwrapping을 해주지 않아 런타임 오류 발생**

<img width="1103" alt="runtimeerror" src="https://user-images.githubusercontent.com/59492694/111097884-be03d980-8585-11eb-8516-9302877f05cb.png">

-> 해결방법: if let으로 unwrapping   

<img width="600" alt="solved" src="https://user-images.githubusercontent.com/59492694/111098035-01f6de80-8586-11eb-9913-212df7bb3215.png">


## Possible Refactoring/Added
- [ ] Storyboard -> programmatically  
- [ ] RxSwift로 변형  
- [ ] SwiftUI로 변형   
- [ ] Unit/UI Test 추가
- [ ] 메모 theme 변경 기능 추가
- [ ] 총 메모 개수 하단에 표시


## Reference
https://developer.apple.com/kr/  
https://devmjun.github.io/archive/SearchController   
https://betterprogramming.pub/how-to-save-an-image-to-core-data-with-swift-a1105ae2cf04  
KxCoding유튜브
