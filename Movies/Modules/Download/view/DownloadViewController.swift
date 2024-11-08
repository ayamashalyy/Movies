//
//  DownloadViewController.swift
//  Movies
//
//  Created by aya on 15/09/2024.
//

import UIKit

class DownloadViewController: UIViewController,UITableViewDelegate,UITableViewDataSource

{
    
    @IBOutlet weak var download: UITableView!
    private var titles: [TitleItem] = [TitleItem]()
    
    
    
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
            
        case .delete:
          
            DatabaseManager.shared.deleteFromDatabase(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success:
                    print("delete from database successfully.")
                case .failure(let error):
                    print("Error deleting TitleItem: \(error.localizedDescription)")
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
              
            }
            
        default:
            break;
        }
    }
    
    private func fetchDataToDownloads(){
        DatabaseManager.shared.fetchTitlesFromDatabase { [weak self] result in
            switch result {
            case .success(let titles):
                DispatchQueue.main.async {
                    self?.titles = titles
                    self?.download.reloadData()
                }
            
            case .failure(let error):
                print("Error saving TitleItem: \(error.localizedDescription)")
            }
        
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        fetchDataToDownloads()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchDataToDownloads()
        }
        
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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        download.frame = view.bounds
    }

 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        download.dataSource = self
        download.delegate = self
        download.backgroundColor = .black
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        headerView.backgroundColor = .black
        let headerLabel = UILabel(frame: CGRect(x: 20, y: -30, width: view.frame.size.width, height: 50))
        headerLabel.text = "Downloads"
        headerLabel.textColor = .white
        headerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        headerView.addSubview(headerLabel)
        download.tableHeaderView = headerView
        
        let nib = UINib(nibName: "UpcomingSrackTableViewCell", bundle: nil)
           download.register(nib, forCellReuseIdentifier: UpcomingSrackTableViewCell.identifier)
        
        fetchDataToDownloads()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchDataToDownloads()
        }
        
      
       
    }

}
