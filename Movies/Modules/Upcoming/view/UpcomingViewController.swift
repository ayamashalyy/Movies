//
//  UpcomingViewController.swift
//  Movies
//
//  Created by aya on 15/09/2024.
//

import UIKit

class UpcomingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private var titles: [Title] = [Title]()
    @IBOutlet weak var upcoming: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingSrackTableViewCell.identifier, for: indexPath) as? UpcomingSrackTableViewCell else {
              return UITableViewCell()
          }
        cell.configure(with: TitleViewModel(original_title: titles[indexPath.row].original_title ?? titles[indexPath.row].original_name, poster_path: titles[indexPath.row].poster_path))
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = .clear
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = .clear
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
     
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        upcoming.dataSource = self
        upcoming.delegate = self
        view.backgroundColor = .black
        upcoming.backgroundColor = .black
        upcoming.alwaysBounceVertical = false
        upcoming.bounces = false
        upcoming.tintColor = .black
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        headerView.backgroundColor = .black
        let headerLabel = UILabel(frame: CGRect(x: 20, y: -30, width: view.frame.size.width, height: 50))
        headerLabel.text = "Upcoming"
        headerLabel.textColor = .white
        headerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        headerView.addSubview(headerLabel)
        upcoming.tableHeaderView = headerView
        view.backgroundColor = .black
        fetchUpcomingMovies()
        
        
        let nib = UINib(nibName: "UpcomingSrackTableViewCell", bundle: nil)
           upcoming.register(nib, forCellReuseIdentifier: UpcomingSrackTableViewCell.identifier)

    }
    
    
    private func fetchUpcomingMovies(){
        
        
        NetworkManager.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                print(titles)
                DispatchQueue.main.async {
                    self?.upcoming.reloadData()
                }
              
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
  
}
