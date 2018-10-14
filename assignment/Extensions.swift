//
//  Extensions.swift
//  assignment
//
//  Created by Chandan on 14/10/18.
//  Copyright © 2018 Chandan. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func dequeueReusableCell<T>(type: T.Type, indexPath: IndexPath) -> T {
        let id = String(describing: type)
        guard let cell = dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? T else {
            fatalError("collectionViewCell not found")
        }
        return cell
    }
    
}

extension UIStoryboard {
    func instantiateViewController<T>(type: T.Type) -> T {
        let id = String(describing: type)
        print("StoryBoard id: \(id)")
        guard let viewController = instantiateViewController(withIdentifier: id) as? T else {
            fatalError("ViewController not found")
        }
        return viewController
    }
}
