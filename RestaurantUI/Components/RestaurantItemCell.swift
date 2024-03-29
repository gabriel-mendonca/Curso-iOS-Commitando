//
//  RestaurantItemCell.swift
//  RestaurantUI
//
//  Created by Gabriel on 28/03/24.
//

import UIKit

public protocol ViewCodeHelper {
    func buildViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupView()
}

public extension ViewCodeHelper {
    func setupView() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
    
    func setupAdditionalConfiguration() {}
}

extension UITableViewCell {
    static var identifier: String {
        return "\(type(of: self))"
    }
}

final class RestaurantItemCell: UITableViewCell {
    private(set) lazy var hstack = renderStack(axis: .horizontal, spacing: 16, alignment: .center)
    private(set) lazy var vstack = renderStack(axis: .vertical, spacing: 4, alignment: .leading)
    private(set) lazy var hRatingStack = renderStack(axis: .horizontal, spacing: 0, alignment: .fill)
    
    private(set) lazy var mapImage = renderImage("map")
    private(set) lazy var title = renderLabel(font: .preferredFont(forTextStyle: .title2))
    private(set) lazy var location = renderLabel(font: .preferredFont(forTextStyle: .body))
    private(set) lazy var distance = renderLabel(font: .preferredFont(forTextStyle: .body))
    private(set) lazy var parasols = renderLabel(font: .preferredFont(forTextStyle: .body))
    private(set) lazy var colletionOfRating: [UIImageView] = renderCollectionOfImage()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func renderLabel(font: UIFont, textColor: UIColor = .black) -> UILabel {
        let label = UILabel()
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func renderStack(axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.spacing = spacing
        stack.alignment = alignment
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    private func renderImage(_ systemName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.image = UIImage(systemName: systemName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func renderCollectionOfImage() -> [UIImageView] {
        var colletion = [UIImageView]()
        for _ in 1...5 {
            colletion.append(renderImage("star"))
        }
        return colletion
    }
}

extension RestaurantItemCell: ViewCodeHelper {
    
    private var margin: CGFloat {
        return 16
    }
    
    func buildViewHierarchy() {
        contentView.addSubview(hstack)
        hstack.addArrangedSubview(mapImage)
        hstack.addArrangedSubview(vstack)
        vstack.addArrangedSubview(title)
        vstack.addArrangedSubview(location)
        vstack.addArrangedSubview(distance)
        vstack.addArrangedSubview(parasols)
        vstack.addArrangedSubview(hRatingStack)
        colletionOfRating.forEach { hRatingStack.addArrangedSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            hstack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            hstack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            hstack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            hstack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin)
        ])
    }
    
    func setupAdditionalConfiguration() {
        accessoryType = .disclosureIndicator
    }
    
}
