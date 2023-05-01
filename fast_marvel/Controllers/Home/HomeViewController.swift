//
//  ViewController.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 24/04/23.
//

import UIKit

class HomeViewController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.tintColor = UIColor.black.withAlphaComponent(1.0)
        searchBar.placeholder = "Filter comics"
        searchBar.backgroundColor = UIColor.clear
        searchBar.barTintColor = UIColor.clear
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .search
        searchBar.showsCancelButton = false
        searchBar.showsBookmarkButton = false
        searchBar.sizeToFit()
        
        return searchBar
    }()
    
    private var dataSource: ComicDataSource
    private var presenter: HomeViewControllerPresenterProtocol?
    
    init(presenter: HomeViewControllerPresenterProtocol,
         dataSource: ComicDataSource = ComicDataSource(comics: [])) {
        self.presenter = presenter
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.collectionView.delegate = self
        self.searchBar.delegate = self
        
        self.definesPresentationContext = false
        
        self.createLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    func loadData() {
        if dataSource.comics.count > 0 {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        } else {
            self.presenter?.loadData(offset: 0)
        }
    }
    
    func createLayout() {
        self.navigationItem.titleView = searchBar
        
        self.collectionView.register(ComicCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.register(CollectionViewFooterView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                     withReuseIdentifier: "Footer")
        
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.view.layoutIfNeeded()
        self.collectionView.setLoadingState()
    }
}

extension HomeViewController: HomeViewControllerViewProtocol {
    func setComics(comics: [Comic]) {
        DispatchQueue.main.async {
            if self.dataSource.comics.isEmpty {
                self.dataSource.comics = comics
                self.collectionView.dataSource = self.dataSource
            } else {
                self.dataSource.comics.append(contentsOf: comics)
            }
            
            UIView.performWithoutAnimation {
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }
            self.collectionView.restore()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if self.dataSource.searchActive {
            return
        }
        let comicCount = self.dataSource.comics.count
        
        if elementKind == UICollectionView.elementKindSectionFooter && comicCount > 0 {
            self.presenter?.loadData(offset: comicCount)
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var comic: Comic = self.dataSource.comics[indexPath.row]
        if self.dataSource.searchActive {
            comic = self.dataSource.filteredComics[indexPath.row]
        }
        
        let presenter = ComicDetailPresenter(comic: comic)
        presenter.navigate(from: self)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 16
        let height = width * 1.5
        return CGSize(width: width,
                      height: height + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.dataSource.filteredComics = []
        self.dataSource.searchActive = false
        self.searchBar.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        self.searchBar.showsCancelButton = false
        self.collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.dataSource.filterComics(searchText: searchText)
        self.collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
}
