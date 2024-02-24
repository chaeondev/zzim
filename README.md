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

### 1. 
