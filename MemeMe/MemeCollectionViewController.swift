//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by nang saw on 03/01/2021.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    // MARK: - Properties
    // to access memes data from appDelegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appdelegate = object as! AppDelegate
        return appdelegate.memes
    }
    private let sectionInsets = UIEdgeInsets(top: 8.0,
                                             left: 20.0,
                                             bottom: 8.0,
                                             right: 20.0)
    private let itemsPerRow: CGFloat = 3
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        // Set the image
        cell.memeImageView?.image = meme.memedImage
        return cell
    }
    
    //navigate to detailView
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailMemeViewController = storyboard?.instantiateViewController(identifier: "DetailMemeViewController") as! DetailMemeViewController
        //sent meme image data
        detailMemeViewController.memeImage = self.memes[(indexPath as NSIndexPath).row].memedImage
        detailMemeViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailMemeViewController, animated: true)
    }
    
    //go to create new meme photo
    @IBAction func addNewMemeButton(_ sender: Any) {
        let memeViewController = storyboard?.instantiateViewController(identifier: "MemeViewController") as! MemeViewController
        memeViewController.modalPresentationStyle = .fullScreen
        self.present(memeViewController, animated: true, completion: nil)
    }
}

// MARK: - Collection View Flow Layout Delegate
extension MemeCollectionViewController : UICollectionViewDelegateFlowLayout {
    //set the size for each cell Items
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //set the spacing between cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    //match padding at the left
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
