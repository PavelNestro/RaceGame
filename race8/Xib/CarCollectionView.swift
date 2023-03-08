//
//  CarCollectionView.swift
//  race8
//
//  Created by Pavel Nesterenko on 4.03.23.
//

import UIKit

class CarCollectionView: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    static let identifier = String(describing: CarCollectionView.self)
    
    var imageDidTapHandler: (() -> ())?
      
    
    required init?(coder: NSCoder) { // он обязательный
        super.init(coder: coder)
        setupTapGesture()
    }




    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        imageDidTapHandler?()
    }
}
