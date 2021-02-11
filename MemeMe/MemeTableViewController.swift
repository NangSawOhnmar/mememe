//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by nang saw on 03/01/2021.
//

import UIKit

class MemeTableViewController: UITableViewController {
    // MARK: - Properties
    // to access memes data from appDelegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appdelegate = object as! AppDelegate
        return appdelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        // Set the meme text and image
        cell.memeLabel.text = "\(meme.topText) ... \(meme.bottomText)"
        cell.memeImageView?.image = meme.memedImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailMemeViewController = storyboard?.instantiateViewController(identifier: "DetailMemeViewController") as! DetailMemeViewController
        //sent meme image data
        detailMemeViewController.memeImage = self.memes[(indexPath as NSIndexPath).row].memedImage
        detailMemeViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailMemeViewController, animated: true)
    }
    
    @IBAction func addNewMemeButton(_ sender: Any) {
        let memeViewController = storyboard?.instantiateViewController(identifier: "MemeViewController") as! MemeViewController
        memeViewController.modalPresentationStyle = .fullScreen
        self.present(memeViewController, animated: true, completion: nil)
    }
}
