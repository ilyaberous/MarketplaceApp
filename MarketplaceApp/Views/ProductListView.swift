//
//  ProductListView.swift
//  MarketplaceApp
//
//  Created by Ilya on 30.08.2023.
//

import UIKit

protocol ProductListViewDelegate: AnyObject {
    func productListView(_ productListView: ProductListView, _ dedSelectProduct: Product)
}


final class ProductListView: UIView {
    
    // MARK: - Properties
    
    private let viewModel = ProductListViewModel()
    public weak var delegate: ProductListViewDelegate?
    let pressedDownTransform =  CGAffineTransform.identity.scaledBy(x: 0.98, y: 0.98)

    
    // MARK: - UI Components
    
    private let spinner: UIActivityIndicatorView = {
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.hidesWhenStopped = true
            spinner.translatesAutoresizingMaskIntoConstraints = false
            return spinner
        }()


    let collectionView: UICollectionView = {
        let vLayout = UICollectionViewFlowLayout()
        vLayout.scrollDirection = .vertical
        vLayout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: vLayout)
        cv.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        cv.isHidden = true
        cv.alpha = 0
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    // MARK: - Error UI Components
    
    lazy var smthWentWrong: UILabel = {
       let label = UILabel()
        label.text = "Ой, что-то пошло не так"
        label.font = UIFont(name: "DrukCyr-Medium", size: 60)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var errorIcon: UIImageView = {
       let icon = UIImageView()
        icon.image = UIImage(named: "sad_icon")
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    lazy var btt: UIButton = {
       let btt = UIButton()
        btt.backgroundColor = .black
        btt.setTitle("Повторить", for: .normal)
        btt.titleLabel?.font =  UIFont(name:"AkzidenzGroteskPro-Md", size: 16)
        btt.setTitleColor(.white, for: .normal)
        btt.addTarget(self, action: #selector(repeatTapped), for: .touchUpInside)
        btt.translatesAutoresizingMaskIntoConstraints = false
        return btt
    }()
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 34
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        setupUI()
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchProducts()
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        addSubview(collectionView)
        addSubview(spinner)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setupUIError() {
        vStack.addArrangedSubview(smthWentWrong)
        vStack.addArrangedSubview(errorIcon)
        vStack.addArrangedSubview(btt)
        
        addSubview(vStack)
        
        NSLayoutConstraint.activate([
            
            errorIcon.heightAnchor.constraint(equalToConstant: 94),
            errorIcon.widthAnchor.constraint(equalToConstant: 94),
            
            btt.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            btt.heightAnchor.constraint(equalToConstant: 59),
            
            vStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            
        ])
    }

    
    // MARK: - Selectors


    @objc private func repeatTapped(_ sender: UIButton) {
        // изменяем неккоректный URL на нормальный (для того, чтобы продемонстрировать работу состояния экрана при ошибке //
        viewModel.productsURL = "https://www.avito.st/s/interns-ios/main-page.json"
        spinner.isHidden = false
        spinner.startAnimating()
        vStack.isHidden = true
        viewModel.fetchProducts()
    }
    
}

 // MARK: - ProductListViewModel delegate

extension ProductListView: ProductListViewModelDelegate {
    func didSelectProduct(_ product: Product) {
        delegate?.productListView(self, product)
    }
    
    func didLoadInitialProducts() {
        spinner.stopAnimating()
        vStack.isHidden = true
        collectionView.isHidden = false
        collectionView.reloadData() // Initial fetch
        UIView.animate(withDuration: 0.5) {
            self.collectionView.alpha = 1
        }
    }
    
    func didCatchError() {
        collectionView.isHidden = true
        spinner.isHidden = true
        spinner.stopAnimating()
        vStack.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 0
        }
        setupUIError()
    }
}
