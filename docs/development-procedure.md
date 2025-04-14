# 開発手順

このドキュメントでは、ヘキサゴナルアーキテクチャでApexクラスを実装する場合の開発手順を解説する。

## 順番

パッケージの作成規則は[README](https://github.com/yosnak13/apex-hexagonal-architecture-research?tab=readme-ov-file#%E3%83%91%E3%83%83%E3%82%B1%E3%83%BC%E3%82%B8%E6%A7%8B%E6%88%90)に記載しているため、ここでは省略する。
受け取ったリクエストを処理する順番に開発するため、 以下の順番で実装する。なお、テストクラス設計は[README](https://github.com/yosnak13/apex-hexagonal-architecture-research?tab=readme-ov-file#%E3%83%86%E3%82%B9%E3%83%88%E3%82%AF%E3%83%A9%E3%82%B9%E8%A8%AD%E8%A8%88%E6%96%B9%E9%87%9D)に準じた形で実装する。

1. Controller
2. Service
3. Repository

---

###  1. Controller

この工程は以下を開発する。
- Controller
- Controllerのテストクラス
- Injector
- Injectorのテストクラス
- UseCaseInterface
- UseCaseMock

Controllerのほか、ControllerのテストクラスとInjectorで必要なUseCaseInterfaceとMockを作成する。  
InjectorでDIする処理にはRepositoryInterfaceとその実装クラスかMockが必要だが、`3.Repository`の開発まではInjectorの処理は暫定的なものにしておく。  
この工程では、Injectorクラスは常にUseCaseMockを返却する実装にする。

---

### 2. Service

以下クラスの開発、修正を行う。
- Serviceクラス(UseCase実装クラス)
- 上記のテストクラス
- RepositoryInterface
- RepositoryMock
- Injector
- ドメインオブジェクト
- ドメインオブジェクトのテストクラス

この工程ではUseCase実装クラスとドメインオブジェクトというビジネスロジックの実装に入るため、基本的に最もかかる工数が多い工程になる。  
UseCase実装クラスとInjector修正のために、RepositoryInterfaceと、Mockクラスを実装する。Repository実装クラスは次の工程で実装すればよい。  
この工程で、Injectorクラスの実装は以下のように修正して限りなく本番処理に近づけることが望ましいが、慣れている開発者はスキップして次の工程でまとめて変更してもよい。
- テストでない場合、RepositoryMockをフィールドにもつUseCase実装クラスを返却する。
- テストの場合、UseCaseMockを返却する

---

### 3. Repository

以下クラスの開発、修正を行う。
- Repository実装クラス
- Repository実装クラスのテストクラス
- Injector
- E2Eテストクラス

この工程で、Repository実装クラスとそのテストクラスを開発する。  
その後、E2Eテストを実装し、Injectorは以下の実装に修正する
- ControllerのUnitテストの場合、UseCaseMockを返却
- それ以外の場合、Repository実装クラスをフィールドに持つUseCase実装クラスを返却
