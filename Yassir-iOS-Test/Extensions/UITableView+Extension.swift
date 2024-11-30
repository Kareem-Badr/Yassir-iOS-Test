import UIKit

extension UITableView {
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(
            withIdentifier: T.className,
            for: indexPath
        ) as? T ?? T()
    }
    
    func register<T: UITableViewCell>(cell: T.Type) {
        register(cell.self, forCellReuseIdentifier: cell.className)
    }
}
