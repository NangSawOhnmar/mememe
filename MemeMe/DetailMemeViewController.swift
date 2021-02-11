//
//  DetailMemeViewController.swift
//  MemeMe
//
//  Created by nang saw on 05/01/2021.
//

import UIKit

class DetailMemeViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    
    // Variable to hold meme image from previous controller
    var memeImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImageView.image = memeImage
    }

}
