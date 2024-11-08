//
//  SearchResultsViewController.swift
//  Movies
//
//  Created by aya on 18/09/2024.
// 

import UIKit


protocol SearchResultsViewControllerDelegate: AnyObject {
    
    func searchResultsViewControllerDidTapCell(_ viewModel: TitlePreviewViewModel)
}


class SearchResultsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell()}
         
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "_")
        return cell
    }
    
    
    
    public var titles: [Title] = [Title]()
    
    public let searchResultsCollecionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 180)
        layout.minimumLineSpacing = 3
        
        let collecionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collecionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collecionView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(searchResultsCollecionView)
        
        searchResultsCollecionView.delegate = self
        searchResultsCollecionView.dataSource = self
        
        searchResultsCollecionView.backgroundColor = .black
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollecionView.frame = view.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name  else { return }
        
        NetworkManager.shared.getMovie(with: titleName){
           [weak self]  result in
            switch result{
                case .success(let videoElement):
                self?.delegate?.searchResultsViewControllerDidTapCell(TitlePreviewViewModel(title: title.original_title ?? "", youtubeView: videoElement, titleOverview: title.overview ?? ""))
                case .failure(let error):
                print("Error fetching movies: \(error.localizedDescription)")
                          
            }
        }
    }
    

}
