//
//  SearchUserUsecase.swift
//  MVVMVIPERSample
//
//  Created by yusuke watanabe on 2021/04/22.
//


import Moya
import RxSwift

protocol SearchUserRequestable {
    func fetchUser(query: String) -> Observable<Profile>
}


final class SearchUserUsecase: SearchUserRequestable {
    private let provider: GithubProviderLoadable

    init(provider: GithubProvider) {
        self.provider = provider.provider
    }
    
    func fetchUser(query: String) -> Observable<Profile> {
        let githubProvider = provider.load()
        return Observable.create { [weak self] (observer) in
            guard let self = self else {
                return Disposables.create()
            }
            
            // 本来は通信処理
            githubProvider.request(.fetch, completion: { (result) in
                switch result {
                case let .success(response):
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let data = try response.filterSuccessfulStatusCodes().data
                        let profile = try jsonDecoder.decode(Profile.self, from: data)
                        observer.onNext(profile)
                        observer.onCompleted()
                    } catch let error {
                        observer.onError(error)
                    }

                case let .failure(error):
                    observer.onError(error)
                }
            })
            
            // 終了時の処理
            return Disposables.create {
                
            }
        }
    }
    
    
}
