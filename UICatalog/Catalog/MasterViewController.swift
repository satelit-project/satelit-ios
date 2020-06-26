import UIKit

class MasterViewController: UITableViewController {
    // MARK: Private properties

    private let catalog: [(name: String, class: UIViewController.Type)] = [
        (name: "Menu Bar", class: MenuViewController.self),
        (name: "Trailer View", class: TrailerViewController.self),
    ]

    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: Segues

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let cls = catalog[indexPath.row].class
                if let navigation = segue.destination as? UINavigationController {
                    let controller = cls.init()
                    navigation.setViewControllers([controller], animated: false)
                }
            }
        }
    }

    // MARK: Table View

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        catalog.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let title = catalog[indexPath.row].name
        cell.textLabel?.text = title
        return cell
    }
}
