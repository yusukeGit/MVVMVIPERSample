//
//  GithubAPI.swift
//  MVVMVIPERSample
//
//  Created by yusuke watanabe on 2021/04/22.
//

import Foundation
import Moya

enum GithubAPI {
    // パスごとにcaseを切り分ける
    case fetch
}

extension GithubAPI: TargetType {
    // ベースのURL
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    // パス
    var path: String {
        switch self {
        case .fetch:
            let userName = "yusukeGit"
            return "/users/\(userName)"
        }
    }
    
    // HTTPメソッド
    var method: Moya.Method {
        switch self {
        case .fetch:
            return .get
        }
    }
    
    // スタブデータ
    var sampleData: Data {
        return Data()
    }
    
    // リクエストパラメータ等
    var task: Task {
        switch self {
        case .fetch:
            return .requestPlain
        }
    }
    
    // ヘッダー
    var headers: [String: String]? {
        return nil
    }
}

enum UserType: String {
    case all
    case owner
    case member
}

enum Sort: String {
    case created
    case updated
    case pushed
    case fullName = "full_name"
}

enum Direction: String {
    case desc
    case asc
}

struct Profile: Codable {
    let login: String
    let url: URL
    let name: String?
    let email: String?
}
