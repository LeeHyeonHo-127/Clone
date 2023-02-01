//
//  WriteDiaryViewController.swift
//  diary
//
//  Created by 이현호 on 2023/01/26.
//

import UIKit

protocol WriteDiaryViewDelegate: AnyObject{
    func didSelectResister(diary:Diary)
}

class WriteDiaryViewController: UIViewController {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentsTextView: UITextView!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var confirmButton: UIBarButtonItem!
    
    
    var datePicker = UIDatePicker()
    var Diarydate:Date?
    weak var delegate: WriteDiaryViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmButton.isEnabled = false
        configureContentsTextView()
        configureDatePicker()
        configureInputField()
    }
    

    @IBAction func tapConfirmButton(_ sender: Any) {
        guard let title = self.titleTextField.text else {return}
        guard let contents = self.contentsTextView.text else {return}
        guard let date = self.Diarydate else {return}
        let diary = Diary(title: title, contents: contents, date: date, isStar: false)
        self.delegate?.didSelectResister(diary: diary)
        self.navigationController?.popViewController(animated: true)
    }
    
    //contentTextView 사각형 그리기
    func configureContentsTextView(){
        let BorderColor: UIColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = BorderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    //datePicker 설정 함수
    func configureDatePicker(){
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_ :)), for: .valueChanged)
        self.datePicker.locale = Locale(identifier: "ko-KR")
        self.dateTextField.inputView = self.datePicker
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        self.Diarydate = datePicker.date
        self.dateTextField.text = formatter.string(from: Diarydate!)
        self.dateTextField.sendActions(for: .editingChanged)
    }
    
    func configureInputField(){
        self.contentsTextView.delegate = self
        self.titleTextField.addTarget(self, action: #selector(titleTextDidChange(_: )), for: .editingChanged)
        self.dateTextField.addTarget(self, action: #selector(dateTextDidChange(_ :)), for: .editingChanged)
    }
    
    @objc private func titleTextDidChange(_ titleTextField : UITextField){
        self.validateInputField()
    }
    
    @objc private func dateTextDidChange(_ dateTextField: UITextField){
        self.validateInputField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func validateInputField(){
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !(self.contentsTextView.text.isEmpty)
    }
   
}

extension WriteDiaryViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}
