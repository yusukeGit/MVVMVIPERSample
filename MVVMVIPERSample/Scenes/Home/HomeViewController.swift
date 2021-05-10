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
    private var deselectRow: Binder<IndexPath> {
        return Binder(self) { me, indexPath in
            me.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private var reloadData: Binder<Void> {
        return Binder(self) { me, _ in
            me.tableView.reloadData()
        }
    }
    
    // Routerに移動できるか？
    private var transitionToHomeDetail: Binder<Profile> {
        return Binder(self) { me, profile in
            let homeDetailViewController = UIStoryboard(name: "HomeDetailViewController", bundle: nil).instantiateInitialViewController() as! HomeDetailViewController
            me.navigationController?.pushViewController(homeDetailViewController, animated: true)
        }
    }
    // 初期化する時に参照を渡す
    // asObservableでObsavable<Element>型に変換
    private lazy var viewModel = HomeViewModel(searchBarText: searchBar.rx.text.asObservable(),
                                               searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(),
                                               itemSelected: tableView.rx.itemSelected.asObservable())
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        // viewModelとのbind
        
        // disposedしないと結果が利用されていないとXcode上で警告が出る
        viewModel.reloadData
            .bind(to: reloadData)
            .disposed(by: disposeBag)
        viewModel.deselectRow
            .bind(to: deselectRow)
            .disposed(by: disposeBag)
        viewModel.transitionToHomeDetail
            .bind(to: transitionToHomeDetail)
            .disposed(by: disposeBag)
        
    }
    
    private func setup() {
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell

        let user = viewModel.users[indexPath.row]
        cell.configure(user: user)

        return cell
    }
}
