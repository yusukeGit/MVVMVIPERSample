//
//  HomeDetailViewController.swift
//  MVVMVIPERSample
//
//  Created by yusuke watanabe on 2021/05/07.
//

import UIKit

final class HomeDetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.text = "HomeDetailViewController"
        view.addSubview(label)
    }
}
