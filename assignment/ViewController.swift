//
//  ViewController.swift
//  assignment
//
//  Created by Chandan on 14/10/18.
//  Copyright © 2018 Chandan. All rights reserved.
//

import Alamofire
import AlamofireImage
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var dataModel: DataModel = DataModel()
    var isLoading = false
    var lastContentOffset: CGFloat = 0
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getResult(page: 1)
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func getResult(page: Int) {
        if isLoading { return }
        isLoading = true
        if dataModel.search.count == 0 {
            activity.startAnimating()
        }
        ApiList.getSearches(text: "Batman", page: page) { [weak self] res in
            guard let `self` = self else { return }
            if let model = res.data {
                if model.search.count > 0 {
                    if page == 1 {
                        self.dataModel = model
                    } else {
                        self.dataModel.search.append(contentsOf: model.search)
                    }
                    self.page += 1
                    self.collectionView.reloadData()
                } else {
                    self.page = -1
                }
            }
            self.activity.stopAnimating()
            self.isLoading = false
        }
    }
    
    func didScrollToBottom() {
        if page != -1 { // -1 -> end of page
            getResult(page: page)
        }
    }
    
    // MARK: config for flow layout delegate
    
    var collectionItemsPerRow: CGFloat = 2
    var collectionPadding: CGFloat = 4
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.search.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: Cell.self, indexPath: indexPath)
        cell.setData(item: dataModel.search[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataModel.search[indexPath.row]
        let viewc = storyboard!.instantiateViewController(type: DetailsViewController.self)
        viewc.inputSearchData = item
        self.show(viewc, sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let flag = scrollView.contentOffset.y + scrollView.contentInset.top
        if flag > 0 {
            if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height - 400 {
                didScrollToBottom()
            }
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    // MARK: flow layout delegate
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = collectionPadding * collectionPadding + collectionPadding
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / collectionItemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem + 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionPadding, left: collectionPadding, bottom: collectionPadding, right: collectionPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class Cell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblType: UILabel!
    
    func setData(item: SearchBean) {
        lblTitle.text = item.title
        lblType.text = item.type
        
        lblYear.text = item.resolveYear()
        
        img.image = nil
        if let urlString = item.poster, let url = URL(string: urlString) {
            img.af_setImage(withURL: url)
        }
    }
    
    func setYear(year: Int) {
    }
}
