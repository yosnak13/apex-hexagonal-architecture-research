# 課題:「**Salesforceのカスタム開発に最適なデザインパターン（候補はクリーンアーキテクチャ、Apex Enterprise Pattern）を探求し、1レポジトリ分のアプトプットを出す**」

## 課題に取り組んだ理由

FY25下期の課題にしていた。
- 現場でよくないコード(多重ネスト、非DRY、密結合、低凝集、低テスタビリティetc...)があり、その修正に必要以上に苦労した経験があり、その苦悩からこれらを再生産してはならないと思った
- ソフトウェアデザインパターンに関して積極的にトライしている人が、同じ部署内にいなかった
- Apexは文法はJavaとよく似ていながら、フロントエンドからの呼び出し〜レコード取得まで簡潔に書ける反面、ビジネスロジックが複雑になるほど、1つのクラスにソースコードが入り乱れて保守性が低下していた(デザインパターンというより、マネジメント力や綺麗なコードへの関心の低さにも原因がある)
- Apexは、Javaなどと比較して以下のような便利な機能がないが、便利なものに頼れないからこそデザインパターンの実装にトライすることで、Salesforceとの相性や実現性可否など一定の成果は得られると期待した
  - パッケージ
  - パッケージプライベート
  - DIコンテナ
  - ライブラリ

↓

紆余曲折あり、まず「ヘキサゴナルアーキテクチャ」にトライすることとした

## なぜヘキサゴナルアーキテクチャ?

- Web開発にて、過去にクリーンアーキテクチャで実装されたソフトウェアの運用保守を経験させてもらい、高テスタビリティ、変更容易性、疎結合、原因特定容易性など数多くの恩恵を受けた
- クリーンアーキテクチャそのものを正しく理解できていなかった部分があった(特に依存を許可する方向)ため、再学習したかった
- 候補としてクリーンアーキテクチャを選択したが、他の応用した設計を知りたいと考えた。ヘキサゴナルアーキテクチャは、クリーンアーキテクチャがベースで、ビジネスロジックが外部の技術に依存しないように設計する点が魅力的だった

# Apexクラスのヘキサゴナルアーキテクチャ実装方針

