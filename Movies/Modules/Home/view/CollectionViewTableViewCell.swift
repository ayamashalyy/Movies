//
//  CollectionViewTableViewCell.swift
//  Movies
//
//  Created by aya on 16/09/2024.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}


class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
    weak var delegate: CollectionViewTableViewCellDelegate?
    private var titles: [Title] = [Title]()
    
    private let collecionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collecionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collecionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collecionView
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collecionView)
        collecionView.delegate = self
        collecionView.dataSource = self
        collecionView.backgroundColor = .black

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collecionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [Title]){
        self.titles = titles
        
        DispatchQueue.main.async {
            [weak self] in
            self?.collecionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        let title = titles[indexPath.row]
        
        DatabaseManager.shared.downloadTitleWith(model: title) { result in
            switch result {
            case .success:
                print("TitleItem saved successfully.")
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print("Error saving TitleItem: \(error.localizedDescription)")
            }
        }
        
        print("Download \(title.original_title ?? "unknown title")")
    }


}



extension CollectionViewTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: model)
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name  else { return }
        
        NetworkManager.shared.getMovie(with: titleName + " trailer"){
           [weak self]  result in
            switch result{
                    case .success(let videoElement):
                guard let titleOverview = title.overview else {return}
                guard let strongSelf = self else {return}
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                self?.delegate?.CollectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                    case .failure(let error):
                print("Error fetching movies: \(error.localizedDescription)")
                          
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        if let indexPath = collectionView.indexPathForItem(at: point) {
            let config = UIContextMenuConfiguration(
                identifier: nil,
                previewProvider: nil) {
                    [weak self] _ in

                    let downloadAction = UIAction(title: "Download", state: .off) { _ in
                        self?.downloadTitleAt(indexPath: indexPath)
                    }
                    return UIMenu(options: .displayInline, children: [downloadAction])
                }
            return config
        }
        return nil
    }
    
}
