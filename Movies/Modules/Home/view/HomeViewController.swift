//
//  HomeViewController.swift
//  Movies
//
//  Created by aya on 15/09/2024.
// e77cee2c480a18ea32852987f2abcbc0

import UIKit


enum Sections: Int {
    
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUIView?
    let sectionTitles: [String] = ["Trending Movies","Trending Tv","Popular","Upcoming Movies","Top rated"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
        
            return UITableViewCell()
        }
        cell.delegate = self
        cell.backgroundColor = .black
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            
            NetworkManager.shared.getTrendingMovies { results in
                switch results{
                           case .success(let titles):
                    cell.configure(with: titles)
                              case .failure(let error):
                    print("Error fetching movies: \(error.localizedDescription)")
                              
                }
            }
            
        case Sections.TrendingTv.rawValue:
            
            NetworkManager.shared.getTrendingTvs { results in
                switch results{
                           case .success(let titles):
                    cell.configure(with: titles)
                              case .failure(let error):
                    print("Error fetching movies: \(error.localizedDescription)")
                              
                }
            }
        case Sections.Popular.rawValue:
            
            NetworkManager.shared.getPopularMovies { results in
                switch results{
                           case .success(let titles):
                    cell.configure(with: titles)
                              case .failure(let error):
                    print("Error fetching movies: \(error.localizedDescription)")
                              
                }
            }
        case Sections.Upcoming.rawValue:
            
            NetworkManager.shared.getUpcomingMovies { results in
                switch results{
                           case .success(let titles):
                    cell.configure(with: titles)
                              case .failure(let error):
                    print("Error fetching movies: \(error.localizedDescription)")
                              
                }
            }
            
        case Sections.TopRated.rawValue:
            
            NetworkManager.shared.getTopRatedMovies { results in
                switch results{
                           case .success(let titles):
                    cell.configure(with: titles)
                              case .failure(let error):
                    print("Error fetching movies: \(error.localizedDescription)")
                              
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18,weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
    }
    
    @IBOutlet weak var home: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        home.dataSource = self
        home.delegate = self
        home.backgroundColor = .black
        home.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 470))
        
        headerView?.backgroundColor = .black
        home.tableHeaderView = headerView
        home.backgroundColor = .black
        configureNavbar()
        configureHeroHeaderView()
    }
    
    private func configureNavbar() {
           var image = UIImage(named: "netflix")
           image = image?.withRenderingMode(.alwaysOriginal)
           navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
           
           navigationItem.rightBarButtonItems = [
               UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
               UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
           ]
           navigationController?.navigationBar.tintColor = .white
       }
    
    private func configureHeroHeaderView(){
        NetworkManager.shared.getTrendingMovies {  result in
            switch result {
            case .success(let titles):
                print("Trending Movies fetched: \(titles)")
                let selectedTitle = titles.randomElement()
                self.randomTrendingMovie = selectedTitle
                
                DispatchQueue.main.async {
                    self.headerView?.configure(with: TitleViewModel(original_title: selectedTitle?.original_title ?? "", poster_path: selectedTitle?.poster_path ?? ""))
                }
                
            case .failure(let error):
                print("Error fetching movies: \(error.localizedDescription)")
            }
        }
    }

  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBar = self.tabBarController?.tabBar {
            tabBar.barTintColor = UIColor.black
            tabBar.isTranslucent = false
        }
        
    }
   

}


extension HomeViewController: CollectionViewTableViewCellDelegate {
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
