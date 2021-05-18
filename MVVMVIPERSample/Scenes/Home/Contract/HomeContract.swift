//
//  HomeContract.swift
//  MVVMVIPERSample
//
//  Created by yusuke watanabe on 2021/05/13.
//

import UIKit

// ViewはPresenterの参照を持つ
protocol HomeView: class {
    var presenter: HomePresentation { get set }
    
    // Viewに実装するメソッド
}

protocol SearchUserRequestable {
    func fetchUser(query: String) -> Observable<Profile>
}

protocol HomePresentation: class {
    // 今回はBindさせるため必要なさそう？
    var view: HomeView? { get set }
    var interactor: SearchUserUsecase { get set }
    var router: HomeWireFrame { get set }
    
    //　ライフサイクルまで管理する必要あるか？
    func viewDidLoad()
}

protocol HomeWireFrame {
    var viewController: UIViewController? { get set }
    
    func pushHomeDetail()
    static func assembleModule() -> UIViewController
}


