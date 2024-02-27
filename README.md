<p align="left">
  <img width="100" alt="image" src="https://github.com/chaeondev/zzim/assets/80023607/ce8842fb-f18c-4b96-b56d-937596b38668">
</p>

# zzim

#### 네이버 쇼핑 API를 이용한 검색 및 나만의 쇼핑리스트를 저장할 수 있는 앱입니다.

## Preview
<img width="1000" alt="image" src="https://github.com/chaeondev/zzim/assets/80023607/f9305e84-e0d6-42eb-8237-fd559edbe94f">
<br></br>

## 프로젝트 소개

> 앱 소개
- 네이버 쇼핑 API로 원하는 상품 검색 가능
- 상품 목록을 정확도, 날짜순, 가격순으로 정렬 필터링
- 좋아요 버튼으로 나의 쇼핑 목록에 저장 및 삭제 가능
- WebView를 통해 상품 상세페이지 제공

---

> 서비스
- **개발인원** : 1인 개발
- **개발기간** : 2023.9.7 - 2023.9.11 (5일)
- **협업툴** : Git
- **iOS Deployment Target** : iOS 13.0

---

> 기술스택

- **프레임워크** : UIKit, WebKit
- **디자인패턴** : MVC, Repository Pattern
- **라이브러리** : RealmSwift, Alamofire, Kingfisher, SnapKit
- **의존성관리** : Swift Package Manager
- **ETC** : CodabaseUI, Codable, UserDefaults, prefetchDataSource

---

> 주요기능
- **Alamofire** 기반 네이버 쇼핑 API 네트워크 통신으로 쇼핑 검색 기능 제공
- UICollectionView의 **prefetch** 메서드 기반 **Offset-based Pagination** 구현
- **Repository Pattern**으로 추상화한 Realm DB로 상품 좋아요 기능 제공
- **UserDefaults**를 활용해 최근 검색어 목록 **CRUD** 구현
- **WebKit**을 통해 제품 상세페이지 링크를 앱 내에서 렌더링
- **Kingfisher** 기반 이미지 **비동기 다운로드** 및 **캐싱** 구현

---

<br> </br>

## 트러블 슈팅

### 1. 상품 좋아요 연동 이슈

#### Issue
모든 화면(검색, 상세, 좋아요)에서 좋아요 **데이터가 동기화**될 수 있도록 처음에는 **viewWillAppear**에서 매번 collectionview를 **reload** 해줬습니다. 
하지만 이 경우 변화가 없어도 reload가 발생하기 때문에 계속해서 **리소스를 낭비**하는 문제가 생겼습니다.

#### Solution
Realm Object에 변화가 생겼을 때 이를 알려주는 Realm Notification이 있다는 것을 알게되었습니다. 
Notification을 객체에 설정하면, 해당 객체를 관찰하면서 데이터 변경 시점을 알 수 있었습니다.
이를 통해 데이터가 변화했을때만 collectionView를 reload함으로써 리소스 낭비를 줄일 수 있었습니다.

```swift
final class LikesViewController: BaseViewController {

    let repository = FavoriteProductRepository()

    var products: Results<FavoriteProduct>?
    //notification
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        setNotification()
    }

    private func setNotification() {
        let realm = try! Realm()
        
        products = repository.fetch()
        
        notificationToken = products?.observe{ [unowned self] change in
            switch change {
            case .initial(let products):
                print("Initial 상태 : \(products.count)")
            case .update(let products, let deletions, let insertions, let modifications):
                self.collectionView.reloadData()
            case .error(let error):
                print("Error \(error)")
            }
        }
    }
```

<br> </br>

### 2. 이미지 다운로드 시 메모리 오버헤드 이슈

#### Issue
Kingfisher를 사용해서 API 이미지를 컬렉션뷰에 보여주는 과정에서 메모리 과사용 문제가 발생했습니다.
이로 인해서 빠르게 스크롤시 이미지 로딩이 지연되었습니다.

#### Solution
Kingfisher에 이미지 캐싱과 다운샘플릭 기능을 통해서 이미지 데이터 리소스를 최소화했습니다.
이를 통해 이미지 로딩 지연 문제와 메모리 과사용 문제를 해결할 수 있었습니다.

```swift
if let imageURL = URL(string: data.image) {
    imageView.kf.setImage(with: URL(string: data.image),
                          placeholder: UIImage(systemName: "star"),
                          options: [
                            .cacheOriginalImage,
                            .scaleFactor(UIScreen.main.scale),
                            .processor(DownsamplingImageProcessor(size: CGSize(width: 200, height: 200)))
                          ])
}
```

<br> </br>
