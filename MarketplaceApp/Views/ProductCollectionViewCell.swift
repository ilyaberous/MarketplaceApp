//
//  CardCell.swift
//  MarketplaceApp
//
//  Created by Ilya on 30.08.2023.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    static let identifier = "product_cell"
    
    // MARK: - UI Components
    
    private let backgroundForImage: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    private var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    
    private var title: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.numberOfLines = 2
        title.lineBreakMode = .byTruncatingTail
        title.attributedText = NSMutableAttributedString(string: "default", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.font: UIFont(name:"AkzidenzGroteskPro-Regular", size: 14) ?? .systemFont(ofSize: 14, weight: .regular)])
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private var date: UILabel = {
        let date = UILabel()
        date.textColor = .gray
        
        date.attributedText = NSMutableAttributedString(string: "default", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.font: UIFont(name:"AkzidenzGroteskPro-Regular", size: 12) ?? .systemFont(ofSize: 12, weight: .regular)])
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    private var location: UILabel = {
        let location = UILabel()
        location.textColor = .gray
        
        location.attributedText = NSMutableAttributedString(string: "default", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.font: UIFont(name:"AkzidenzGroteskPro-Regular", size: 12) ?? .systemFont(ofSize: 12, weight: .regular)])
        location.translatesAutoresizingMaskIntoConstraints = false
        return location
    }()
    
    private var price: UILabel = {
        let price = UILabel()
        price.font = UIFont(name: "DrukCyr-Medium", size: 20)
        price.textAlignment = .right
        price.textColor = .black
        price.translatesAutoresizingMaskIntoConstraints = false
        price.setContentCompressionResistancePriority(UILayoutPriority(1000), for: NSLayoutConstraint.Axis.horizontal)
        return price
    }()
    
    private let titlePriceStack: UIStackView = {
       let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .firstBaseline
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let dateLocationStack: UIStackView = {
       let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution =  .equalCentering
        sv.spacing = 6
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            self.image.image = nil
        }
    
    public func configure(with product: ProductCollectionViewCellModel) {
        self.title.text = product.title
        self.price.text = product.price
        self.date.text = product.date
        self.location.text = product.location
        product.fetchImage() { [weak self] result in
            
            switch result {
                
            case .success(let data):
                DispatchQueue.main.async {
                    let img = UIImage(data: data)
                    self?.image.image = img
                }
                
            case .failure(let error):
                print(error)
                break
                
            }
            
        }
    }
    
    // MARK: - Setup UI
    
    private func setupUI () {
        //backgroundColor = .green
        addSubview(backgroundForImage)
        addSubview(image)
        
        titlePriceStack.addArrangedSubview(title)
        titlePriceStack.addArrangedSubview(price)
        addSubview(titlePriceStack)
        
        //addSubview(title)
       // addSubview(price)
        
        dateLocationStack.addArrangedSubview(date)
        dateLocationStack.addArrangedSubview(location)
        addSubview(dateLocationStack)
        
    
        NSLayoutConstraint.activate([
            backgroundForImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundForImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundForImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundForImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),

            image.centerYAnchor.constraint(equalTo: backgroundForImage.centerYAnchor),
            image.centerXAnchor.constraint(equalTo: backgroundForImage.centerXAnchor),
            image.widthAnchor.constraint(equalTo: backgroundForImage.widthAnchor, multiplier: 0.6),
            image.heightAnchor.constraint(equalTo: backgroundForImage.widthAnchor, multiplier: 0.6),
            
            titlePriceStack.topAnchor.constraint(equalTo: backgroundForImage.bottomAnchor, constant: 14),
            titlePriceStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -9),
            titlePriceStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 9),
            
            dateLocationStack.topAnchor.constraint(equalTo: titlePriceStack.bottomAnchor, constant: 5),
            dateLocationStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 9),
            dateLocationStack.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -9),
             
        ])
    }
}


extension NSMutableAttributedString {
    
    func changFontSizeTo(fontSize: Int) {
        let attributes = self.attributes(at: 0, effectiveRange: nil)
        
        guard let font = attributes[NSAttributedString.Key.font] as? UIFont else { return }
        let newFont = font.withSize(CGFloat(fontSize))
        
        self.addAttributes([NSAttributedString.Key.font: newFont], range: NSRange(location: 0, length: self.string.count))
    }
}
