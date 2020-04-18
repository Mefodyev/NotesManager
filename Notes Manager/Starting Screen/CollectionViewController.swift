//
//  CollectionViewController.swift
//  Notes Manager
//
//  Created by Alexey Mefodyev on 25.01.2020.
//  Copyright © 2020 LexMefodyev. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var navigationTopItem: UINavigationItem!
    
    
    //MARK: Basic Data
    enum CellsThematics: String, CaseIterable {
        case work = "Работа"
        case study = "Учёба"
        case housework = "Работа по дому"
        case shoppingList = "Список покупок"
        case addNew = "Добавить свою категорию"
    }
    
    enum CellsEmojis: String, CaseIterable {
        case work = "💼"
        case study = "📚"
        case housework = "🧺"
        case shoppingList = "🛒"
        case addNew = "✅"
    }
    
    let cellsThematics = CellsThematics.allCases
    let cellsEmojis = CellsEmojis.allCases
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cellsThematics.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        cell.backgroundColor = .brown
        cell.layer.cornerRadius = cell.frame.size.height/10
        
        cell.noteLabel.text = cellsThematics[indexPath.item].rawValue
        cell.noteLabel.numberOfLines = 0
        cell.noteLabel.font = UIFont(name: "Helvetica", size: 20)
        cell.noteLabel.adjustsFontForContentSizeCategory = true
        cell.noteLabel.translatesAutoresizingMaskIntoConstraints = false

        
        cell.emojiLabel.text = cellsEmojis[indexPath.item].rawValue
        cell.emojiLabel.font = UIFont(name: "Helvetica", size: 70)
        cell.emojiLabel.numberOfLines = 0
        cell.emojiLabel.adjustsFontForContentSizeCategory = true
        cell.emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        //нужно отцентровать эмодзи и подпись
        guard let emoji = cell.emojiLabel, let note = cell.noteLabel else { return UICollectionViewCell() }
        NSLayoutConstraint(item: emoji, attribute: .centerX, relatedBy: .equal, toItem: cell.cellContentView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: emoji, attribute: .centerY, relatedBy: .equal, toItem: cell.cellContentView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: note, attribute: .centerX, relatedBy: .equal, toItem: cell.cellContentView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: note, attribute: .top, relatedBy: .equal, toItem: emoji, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        return cell
    }
    
    //makes a header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            headerView.backgroundColor = UIColor.clear
            headerView.frame.size.height = 150
            let labelHeader = headerView.viewWithTag(100) as! UILabel
            
            if indexPath.section == 0 {
                labelHeader.text = "Выберите категорию"
                labelHeader.font = UIFont(name: "Helvetica", size: 40.0)
                labelHeader.textColor = .purple
                labelHeader.numberOfLines = 0
                labelHeader.adjustsFontForContentSizeCategory = true
            }
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemPerRow = 2
        let screenWidth = UIScreen.main.bounds.width
        let sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        let minimumInteritemSpacing = CGFloat(10)
        let minimumLineSpacing = CGFloat(10)
        
        //width
        let interitemSpacesCount = numberOfItemPerRow - 1
        let interitemSpacingPerRow = minimumInteritemSpacing * CGFloat(interitemSpacesCount)
        let rowContentWidth = screenWidth - sectionInset.right - sectionInset.left - interitemSpacingPerRow
        
        //height
        let lineSpacingCount = numberOfItemPerRow - 1
        let lineSpacingPerRow = minimumLineSpacing * CGFloat(lineSpacingCount)
        let rowContentHeight = screenWidth - sectionInset.top - sectionInset.bottom - lineSpacingPerRow
        
        let width = rowContentWidth / CGFloat(numberOfItemPerRow)
        let height = rowContentHeight / CGFloat(numberOfItemPerRow)
        
        return CGSize(width: width, height: height)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        let cellWidthPadding = collectionView.frame.size.width / 30
    //        let cellHeightPadding = collectionView.frame.size.height / 4
    //        return UIEdgeInsets(top: cellHeightPadding,left: cellWidthPadding, bottom: cellHeightPadding,right: cellWidthPadding)
    //    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let thematics = cellsThematics[indexPath.row]
        
        switch thematics {
        case .work:
            performSegue(withIdentifier: "toWorkTableView", sender: self)
        case .study:
            print("study")
        case .housework:
            print("housework")
        case .shoppingList:
            print("shoppingList")
        default:
            print("default")
        }
    }
     
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
}
