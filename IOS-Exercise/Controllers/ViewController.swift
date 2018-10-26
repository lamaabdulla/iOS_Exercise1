//
//  ViewController.swift
//  IOS-Exercise
//
//  Created by Lama Alashed on 21/10/2018.
//  Copyright © 2018 Lama Alashed. All rights reserved.
/* Notes :
 1- Regarding point 2.1 I assumed that the title is “iOS Exercise “,  the value for the title key.
 2- Regarding point 5 When refreshing I called the downloadjson function again to update the articles array in case any new rows are added.
 3- I didn't fouce on designging i just made sure that the content won't collapse
 */

import UIKit

class ViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    
    //Properties
    private let jsonString = "https://no89n3nc7b.execute-api.ap-southeast-1.amazonaws.com/staging/exercise"
    private var ArticlesList = [Article]()
    private var sortedarticles = [Article]()
    
    
    //Add UIRefreshControl
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(downloadJson), for: .valueChanged)
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Calling downloadJson func in a global queue with User-Interactive QoS class so that it gets executed instantaneously.
        DispatchQueue.global(qos:.userInteractive).async {
            self.downloadJson() }

        //Creating a self-sizing table view cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        //Adding refresh control to table view
        if #available(iOS 10.0, *){
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
        tableView.tableFooterView = UIView()
    }
    
    @objc func downloadJson() {
        //Implementing URLSession
        guard let jsonURL = URL(string: jsonString) else { return }
        URLSession.shared.dataTask(with: jsonURL) { (data, urlResponse, error) in
            guard let data = data, error == nil, urlResponse != nil else { print("downloading error"); return }
            print("downloaded")
            do{
                let decoder = JSONDecoder()
                let dowatitle = try decoder.decode(Title.self, from: data)
                let dowarticles = try decoder.decode(Articles.self, from: data)
                //Update articles array
                self.ArticlesList=dowarticles.articles
                DispatchQueue.main.async {
                    //Set navigation bar title
                    self.navigationItem.title = dowatitle.title
                    self.tableView.reloadData()
                    // End refresh control
                    self.refresher.endRefreshing() }
            }catch{
                print("error appears after downloading")
            }
            }.resume()
        //End implementing URLSession
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortArray()
        return sortedarticles.count
    }
    
    func sortArray(){
        // Sorting the ArticlesList array based on date then title then author .. if dates are the same, break ties by title and same with title and author
        sortedarticles = self.ArticlesList.sorted() {
            if $0.date == $1.date {
                if $0.title != $1.title{
                    return $0.title < $1.title}
                else {
                    return $0.author < $1.author
                }
            }
            else {
                return $0.date < $1.date
            }
        }
        //deleting articles with no titles from the array
        sortedarticles=sortedarticles.filter({ $0.title != "" })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") as? ArticlesTableViewCell else { return UITableViewCell() }
        
        //Displaying data on tableView's cells
        
        cell.TitleLabel?.text=sortedarticles[indexPath.row].title
        cell.ContentLabel?.text=sortedarticles[indexPath.row].content
        if let ImageURL = URL(string: (sortedarticles[indexPath.row].image_url)){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: ImageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.ImageView.image=image
                    }
                }
            }
        }
        return cell
    }
    
    //  sending articles to DetailsViewController to view article's details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: sortedarticles[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let des=segue.destination as? DetailsViewController {
                if let item=sender as? Article {
                    des.articleDetail=item
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

