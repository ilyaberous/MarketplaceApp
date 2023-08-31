//
//  DetailProductView.swift
//  MarketplaceApp
//
//  Created by Ilya on 31.08.2023.
//

import UIKit

extension NSAttributedString {
    func uppercased() -> NSAttributedString {

        let result = NSMutableAttributedString(attributedString: self)

        result.enumerateAttributes(in: NSRange(location: 0, length: length), options: []) {_, range, _ in
            result.replaceCharacters(in: range, with: (string as NSString).substring(with: range).uppercased())
        }

        return result
    }
}

class DetailProductView: UIView {
    
    // MARK: - Properties
    
    private var lastOffsetY: CGFloat!
    public var title1: String?
    
    private let viewModel: DetailProductViewModel!
    
    // MARK: - UI Components
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private var pageTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "DrukCyr-Medium", size: 34)
        title.numberOfLines = 2
        title.lineBreakMode = .byWordWrapping
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.78
        title.attributedText = NSMutableAttributedString(string: "Title", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        title.attributedText = NSMutableAttributedString(attributedString: title.attributedText!.uppercased())
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let backgroundForImage: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var image: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "9")
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private var price: UILabel = {
        let price = UILabel()
        price.font = UIFont(name: "DrukCyr-Medium", size: 34)
        price.translatesAutoresizingMaskIntoConstraints = false
        return price
    }()
    
    private var button: UIButton = {
        let btt = UIButton()
        btt.setTitle("В КОРЗИНУ", for: .normal)
        btt.setTitleColor(.white, for: .normal)
        btt.backgroundColor = .black
        btt.titleLabel?.font = UIFont(name: "AkzidenzGroteskPro-Md", size: 16)
        btt.translatesAutoresizingMaskIntoConstraints = false
        return btt
    }()
    
    private var postedDateTitle: UILabel = {
        let p = UILabel()
        p.text = "Опубликовано"
        p.font = UIFont(name: "AkzidenzGroteskPro-Md", size: 12)
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()
    
    private var locationTitle: UILabel = {
        let adrs = UILabel()
        adrs.text = "Адрес"
        adrs.font = UIFont(name: "AkzidenzGroteskPro-Md", size: 12)
        adrs.translatesAutoresizingMaskIntoConstraints = false
        return adrs
    }()
    
    private var mailTitle: UILabel = {
        let mail = UILabel()
        mail.text = "Почта"
        mail.font = UIFont(name: "AkzidenzGroteskPro-Md", size: 12)
        mail.translatesAutoresizingMaskIntoConstraints = false
        return mail
    }()
    
    private var phoneNumberTitle: UILabel = {
        let phone = UILabel()
        phone.text = "Телефон"
        phone.font = UIFont(name:"AkzidenzGroteskPro-Md", size: 12)
        phone.translatesAutoresizingMaskIntoConstraints = false
        return phone
    }()
    
    private var date: UILabel = {
        let date = UILabel()
        date.font = UIFont(name: "AkzidenzGroteskPro-Regular", size: 12)
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    private var location: UILabel = {
        let location = UILabel()
        location.font = UIFont(name: "AkzidenzGroteskPro-Regular", size: 12)
        location.translatesAutoresizingMaskIntoConstraints = false
        return location
    }()
    
    private var mail: UILabel = {
        let mail = UILabel()
        mail.font = UIFont(name: "AkzidenzGroteskPro-Regular", size: 12)
        mail.translatesAutoresizingMaskIntoConstraints = false
        return mail
    }()
    
    private var phoneNumber: UILabel = {
        let phone = UILabel()
        phone.font = UIFont(name: "AkzidenzGroteskPro-Regular", size: 12)
        phone.translatesAutoresizingMaskIntoConstraints = false
        return phone
    }()
    
    private var postedDateStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution =  .equalCentering
        stack.spacing = 44
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var locationStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution =  .equalCentering
        stack.spacing = 92
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var mailStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution =  .equalCentering
        stack.spacing = 92
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var phoneNumberStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution =  .equalCentering
        stack.spacing = 77
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var commonVerticalStack: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.distribution = .fill
        st.alignment = .leading
        st.spacing = 9
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
    private var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .gray
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    
    
    
    // MARK: - ScrollView
    
    private let contentView: UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let descriptionProductTitle: UILabel = {
        let title = UILabel()
        title.attributedText = NSMutableAttributedString(string: "О ТОВАРЕ", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.font: UIFont(name: "DrukCyr-Medium", size: 30)
                                                                                          ?? .systemFont(ofSize: 14, weight: .bold)])
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let descriptionProduct: UILabel = {
        let desc = UILabel()
        desc.font = UIFont(name: "AkzidenzGroteskPro-Regular", size: 14)
        desc.numberOfLines = 0
        desc.translatesAutoresizingMaskIntoConstraints = false
        return desc
    }()
    
    private let emptySpace: UIView = {
        let empty = UIView()
        empty.translatesAutoresizingMaskIntoConstraints = false
        return empty
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
    
    
    // MARK: - LifeCycle
    
    init(frame: CGRect, viewModel: DetailProductViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        setupSpinner()
        setupScrollView()
        viewModel.fetchDetailProducts()
        viewModel.delegate = self
        //viewModel.fetchProducts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupScrollView() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        scrollView.addSubview(contentView)
        
        let hC = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        hC.isActive = true
        hC.priority = UILayoutPriority(rawValue: 50)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            // contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            //hC
        ])
    }
    
    private func setupSpinner() {
        spinner.startAnimating()
        contentView.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    private func setupContentUI() {
        contentView.addSubview(pageTitle)
        
        contentView.addSubview(backgroundForImage)
        contentView.addSubview(image)
        
        contentView.addSubview(price)
        contentView.addSubview(button)
        
        
        postedDateStack.addArrangedSubview(postedDateTitle)
        postedDateStack.addArrangedSubview(date)
        contentView.addSubview(postedDateStack)
        
        locationStack.addArrangedSubview(locationTitle)
        locationStack.addArrangedSubview(location)
        contentView.addSubview(locationStack)
        
        mailStack.addArrangedSubview(mailTitle)
        mailStack.addArrangedSubview(mail)
        contentView.addSubview(mailStack)
        
        phoneNumberStack.addArrangedSubview(phoneNumberTitle)
        phoneNumberStack.addArrangedSubview(phoneNumber)
        contentView.addSubview(phoneNumberStack)
        
        commonVerticalStack.addArrangedSubview(postedDateStack)
        commonVerticalStack.addArrangedSubview(locationStack)
        commonVerticalStack.addArrangedSubview(mailStack)
        commonVerticalStack.addArrangedSubview(phoneNumberStack)
        
        contentView.addSubview(commonVerticalStack)
        
        contentView.addSubview(separator)
        
        contentView.addSubview(descriptionProductTitle)
        
        contentView.addSubview(descriptionProduct)
        
        //contentView.addSubview(emptySpace)
        
        // view.addSubview(line)
        
        NSLayoutConstraint.activate([
            
            pageTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            pageTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            pageTitle.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -47),
            
            backgroundForImage.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 16),
            backgroundForImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundForImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundForImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            backgroundForImage.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            
            image.centerXAnchor.constraint(equalTo: backgroundForImage.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: backgroundForImage.centerYAnchor),
            image.widthAnchor.constraint(equalTo: backgroundForImage.widthAnchor, multiplier: 0.4),
            image.heightAnchor.constraint(equalTo: backgroundForImage.heightAnchor, multiplier: 0.7),
            
            price.topAnchor.constraint(equalTo: backgroundForImage.bottomAnchor, constant: 16),
            price.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            price.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -18),
            
            button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            button.heightAnchor.constraint(equalToConstant: 59),
            button.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 14),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            
            commonVerticalStack.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 44),
            commonVerticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            commonVerticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.topAnchor.constraint(equalTo: commonVerticalStack.bottomAnchor, constant: 46),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            
            descriptionProductTitle.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 41),
            descriptionProductTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            descriptionProductTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            
            descriptionProduct.topAnchor.constraint(equalTo: descriptionProductTitle.bottomAnchor, constant: 32),
            descriptionProduct.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            descriptionProduct.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            descriptionProduct.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
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
        viewModel.baseCurrentProductUrl = "https://www.avito.st/s/interns-ios/details/"
        vStack.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
        viewModel.fetchDetailProducts()
    }
    
}

