//
//  DetailPostVC.swift
//  communityApplication
//
//  Created by Aravind on 23/03/2021.
//

import UIKit
import Kingfisher
import FirebaseAuth
import FirebaseFirestore

class DetailPostVC: UIViewController {
    
    @IBOutlet weak var solutionTableView: UITableView!
    @IBOutlet weak var heightOfSolutionTableView: NSLayoutConstraint!
    
    @IBOutlet weak var postUsrNameLbl: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var postTiteLabel: UILabel!
    @IBOutlet weak var postQstnLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!

    
    lazy var presenter = DetailPostPresenter(with: self)
    var postData: PostModel?
    var userInfo: UserModel?
    let db = Firestore.firestore()
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getAnswers(postId: postData?.id ?? "")
        
        solutionTableView.delegate = self
        solutionTableView.dataSource = self
        AppUtil.shared.getUserInfo(uid: postData?.uid ?? "") { user in
            self.postUsrNameLbl.text = "By \(user.name ?? "")"
            self.navigationController?.title = "Answer By \(user.name ?? "")"
        }
        
        postTiteLabel.text = postData?.title
        postTimeLabel.text = postData?.createdAt?.numberOfDaysBetween()
        postQstnLabel.text = postData?.descriptionTitle
        postImageView.isHidden = (postData?.imageUrl ?? "" == "")
        postImageView.kf.setImage(with: URL(string: postData?.imageUrl ?? ""))
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onAddAnswerClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let Answervc = storyboard.instantiateViewController(withIdentifier: "AnswerVC") as? AnswerVC else {return}
        Answervc.modalPresentationStyle = .popover
        Answervc.postId = postData?.id ?? ""
        self.present(Answervc, animated: true, completion: nil)
    }
    
}

extension DetailPostVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "goToDetailAnswer", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is DetailAnswerVC {
            let vc = segue.destination as? DetailAnswerVC
            vc?.answerData = presenter.answerData[index]
            vc?.postId = postData?.id
        }
    }
}

extension DetailPostVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.answerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SolutionTableViewCell", for: indexPath) as! SolutionTableViewCell
        cell.setData(model: presenter.answerData[indexPath.row])
        DispatchQueue.main.async {
            self.heightOfSolutionTableView.constant = tableView.contentSize.height
        }
        return cell
    }
}

extension DetailPostVC: DetailPostViewPresenter {
    func getAnswerDataSuccessfully() {
        solutionTableView.reloadData()
    }
}
