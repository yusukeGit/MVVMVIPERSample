//
//  HomeViewController.swift
//  MVVMVIPERSample
//
//  Created by yusuke watanabe on 2021/04/21.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    // 初期化する時に参照を渡す
    private lazy var viewModel = HomeViewModel(searchBarText: <#Observable<String?>#>, searchButtonClicked: <#Observable<Void>#>, itemSelected: <#Observable<IndexPath>#>)
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        // viewModelとのbind
        
    }

    private func setup() {
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }

}

