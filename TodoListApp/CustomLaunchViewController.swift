import UIKit

class CustomLaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLaunchScreen()
    }
    
    private func setupLaunchScreen() {
        // Настройка фона
        view.backgroundColor = .systemBackground
        
        //контейнер
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Иконка
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "checklist")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 60, weight: .bold)
        )
        iconImageView.tintColor = .systemBlue
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Название
        let titleLabel = UILabel()
        titleLabel.text = "TaskMaster"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        
        // Настраиваем constraints
        NSLayoutConstraint.activate([
        
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Иконка
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 120),
            iconImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // Название
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}