extension DetailProductView: DetailProductViewModelDelegate {
    func didDataLoad() {
        let url = URL(string: self.viewModel.detailProduct.imageURL)!
        ImageDownloader.shared.downloadImage(url) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.vStack.isHidden = true
            self?.spinner.stopAnimating()
            self?.spinner.isHidden = true
            self?.setupContentUI()
            self?.pageTitle.text = self?.viewModel.detailProduct.title
            self?.price.text = self?.viewModel.detailProduct.price
            self?.date.text = self?.viewModel.detailProduct.date
            self?.location.text = (self?.viewModel.detailProduct.location)! + ", " + (self?.viewModel.detailProduct.address)!
            self?.mail.text = self?.viewModel.detailProduct.email
            self?.phoneNumber.text = self?.viewModel.detailProduct.phoneNumber
            self?.descriptionProduct.text = self?.viewModel.detailProduct.description
        }
    }
    
    func didCatchError() {
        spinner.stopAnimating()
        spinner.isHidden = true
        for element in contentView.subviews {
            element.isHidden = true
        }
        setupUIError()
    }
}

//extension DetailProductView: UIScrollViewDelegate {
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
//          lastOffsetY = scrollView.contentOffset.y
//      }
//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView){
//        if (scrollView.contentOffset.y > self.lastOffsetY) {
//            print("WOrking!!!")
//            self.title = "Title"
//        } else {
//            self.title = ""
//        }
//      }
//}
//
//    
  
