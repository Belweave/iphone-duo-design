// SplitViewCollapse.swift — UIKit template: list/detail that collapses on the outer display.
//
// Tech Talk 111461: "SwiftUI's NavigationSplitView or UIKit's UISplitViewController are fully adaptive.
// When iPhone Duo is closed, columns will collapse to single-stack navigation. When open, columns will
// appear both tiled and as overlays." HIG: standard split views adapt their column widths and margins to
// the fold automatically.
// Sources:
//   https://developer.apple.com/documentation/uikit/uisplitviewcontroller
//   https://developer.apple.com/documentation/uikit/uisplitviewcontroller/init(style:)
//   https://developer.apple.com/documentation/uikit/uisplitviewcontrollerdelegate/splitviewcontroller(_:topcolumnforcollapsingtoproposedtopcolumn:)
//   https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo

import UIKit

final class MailSplitCoordinator: NSObject, UISplitViewControllerDelegate {
    let split = UISplitViewController(style: .doubleColumn)
    private let list = MessageListViewController()
    private let detail = MessageDetailViewController()

    override init() {
        super.init()
        split.delegate = self
        split.preferredDisplayMode = .oneBesideSecondary
        split.setViewController(list, for: .primary)
        split.setViewController(detail, for: .secondary)
        list.onSelect = { [weak self] subject in
            self?.detail.subject = subject
            self?.split.show(.secondary)
        }
    }

    // When the device closes, keep the detail on top if something is selected — same context outside.
    func splitViewController(_ svc: UISplitViewController,
                             topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column)
        -> UISplitViewController.Column {
        detail.subject == nil ? .primary : .secondary
    }
}

final class MessageListViewController: UITableViewController {
    var onSelect: ((String) -> Void)?
    private let subjects = (1...30).map { "Message \($0)" }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inbox"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Bar items on the view controller (not a custom UIToolbar) so the system can place them vertically.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter",
                                                            image: UIImage(systemName: "line.3.horizontal.decrease"),
                                                            primaryAction: nil, menu: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { subjects.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = subjects[indexPath.row]
        cell.contentConfiguration = config
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect?(subjects[indexPath.row])
    }
}

final class MessageDetailViewController: UIViewController {
    var subject: String? { didSet { label.text = subject ?? "No Message Selected" } }
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        label.text = subject ?? "No Message Selected"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
        toolbarItems = [
            UIBarButtonItem(title: "Reply", image: UIImage(systemName: "arrowshape.turn.up.left"), primaryAction: nil, menu: nil),
            UIBarButtonItem(title: "Archive", image: UIImage(systemName: "archivebox"), primaryAction: nil, menu: nil),
        ]
    }
}
