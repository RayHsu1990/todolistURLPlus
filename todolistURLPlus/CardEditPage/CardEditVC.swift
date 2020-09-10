//
//  CardEditVC.swift
//  todolistURLPlus
//
//  Created by Alvin Tseng on 2020/9/7.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import UIKit

class CardEditVC: UIViewController {
    var taskData = TaskData(){
        didSet{
            setTaskData(data: taskData)
        }
    }
    private let cardEditView = CardEditView()
    override func loadView() {
        super.loadView()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        autoPushView()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        upDate()
    }
    func setTaskData(data:TaskData){
        self.cardEditView.setUserData(
            image: data.image ?? UIImage(systemName: "photo")!,
            title: data.title ?? "Unknow",
            script: data.script ?? "Unknow",
            color: data.color ?? ColorsButtonType.red)
        self.cardEditView.colorsCollectionView.delegate = self
        self.cardEditView.scrollView.delegate = self
        self.cardEditView.textView.delegate = self
        self.cardEditView.colorsCollectionView.reloadData()
        self.view = cardEditView
    }
    func setTask(card:Int,task:Int){
        taskData = TaskData( title:"This is Joey",
                                 script: "I am Jimmy ,English is a West Germanic language first spoken in early medieval England and eventually became a global lingua franca. It is named after the Angles, one of,English is a West Germanic language first spoken in early medieval England and eventually became a global lingua franca. It is named after ",
                                 image: UIImage(named: "joey"),
                                 color: .blue)
        setTaskData(data: taskData)
        print("Get API")
        getTask()//如果data 是nil 就是gil還沒改好
    }
    #warning("標記一下")
    func getTask(){
        let headers = ["userToken":UserToken.shared.userToken]
        let request = HTTPRequest(endpoint: .task, method: .GET, contentType: .json, headers: headers)
        NetworkManager().sendRequest(with: request.send()) { (result:Result<TaskReaponse,NetworkError>) in
            switch result {
                
            case .success(let a):
                print(a)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func upDate(){
        
    }
    @objc func takeImage() {
        let photoController = UIImagePickerController()
        photoController.delegate = self
        photoController.sourceType = .photoLibrary
        present(photoController, animated: true, completion: nil)
    }
    
}
extension CardEditVC:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let colorType = ColorsButtonType.allCases[indexPath.row]
        self.taskData.color = colorType
    }
}
extension CardEditVC:UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
extension CardEditVC:UITextViewDelegate{
    func textViewDidChange(_ textView:UITextView) {
        
       resetHight(textView)
        
    }
    func resetHight(_ textView:UITextView){
        let maxHeight:CGFloat = ScreenSize.height.value * 0.4
        let frame = textView.frame
        let constrainSize=CGSize(width:frame.size.width,height:CGFloat(MAXFLOAT))
        var size = textView.sizeThatFits(constrainSize)
        if size.height >= maxHeight{
            size.height = maxHeight
            textView.isScrollEnabled=true
        }else{
            textView.isScrollEnabled=false
        }
        textView.frame.size.height=size.height
    }
}
extension CardEditVC:UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            taskData.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
