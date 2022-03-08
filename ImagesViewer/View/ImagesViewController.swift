//
//  ImagesViewController.swift
//  ImagesViewer
//
//  Created by Михаил on 05.03.2022.
//

import UIKit

protocol ImagesViewable: AnyObject {

    func reloadData()
}

class ImagesViewController: UITableViewController {
    
    private var presenter: ImagesPresenterProtocol!
    private var imagesData: [ImageDataModel] = []
    var isLoading: Bool = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        presenter = ImagesPresenter(view: self,
                                    networkService: NetworkService(),
                                    imageNetworkManager: ImageNetworkManager())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        presenter.getImagesData(completion: nil)
    }
    
    private func setupTable() {
        tableView.register(UINib(nibName: "ImageCell", bundle: nil),
                           forCellReuseIdentifier: "ImageCell")
        tableView.register(UINib(nibName: "LoadingCell", bundle: nil),
                           forCellReuseIdentifier: "LoadingCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            self.presenter.getImagesData() {
                self.isLoading = false
            }
        }
    }
}

extension ImagesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return imagesData.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
            let image = imagesData[indexPath.row]
            cell.configureCell(with: image)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let imageData = imagesData[indexPath.row]
        Router.navigateTo(.fullSizeImageController(imageData), from: self)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height) && !isLoading {
            loadMoreData()
        }
    }
}

extension ImagesViewController: ImagesViewable {
    
    func reloadData() {
        imagesData = RealmService().loadFromDatabase()
        tableView.reloadData()
    }
}



