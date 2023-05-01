//
//  CartResumeViewController.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 29/04/23.
//

import UIKit

class CartResumeViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Check out", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self,
                         action: #selector(proceedToCheckout),
                         for: .touchUpInside)
        
        
        return button
    }()
    
    private lazy var totalView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var resume: [CartResume] = []
    private var presenter: CartPresenterProtocol?
    private lazy var datasource = CartDataSource(resume: [], delegate: self)
    
    init(presenter: CartPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        presenter = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Cart"
        
        self.tableView.dataSource = datasource
        self.tableView.delegate = self
        
        self.tableView.register(CartResumeTableViewCell.self, forCellReuseIdentifier: "resumeCell")
        
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.datasource.resume = self.presenter?.displayCartResume() ?? []
        self.tableView.reloadData()
    }
    
    private func setupViews() {
        self.view.addSubview(tableView)
        self.view.addSubview(checkoutButton)
        self.view.addSubview(totalView)
        totalView.addSubview(totalLabel)
        
        let halfWidth = (self.view.bounds.width - 32) / 2
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
          
            self.checkoutButton.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 16),
            self.checkoutButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.checkoutButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            self.checkoutButton.heightAnchor.constraint(equalToConstant: 56),
            self.checkoutButton.widthAnchor.constraint(equalToConstant: halfWidth),
            
            self.totalView.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 16),
            self.totalView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.totalView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            self.totalView.heightAnchor.constraint(equalToConstant: 56),
            self.totalView.widthAnchor.constraint(equalToConstant: halfWidth),
            
            self.totalLabel.centerXAnchor.constraint(equalTo: self.totalView.centerXAnchor),
            self.totalLabel.centerYAnchor.constraint(equalTo: self.totalView.centerYAnchor)
        ])
        
        self.totalLabel.text = "Total USD \(CartManager.shared.cartTotal.toString())"
    }
    
    @objc func proceedToCheckout() {
        if resume.isEmpty {
            let alertController = UIAlertController(title: "Check out", message: "No comics found on cart", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .destructive))
            
            self.present(alertController, animated: true) 
        } else {
            let alertController = UIAlertController(title: "Check out", message: "Payment completed", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            
            self.present(alertController, animated: true) {
                CartManager.shared.emptyCart()
                self.displayCart(resume: CartManager.shared.createCartResume())
            }
        }
    }
}

extension CartResumeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CartResumeViewController: CartPresentable {
    func changeCart(comicId: Int, action: CartActionType) {
        self.presenter?.changeCart(comicId: comicId, action: action)
    }
    
    func displayCart(resume: [CartResume]) {
        self.datasource.resume = resume
        self.totalLabel.text = "Total USD \(CartManager.shared.cartTotal.toString())"
        self.tableView.reloadData()
    }
}
