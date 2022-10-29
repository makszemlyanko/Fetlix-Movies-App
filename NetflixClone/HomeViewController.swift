//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Maks Kokos on 29.10.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let homeMainTable: UITableView = {
        let table = UITableView(frame:  .zero,style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.cellId)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(homeMainTable)
        
        homeMainTable.delegate = self
        homeMainTable.dataSource = self
        
        configureNavBar()
        
        let headerView = HeroHeaderUIView(frame: .init(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeMainTable.tableHeaderView = headerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeMainTable.frame = view.bounds
    }
    
    private func configureNavBar() {
        var image = UIImage(named: "flogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .label
    }


}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.cellId, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
}

extension HomeViewController: UITableViewDelegate {

    
}