ヘキサゴナルアーキテクチャで実装するケースを実装を検証する。  
ヘキサゴナルアーキテクチャについて、このREADMEでは詳しく解説できないが、実装は以下の書籍に準じている。 
- [手を動かしてわかるクリーンアーキテクチャ　ヘキサゴナルアーキテクチャによるクリーンなアプリケーション開発](https://amzn.asia/d/dugG7Cw)

本プロジェクトでは、ヘキサゴナルアーキテクチャ（Hexagonal Architecture） に基づいた構成を採用。  
ヘキサゴナルアーキテクチャ（Hexagonal Architecture）は、2005年にAlistair Cockburn氏によって提唱されたソフトウェア設計のアーキテクチャパターン。  
このスタイルは、柔軟性、疎結合性、テスタビリティを向上させることを目的とし、「ポートとアダプター」（Ports and Adapters）とも呼ばれることがある。  

具体的には、アプリケーションの **ビジネスロジック(ユースケース、ドメイン)を中心に据え、  
外部との接続（UI、DB、APIなど）を「ポート」と「アダプター」** という明確なインターフェースで分離する設計思想である。

## 基本概念

ヘキサゴナルアーキテクチャは、以下のような構造を持つ:
- ビジネスロジック: システムの中心部分であり、ユースケースやビジネスルールを実現する
- ポート（インターフェース）: ビジネスロジックと外部システムを繋ぐ抽象化されたインターフェース
- アダプター（実装）: ポートを通じて外部システムと連携する具体的な実装部分。例としてデータベースアクセスや外部APIの呼び出しなどが含まれる
- この構造により、ビジネスロジックは外部技術やインフラストラクチャの変更から切り離され、独立してテスト可能に

<img width="863" alt="hexagonal" src="https://github.com/user-attachments/assets/33551d56-bfa0-4ddf-9246-c31de9a3fa7e" />

## Salesforceにおける、レイヤー構成の概要

```shell
[ Trigger / Flow / Apex Controller ]      ← 外部ドライバ  
              ↓  
[ Port Interface (e.g. UseCaseInterface) ]  ← Port(受信ポートInterface)
              ↓  
[ Application Services ]                  ← ビジネスロジック(UseCase)
              ↓  
[ Port Interface (e.g. Repository) ]      ← Port(送信ポートInterface)
              ↓  
[ Adapter (SOQL/DML/External Services) ]  ← 外部アダプタ  
````

Application Services*: ここでは、アプリケーションの「ユースケース（ビジネス処理の流れ）」を手続き的にまとめたレイヤーとしており、  
ドメインロジックを直接持つのではなく、「何をするか」「どの順でどう操作するか」という処理の **オーケストレーション（指揮役）** を担う。

## 六角形の由来

P.45~46より引用、要約
> 名前の由来である六角形(hexagon)で表現していますが、六角形であることに意味はありません。  
> 伝え聞きによると、アプリケーションには他のシステムやアダプタと接続する部分が4つ以上あることを示したかったからです。

## パッケージ構成

前提として、Apexにパッケージの概念はないが、伝達容易性の観点から、ディレクトリではなくパッケージという単語をあえて使用することとする。

- 機能単位のパッケージを、classesディレクトリに作成(例: 取引先窓口登録 -> register-contact)して、その配下に、規則に基づいた資材を開発する
- この機能単位とは、ドメイン単位で設計されることとし、決してオブジェクト単位で設計するものではない(取引先オブジェクトにまつわる機能だからAccount、という安易なパッケージ作成はしないこと。取引先の登録という仕事であるならば、register-accountとする)
- パッケージの概念がないため、かわりにディレクトリを作成して表現することとする
- 別機能の資材へアクセスすることは禁止する。(e.g. register-accountという機能と、select-contactという機能がある場合、register-accountはselect-contactの資材にアクセスできない。アクセス修飾子のほとんどはpublicで宣言せざるを得ないため、運用ベースで禁止とする)
  - しかし、ドメインオブジェクトは重要なビジネスロジックを持つことから再利用性が高いことが想定され、この制限やパッケージ構成の変更には一考の余地がある

### 具体的な構成

diパッケージを除き、書籍の第4章に沿って、以下で実装している。  

- diパッケージは、以下の理由から独自に実装した
  - ApexにDI機能が存在しないため
  - ビジネスロジック(UseCase層)が永続化層に依存しないようにするため、UseCase層の外側で永続化層と同じ層であるadapter層の関心ごとと考えたため

```shell
.
├── force-app
│   └── main
│       └── default
│           ├── classes
│           │   └── register-contact
│           │       ├── adapter
│           │       │   ├── di
│           │       │   │   └── DIクラス
│           │       │   ├── in
│           │       │   │   └── web
│           │       │   │       └── Controllerクラス
│           │       │   └── out
│           │       │       └── persistence
│           │       │           └── 永続化層実装クラス
│           │       └── application
│           │           ├── domain
│           │           │   ├── service
│           │           │   │   └── UseCase実装クラス
│           │           │   └── domainオブジェクト名
│           │           │   │   └── ドメインオブジェクト
│           │           └── port
│           │               ├── in
│           │               │   └── UseCaseInterface
│           │               │   └── input
│           │               │       └── UseCase入力モデル
│           │               └── out
│           │                   └── 永続化層Interface
```

第4章では、機能単位で層を意識したパッケージを構成したときの構成例を提案しているに過ぎない。  
そのため、パッケージ構成の最適解はプロジェクトや設計者の考えに左右するものと考える。

## Adapter

解説

- アプリケーションの核とのコミュニケーションをとる
- DBやUIとのやりとりを行う。アダプタを変更することで、異なるDBやUI、プロトコルに対応することが容易にすることを狙う。つまり、ビジネスロジック(UseCase層)が外側の技術に影響を受けづらくするための、クッション材の役割と言える

### in.web

- Controllerサフィックスを付与したクラスを実装し、責務を以下とする。これは、ビジネスロジック(UseCase層)が外側の技術に影響を受けないためにする
  - フロントからのパラメータ受け取り、UseCaseの呼び出しとその結果の返却
  - リクエストパラメータをUseCaseが解釈可能なフォーマットに整形
  - UseCaseからの返却値を、呼び出し元が解釈可能なフォーマットに再整形
- 複数のLWCからの呼び出しはOKだが、単一責務の原則とテスト容易性担保のため、`@AuraEnable`アノテーションを付与するpublicメソッドは1つのみとする

### out.persistence

- この層は、永続化層とAPI等外部システムへのアクセスを責務とする
- 実装クラス命名は、データ操作ロジック以外の意味合いを持たない場合、Implサフィックスを付与する

### di

ここのみ、書籍に存在しないパッケージとして作成している。以下に理由と実装規則を記述する

- Java(SpringBoot)のように、DIコンテナでインスタンス生成ができないため、独自にDIする仕組みが必要なため実装する
- UseCaseインターフェースを実装するクラスのインスタンスをビルドすることのみを責務とする
- 命名はInjectorサフィックスを付与する
- 他の機能の資材からや、`Controller`以外からアクセスすることを禁止する
- テストかつ、カスタム設定のApexTestSetting__c.IsE2ETest__c = trueの場合、以下のようにUseCaseのMockではなく実装クラスを返すようにする。これはAdapterに実装するE2Eテストで利用する。このカスタム設定は、後述の「テストクラス設計方針」で解説する

```cls
public with sharing class RegisterContactInjector {
  public static RegisterContactUseCase newRegisterContactUseCase() {
    // E2Eテストのために、カスタム設定の項目値を利用するしかない。Unitテスト以外は実装クラスを返す
    if (isUnitTest()) return new RegisterContactServiceMock();

    return new RegisterContactService(new FindAccountRepositoryImpl(), new RegisterContactRepositoryImpl());
  }

  private static Boolean isUnitTest() {
    return Test.isRunningTest() && !ApexTestSetting__c.getInstance().IsE2ETest__c;
  }
}
```

## Application

解説

- port: ビジネスロジックが外部システムと通信するためのインターフェース。具体的な処理をビジネスロジックから切り離し、どのように外部とやり取りするかを定義し、ビジネスロジックがどのような技術に依存するかを知らずに済むようになる
- domain, serviceは下部で詳しく記載

### port.in

- 受信ポートとして、UseCaseインターフェースを提供する。実装はApplicationの核となるUseCaseによって実装される
- UseCaseが入力モデルを必要とする場合、このパッケージ内に作成する。UseCaseが処理できる形式を、UseCaseInterfaceを提供するport内で定義してAdapterに要求する意味合い
- それ以外は提供しないこと

### port.out

- 送信ポートして、永続化層インターフェース(Repository)を提供する。実装は、UseCaseから呼び出される送信アダプタによって実装される
- それ以外は提供しないこと

### domain

- ドメインオブジェクトの実装をする
- クラスの意味や責務をクラス名から読み取れるよう、以下の規則で実装する
    - 値オブジェクトは、Voサフィックスを付与する
    - Entityは、Entityサフィックスを付与する
    - Collectionは、Collectionサフィックスを付与する
- 独自の例外はここに実装する

### service

- UseCaseInterfaceを実装したクラスを実装する。この層の責務は以下とする
    - 永続化層の呼び出し
    - ドメインオブジェクトのビジネスロジックの呼び出し
    - ビジネスロジック実行で得た生成値を、呼び出し元に返却
- application.port.inパッケージに宣言されているUseCaseInterfaceを実装
- フィールドには永続化層のInterfaceを持たせて、永続化層のメソッドは抽象化させておく(多態)
- 別のAdapterからの再利用は禁止
- publicメソッドは`exec`のみとし、それ以外は実装しない

## 開発手順

- [docs/development-procedure.md](./docs/development-procedure.md)に記載の通りに進める

## テストクラス設計方針

- adapter
  - Controller:
    - InjectorでUseCaseのMockを返却するようにして、UseCaseのMockがコールされたことを確認する
    - 永続化層までの開発を終えたら、E2Eテストを以下のように実装する
      - adapter.inパッケージ内に実装する
      - 命名はController名+E2E+Testとする
      - テストメソッド内で後述するカスタム設定をINSERTし、Injectorのロジックを利用してUseCaseの実装クラスを呼び出して、Repositoryの実装クラスを呼び出す
        - ControllerとInjectorとの結合度が上がっていることを意味するが、システムへ与える悪影響はなくメリットが大きいため許容する。ライブラリ等を使ったテストクラスでMockの呼び出し制御ができないApexの限界と考えている
  - Injector:
    - テストではUseCaseMockを返し、InjectorインスタンスがNullでないことを確認する
      - これはJava等と異なり、instance ofでフィールドのクラスが想定するInterfaceを実装しているかの検証ができないため
      - ビルドしたUseCaseインスタンスのexec()メソッドを実行させて、フィールドに持たせた永続化層のMockの挙動を確認するという方法が取れるが、ControllerとUseCaseでそれを検証するので不要と考えた
  - Repository
    - データ取得がSOQLの場合、SOQLレコード操作に関するテストを実装する
    - 外部システムへのAPIコールアウトが存在する場合、レスポンスをMockできるクラスを実装してテストする
- application
  - UseCase(Service)
    - テストクラス内でのインスタンス初期化時、永続化層のMockをフィールドに持たせて初期化し、Mockが挙動通りに動作することで想定通りのロジックが実行されるか確認
  - VoやEntityなどのドメインオブジェクト、UseCase入力モデル
    - 値の検証と、メソッドのロジックが正しく挙動するか確認
    - 以下の条件を満たす場合、private修飾子をもつgetterを定義し、`@TestVisible`アノテーションを付与し、テスト専用のgetterを作成して値を検証する
      - フィールドにfinal修飾子を付与してカプセル化するが、フィールドを使ったインスタンスメソッドを定義できない場合に、フィールドの値の検証をする場合
      - 本番環境で他のクラスに値を提供するためのgetterを定義する必要がない場合
    - [補足]本来、テストコードのためだけのメソッドを実装するのは望ましくない。しかし、フィールドのテストのためにフィールドをpublicにしてカプセル化を崩したり、フィールドに`@TestVisible`を付与してカプセル化したいのかどうかの意図が不明に見えるくらいなら、テスト用のプライベートgetterを実装した方が使われない本番用メソッド実装を防ぐ効果があり、フィールドを外部から秘匿したい意図が理解できるため。
- mock
  - Mockサフィックスを付与し、クラス名は~Mockとなる
  - mockには`@IsTest`アノテーションをクラスに付与し、mockに対するテストクラス実装は不要とする
  - 修正により実装クラスの挙動が変わる場合、Mockもそれに沿う挙動をするよう正しくメンテナンスする

### テストクラスで使用するカスタム設定

- ApexTestSetting__cというカスタム設定があり、IsE2ETest__cという項目を持ち、値はfalseで保存されている。
- E2Eテスト実行時、テストメソッド内で、IsE2ETest__c = trueでINSERTする。

## その他

- ディレクトリ・パッケージはケバブケースとする

## 実践してみて、気がついたいい点

- ビジネスロジックが複雑になるほど、真価を発揮できると実感
- classes配下は機能単位でパッケージしていくため、何の機能の資材か迷子になりづらい（余計な機能を持たせる機会を、いい意味で剥奪している）
- ビジネスロジックはdomain層に集約されており、デザインパターンがないより明らかにスパゲティコードになりづらい
- Interfaceを介して層ごとに疎結合なので、テスト容易性は非常に高い印象（テスト時にMockに置き換えられるのは改めて便利）
- adapterが外部技術の都合を全て吸収する設計であるため、ビジネスロジックを外部技術の都合から保護できる

## 実践してみて、課題と思った点

### 実装面での課題

- パッケージプライベートにできないため、public修飾子を持つメソッドやクラスに他の機能単位のクラスが実質アクセス可能。運用ベースで防ぐしかない（これはSalesforceが提唱する、ApexEnterprisePatternsも同様）
- パッケージ単位で資材を開発するが、どうしても再利用すべきドメインオブジェクトが出現することが予想され、その場合は再利用しずらい。この制限を廃止するか、パッケージ構成を見直す余地がある

### salesforce機能との衝突

- 書籍では、UseCaseの入力モデル(値オブジェクト)では、UseCaseInterface実装クラスが汚れるのを避けるため入力値チェックを行わなくて良いとするが、入力値は正しくバリデーションしないと、INSERT・UPDATE時に入力規則に引っかかるため、入力規則に基づいた実装は必要になる
- sObjectを返却したい場合、sObjectをフロントに返す必要があり、ビジネスロジック層がSOQL技術に対して依存することを意味する。ApexがSOQLとしかやり取りしないのであれば影響はほとんどなく大したことがないが、例外的に依存を認める必要がある。メリットはあるため考えるため個人的には例外的に依存をOKとしたい
- 大規模開発向けであることは間違いない。Idからオブジェクトをクエリするだけなら、このアーキテクチャはSFのメモリやCPUリソースを無駄遣いする実装とも言えてしまう
  - ビジネスロジックをもたない単なるクエリとの棲み分けを考える必要はありそうで、LWCのLightningデータサービスが使えるならそちらを優先すべきなのは確か
  - ただし、それを上回る可読性の良さ、高テスタビリティを実現できるとも言える

```cls
public with sharing class RegisterContactController {
  // 初期版のregister-accountを例に、アーキテクチャなし版の開発と比較する。
  // 今回実装分。レイヤーに基づいて必要なインスタンスをビルドして処理させる。adapterに加え、Injector、usecase実装クラス、repository実装クラスの合計4つビルドする
  public static void register(final Id accountId, final String contactName, final String email) {
    RegisterContactController controller =
        new RegisterContactController(RegisterContactInjector.newRegisterContactUseCase());

    try {
      controller.registerContactUseCase.exec(new RegisterContactInput(accountId, contactName, email));
    } catch (HandledException e) {
      throw new HandledException(REGISTER_FAILED_MESSAGE + e.getMessage());
    }
  }

  private RegisterContactController(final RegisterContactUseCase registerContactUseCase) {
    this.registerContactUseCase = registerContactUseCase;
  }
  
  ↓
  
  // 依存性を無視してSOQLを実装すると、このクラス1つで完結する。
  // Interfaceを実装しないためmockは使えないほか、このコードのテストクラスではあらゆる条件（正常処理のほか、ガード節ごとの例外処理、メール文、ロールバック処理など）に対応したケースを作る必要ががあり、かなりの行数が必要。
  // ビジネスロジックが複雑化するほど、この実装はスパゲティコードになりがち。
  private static final String EMAIL_PATTERN =
      '^(?!\\.)(?!.*\\.\\.)[a-zA-Z0-9._%+-]+(?<!\\.)@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*(\\.[a-zA-Z]{2,})$';
  private static final Integer MAX_LENGTH = 80; // Salesforce上の最大値
  private static final String ILLEGAL_MESSAGE = '姓は必須項目で、80文字以内である必要があります。';
  
  @AuraEnabled
  public static void register(Id accountId, String contactName, String email) {
    if (!acctIdVo.getSobjectType().getDescribe().getName().equals(ACCOUNT)) {
      throw new IllegalArgumentException('AccountのIdではありません');
    }
    if (String.isBlank(email) || !Pattern.matches(EMAIL_PATTERN, email)) {
      throw new IllegalArgumentException('無効なメールアドレスです。');
    }
    if (String.isBlank(lastName) || lastName.length() > MAX_LENGTH) throw new IllegalArgumentException(ILLEGAL_MESSAGE);
    
    Account[] accts = [SELECT Id FROM Account WHERE Id = :accountId()];
    if (accts.isEmpty()) throw new HandledException('No Account Is Exist.');
    
    Savepoint sp = Database.setSavepoint();
    try {
      insert new Contact(AccountId = :accountId, LastName = contactName);
      Messaging.sendEmail(new Messaging.SingleEmailMessage[]{toEmailMessage});
    } catch (EmailException e) {
      Database.rollback(sp);
      throw new HandledException(e.getMessage());
    }
    
    private Messaging.SingleEmailMessage toEmailMessage() {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setToAddresses(new List<String>{ email });
      mail.setSubject("【ようこそ】" + contactName + " 様");
      mail.setHtmlBody(buildHtmlBody());
      return mail;
    }

    private String buildHtmlBody() {
      return ''
          + '<!DOCTYPE html>'
          + '<html>'
          + '<head><meta charset="UTF-8"><style>'
          + '  body { font-family: Arial, sans-serif; line-height: 1.6; }'
          + '  .content { padding: 20px; background: #f9f9f9; border-radius: 10px; }'
          + '</style></head>'
          + '<body>'
          + '  <div class="content">'
          + '    <h2>' + contactName + " 様" + '</h2>'
          + '    <p>この度はご登録いただき、誠にありがとうございます。</p>'
          + '    <p>ご不明点等ございましたら、お気軽にご連絡ください。</p>'
          + '    <p>今後ともよろしくお願いいたします。</p>'
          + '  </div>'
          + '</body>'
          + '</html>';
    }
  }
}
```
- ApexTriggerはDBから発火するため、ヘキサゴナルアーキテクチャ的には一番外のDBレイヤーからのリクエストに該当する。そのため、Triggerディレクトリ内にハンドラークラスを実装し、Register.inパッケージ内に実装したクラス（Controller）を呼び出す処理にすればいい
  - しかし、特定の項目を更新する、というような簡素な処理である場合は、やはり実装が大袈裟になりがちに見えてしまう簡潔な処理しかしないトリガーである場合は、Apexトリガーではなくフロートリガーに任せた方がいい

## 個人的総評

- 相性が悪い部分は当然あるが、活かせないということは全くない。
- 特に保守しやすいコードにする、という点においては、正しく実装すれば十分に保守しやすいコードになりうると考えている。
- デザインパターンやドメイン知識の解釈とソフトウェアへの実装が難しいだけけあり、学習コストはかかる(ソフトウェアデザインパターンの理解・習得は一朝一夕ではない)
- Salesforceそのものが、データ駆動な製品といえることを再確認した。sObjectを大切にしており、カスタムApexクラスをLWCに返却する実装にすると、オブジェクト権限や項目レベルセキュリティ等は無視した実装となり、相性が悪いので適材適所とする必要あり
  - SOQLと密結合しているだけあり、意外とデータ駆動設計の方が都合がよかったりするのだろうか
