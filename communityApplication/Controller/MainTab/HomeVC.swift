//
//  HomeVC.swift
//  communityApplication
//
//  Created by Aravind on 16/03/2021.
//

import UIKit
import FirebaseFirestore
import Kingfisher
import FirebaseAuth

class HomeVC: UIViewController {
    
    @IBOutlet weak var bulletinTV: UITableView!
    
    
    lazy var presenter = HomePresenter(with: self)
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        bulletinTV.delegate = self
        bulletinTV.dataSource = self
        presenter.retriveBulletinData()
    }
}

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BulletinTableViewCell") as! BulletinTableViewCell
        cell.profileButton.tag = indexPath.row
        cell.profileButton.addTarget(self, action: #selector(onClickProfileButton(_:)), for: .touchUpInside)
        cell.setData(model: presenter.postData[indexPath.row])
        return cell
    }
    @objc func onClickProfileButton(_ sender: UIButton)
    {
        if presenter.postData[sender.tag].uid == Auth.auth().currentUser?.uid {
            self.tabBarController?.selectedIndex = 2
            return
        }
        guard let postUserProfileVC  = storyboard?.instantiateViewController(identifier: "PostUserProfileVC") as? PostUserProfileVC else {
            fatalError("view controller not created")
        }
        postUserProfileVC.userId = presenter.postData[sender.tag].uid
        navigationController?.pushViewController(postUserProfileVC, animated: true)
    }
}

extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "goToDetail", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is DetailPostVC {
            let vc = segue.destination as? DetailPostVC
            vc?.postData = presenter.postData[index]
        }
    }
}


extension HomeVC: HomeViewPresenter {
    func getPostSuccessfully() {
        bulletinTV.reloadData()
    }
}
