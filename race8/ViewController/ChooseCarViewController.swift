//
//  ChooseCarViewController.swift
//  race8
//
//  Created by Pavel Nesterenko on 4.03.23.
//

import UIKit

class ChooseCarViewController: UIViewController {
   // let arrayCar = [UIImage(named: "pickUp"), UIImage(named: "playerCar1"), UIImage(named: "playerCar2")]
    let arrayCar = ["pickUp", "playerCar1", "playerCar2"]
    var selectedIndexPath: IndexPath?
    var color = false
    var cellSize: CGSize {
    var minimumLineSpacing: CGFloat = 0
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        minimumLineSpacing = flowLayout.minimumLineSpacing
        }
        let width = (collectionView.frame.width - minimumLineSpacing) / 2
        return CGSize(width: width, height: width)
    }

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self

    }

}

extension ChooseCarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarCollectionView.identifier, for: indexPath) as? CarCollectionView else {
                return UICollectionViewCell()
            }
        cell.imageView.image = UIImage(named: "\(arrayCar[indexPath.row])")
        cell.imageDidTapHandler = {
            print("tap")
            let settings = Settings.sheard.load(.nameCar)
            settings.nameCar = self.arrayCar[indexPath.row]
            Settings.sheard.save(settings, .nameCar)
            
            self.color = !self.color
            if self.color == true {
                cell.imageView.backgroundColor = .white
                self.navigationController?.popViewController(animated: true)
            } else {
                cell.imageView.backgroundColor = #colorLiteral(red: 0.8389399648, green: 0.9040262103, blue: 1, alpha: 1)
                print("Серый")
            }

            
        }
        return cell
    }
    
    
}

extension ChooseCarViewController: UICollectionViewDelegate {
    
}

extension ChooseCarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if selectedIndexPath != nil {
            return collectionView.frame.size
        } else {
            return cellSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if selectedIndexPath == nil {
          return 5
        } else {
          return 0
        }
    }
}

