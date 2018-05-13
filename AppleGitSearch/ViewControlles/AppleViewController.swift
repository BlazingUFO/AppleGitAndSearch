//
//  FirstViewController.swift
//  AppleGitSearch
//
//  Created by Peter Zeman on 11.5.18.
//  Copyright © 2018 Peter Zeman. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class AppleViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    private let bag = DisposeBag()
    private let repos = Variable<[Repo]>([])
    var urlToLoad = "http://apple.com"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        getRequest()
        saveToCoreData()
    }
    
    func getRequest(){
        let apiUrl = URL(string: "https://api.github.com/users/apple/repos?per_page=100")!
        
        URLSession.shared.rx.json(url: apiUrl)
            
            .map { json -> [Repo] in
                guard let items = json as? [[String: Any]]
                    else {
                        return []
                }
                
                return items.compactMap(Repo.init)
            }.bind(to: repos)
            .disposed(by: bag)
        bindUI()
    }
    
    func bindUI(){
  
        
        
            repos.asObservable()
            .bind(to: tableView.rx.items) { tableView, row, repo in
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
                cell.full_name.text = repo.name
                cell.descriptionText.text = repo.description
                cell.updated_at.text = repo.updated_at
                cell.stargazers_count.text = String(repo.stargazers_count)
                cell.avatar.imageFromServerURL(urlString: repo.avatar_url)
                return cell
            }
            .disposed(by: bag)
        
    }
    
    func saveToCoreData(){
        print(repos.value.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        urlToLoad = self.repos.value[indexPath.row].html_url
        performSegue(withIdentifier: "showFromApple", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFromApple" {
            if let destinationVC = segue.destination as? WebViewController {
                destinationVC.urlToLoad = self.urlToLoad
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

