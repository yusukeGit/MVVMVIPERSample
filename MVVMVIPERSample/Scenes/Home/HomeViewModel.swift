//
//  HomeViewModel.swift
//  MVVMVIPERSample
//
//  Created by yusuke watanabe on 2021/04/21.
//

import Foundation
import RxCocoa
import RxSwift

final class HomeViewModel {
    // viewControllerから初期化する必要ある？
    private let searchUserModel: SearchUserRequestable
    private let disposeBag = DisposeBag()
    
    var profile: Profile {
        return _profile.value
    }
    
    private let _profile = BehaviorRelay<Profile>(value: Profile.init(login: "", url: URL(string: "")!, name: nil, email: nil))
    
    // observables
    var deselectRow: Observable<IndexPath>
    let reloadData: Observable<Void>
    let transitionToUserDetail: Observable<Profile>
    
    init(searchBarText: Observable<String?>,
         searchButtonClicked: Observable<Void>,
         itemSelected: Observable<IndexPath>,
         searchUserModel: SearchUserRequestable = SearchUserUsecase(provider: GithubProvider.default)) {
        self.searchUserModel = searchUserModel
        self.deselectRow = itemSelected.map { $0 }
        self.reloadData = _profile.map { _ in }
        self.transitionToUserDetail = itemSelected
            .withLatestFrom(_profile) { ($0, $1) }
            .flatMap { indexPath, profile -> Observable<Profile> in
                guard indexPath.row < profile.name?.count ?? 99 else {
                    return .empty()
                }
                return .just(profile)
            }
        
        
        let searchResponse = searchButtonClicked
            .withLatestFrom(searchBarText)
            .flatMapFirst { [weak self] text -> Observable<Event<Profile>> in
                guard let me = self, let query = text else {
                    return .empty()
                }
                return me.searchUserModel
                    .fetchUser(query: query)
                    .materialize()
            }
            .share()
        
        searchResponse
            .flatMap { event -> Observable<Profile> in
                event.element.map(Observable.just) ?? .empty()
            }
            .bind(to: _profile)
            .disposed(by: disposeBag)
        
        searchResponse
            .flatMap { event -> Observable<Error> in
                event.error.map(Observable.just) ?? .empty()
            }
            .subscribe(onNext: { error in
                // TODO: Error Handling
            })
            .disposed(by: disposeBag)
    }
}
