//
//  GithubProvider.swift
//  MVVMVIPERSample
//
//  Created by yusuke watanabe on 2021/04/22.
//

import Foundation
import Alamofire
import Moya

func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}

class DefaultAlamofireManager: Alamofire.Session {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}

protocol GithubProviderLoadable {
    func load() -> MoyaProvider<GithubAPI>
}

struct NormalGithubProvider: GithubProviderLoadable {
    func load() -> MoyaProvider<GithubAPI> {
        return MoyaProvider<GithubAPI>(session: DefaultAlamofireManager.sharedManager)
    }
}

enum GithubProvider {
    case `default`
    var provider: GithubProviderLoadable {
        switch self {
        case .default:
            return NormalGithubProvider()
        }
    }
}
