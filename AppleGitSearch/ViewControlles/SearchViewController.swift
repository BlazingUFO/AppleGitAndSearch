//
//  SecondViewController.swift
//  AppleGitSearch
//
//  Created by Peter Zeman on 11.5.18.
//  Copyright © 2018 Peter Zeman. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    private let repos = Variable<[RepoSearch]>([])
    private let bag = DisposeBag()
    var urlToLoad = "http://apple.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        bindUI()
    }
    
    func bindUI() {
        searchBar.rx.text
            .orEmpty
            .filter { query in
                return query.count > 2
            }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map { query in
                var apiUrl = URLComponents(string: "https://api.github.com/search/repositories")!
                apiUrl.queryItems = [URLQueryItem(name: "q", value: query)]
                return URLRequest(url: apiUrl.url!)
            }
            .flatMapLatest { request in
                return URLSession.shared.rx.json(request: request)
                    .catchErrorJustReturn([])
            }
            .map { json -> [RepoSearch] in
                guard let json = json as? [String: Any],
                    let items = json["items"] as? [[String: Any]]  else {
                        return []
                }
                return items.compactMap(RepoSearch.init)
            }.bind(to: repos)
            .disposed(by: bag)
        
        repos.asObservable()
            .bind(to: tableView.rx.items) { tableView, row, repo in
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

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableView.contentInset.bottom = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.tableView.contentInset.bottom = 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        urlToLoad = self.repos.value[indexPath.row].html_url
        performSegue(withIdentifier: "showWeb", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeb" {
            if let destinationVC = segue.destination as? WebViewController {
                destinationVC.urlToLoad = self.urlToLoad
            }
        }
    }

}

