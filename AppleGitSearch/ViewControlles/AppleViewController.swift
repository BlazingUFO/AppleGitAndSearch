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
import CoreData
import RxDataSources
import RxCoreData
import Reachability

class AppleViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    let reachability = Reachability()!
    
    private let bag = DisposeBag()
    private let repos = Variable<[Repo]>([])
    var urlToLoad = "http://apple.com"

    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = PersistenceService.managedObjectContext
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        if reachability.connection == .none {
            bindUIfromCoreData()
        }else{
            getRequest()
        }
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
            }
            .bind(to: repos)
            .disposed(by: bag)
        bindUI()
    }
    
    func bindUI(){
        repos.asObservable()
            .bind(to: tableView.rx.items) { tableView, row, repo in
                _ = try? self.managedObjectContext.rx.update(repo)
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
                cell.full_name.text = repo.name
                cell.descriptionText.text = repo.descriptionString
                cell.updated_at.text = repo.updated_at
                cell.stargazers_count.text = String(repo.stargazers_count)
                cell.avatar.imageFromServerURL(urlString: repo.avatar_url)
                return cell
            }
            .disposed(by: bag)
    }
    
    func bindUIfromCoreData(){
        self.tableView.delegate = self
        managedObjectContext.rx.entities(Repo.self, sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)])
            .bind(to: tableView.rx.items(cellIdentifier: "CustomCell")) { row, repo, cell in
                (cell as! CustomCell).full_name.text = repo.name
                (cell as! CustomCell).descriptionText.text = repo.descriptionString
                (cell as! CustomCell).updated_at.text = repo.updated_at
                (cell as! CustomCell).stargazers_count.text = String(repo.stargazers_count)
                (cell as! CustomCell).avatar.imageFromServerURL(urlString: repo.avatar_url)
            }
            .disposed(by: bag)
        managedObjectContext.rx.entities(Repo.self, sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)])
            .bind(to: repos)
            .disposed(by: bag)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if reachability.connection == .none {
            showAlertNoInternet()
            tableView.deselectRow(at: indexPath, animated: false)
        }else{
            urlToLoad = self.repos.value[indexPath.row].html_url
            performSegue(withIdentifier: "showFromApple", sender: self)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func showAlertNoInternet(){
        let alert = UIAlertController(title: "Oooops", message: "Looks like you are not connected to internet, please check your connection.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true)
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

