//
//  SearchViewController.swift
//  Movies
//
//  Created by aya on 15/09/2024.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private var titles: [Title] = [Title]()
    @IBOutlet weak var search: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingSrackTableViewCell.identifier, for: indexPath) as? UpcomingSrackTableViewCell else {
              return UITableViewCell()
          }
        
        cell.configure(with: TitleViewModel(original_title: titles[indexPath.row].original_title ?? titles[indexPath.row].original_name, poster_path: titles[indexPath.row].poster_path))
        
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name  else { return }
        
        NetworkManager.shared.getMovie(with: titleName){
           [weak self]  result in
            switch result{
                case .success(let videoElement):
                DispatchQueue.main.async {
                    
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                case .failure(let error):
                print("Error fetching movies: \(error.localizedDescription)")
                          
            }
        }
    }
    
    
    
    
    private let searchController: UISearchController = {
        let controllor = UISearchController(searchResultsController: SearchResultsViewController())
        controllor.searchBar.placeholder = "Search for a Movie or a Tv show"
        controllor.searchBar.searchBarStyle = .minimal
        
        return controllor
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        search.dataSource = self
        search.delegate = self
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        search.contentInsetAdjustmentBehavior = .never
        search.backgroundColor = .black
        view.backgroundColor = .black
        searchController.searchResultsUpdater = self
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
//        headerView.backgroundColor = .black
//
//        let headerLabel = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.size.width, height: 50))
//
//        headerLabel.text = "Search"
//        headerLabel.textColor = .white
//        headerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
//        headerView.addSubview(headerLabel)
//
//        search.tableHeaderView = headerView
        
        let nib = UINib(nibName: "UpcomingSrackTableViewCell", bundle: nil)
           search.register(nib, forCellReuseIdentifier: UpcomingSrackTableViewCell.identifier)
        
        fetchSearchMovies()
    }
    
    
    private func fetchSearchMovies(){
        
        
        NetworkManager.shared.getSearchMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                print(titles)
                DispatchQueue.main.async {
                    self?.search.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    

 
}

extension SearchViewController: UISearchResultsUpdating,SearchResultsViewControllerDelegate {
    
    
    func searchResultsViewControllerDidTapCell(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
        !query.trimmingCharacters(in: .whitespaces).isEmpty,
        query.trimmingCharacters(in: .whitespaces).count >= 3,
        let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        resultsController.delegate = self
        
        NetworkManager.shared.search(with: query) { result in
            
            DispatchQueue.main.async {
            switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollecionView.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
}
