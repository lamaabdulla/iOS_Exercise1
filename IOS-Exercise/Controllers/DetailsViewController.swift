//
//  DetailsViewController.swift
//  IOS-Exercise
//
//  Created by Lama Alashed on 24/10/2018.
//  Copyright © 2018 Lama Alashed. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var artContent: UILabel!
    @IBOutlet weak var artTitle: UILabel!
    @IBOutlet weak var artImage: UIImageView!
    
    var articleDetail:Article?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //To let image takes full width
        artImage.contentMode = .scaleAspectFill
        artImage.frame = self.view.bounds
        artImage.autoresizingMask = [.flexibleWidth ]
        
        //Calling setProperties func
        DispatchQueue.global(qos:.userInteractive).async {
            self.setProperties()}
    }
    
    func setProperties() {
        //Add data to DetailsViewController's Properties
          DispatchQueue.main.async {
        self.artTitle.text=self.articleDetail?.title
        self.artContent.text=self.articleDetail?.content
        if let ImageURL = URL(string: (self.articleDetail?.image_url)!){
            let data = try? Data(contentsOf: ImageURL)
            if let data = data {
                let image = UIImage(data: data)
                self.artImage.image=image
            }
            }}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

