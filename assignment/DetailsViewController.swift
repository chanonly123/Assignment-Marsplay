//
//  DetailsViewController.swift
//  assignment
//
//  Created by Chandan on 14/10/18.
//  Copyright © 2018 Chandan. All rights reserved.
//

import Alamofire
import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var cont: UIView!
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    var inputSearchData: SearchBean!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        automaticallyAdjustsScrollViewInsets = false
        imageScrollView.imageContentMode = .aspectFill
        
        guard let item = inputSearchData else { return }
        
        lblTitle.text = item.title
        lblType.text = item.type
        
        lblYear.text = item.resolveYear()
        
        if let url = item.poster {
            Alamofire.request(url).responseImage { response in
                if let image = response.result.value {
                    self.imageScrollView.display(image: image)
                }
            }
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    @objc func tapAction() {
        let transform = navigationController!.isNavigationBarHidden ? CGAffineTransform.identity : CGAffineTransform(translationX: 0, y: cont.frame.height)
        let alpha: CGFloat = navigationController!.isNavigationBarHidden ? 1 : 0
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.cont.transform = transform
            self?.cont.alpha = alpha
        })
        navigationController?.setNavigationBarHidden(!navigationController!.isNavigationBarHidden, animated: true)
    }
}
