//
//  MainViewController.swift
//  ios-quest
//
//  Created by Schive on 2022/02/10.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift


class MainViewController: UIViewController {
    
    var ratingList = ["0","1", "2", "3", "4", "5", "6","7","8","9"]
    
    var rating = ""
    
    @IBOutlet weak var ratingTextField: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: MovieListViewModel!
    
    private var movieList: [Movie]? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNextBtn()
        setPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        initRating()
        changeRaingTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setNextBtn() {
        nextBtn.layer.cornerRadius = 20
        nextBtn.layer.shadowColor = UIColor.gray.cgColor
        nextBtn.layer.shadowOpacity = 1.0
        nextBtn.layer.shadowOffset = CGSize.zero
        nextBtn.layer.shadowRadius = 4
        nextBtn.backgroundColor = UIColor.systemBlue
        nextBtn.setTitleColor(.white, for: .normal)
        
        nextBtn.rx.tap.asDriver()
            .throttle(.seconds(3), latest: false)
            .drive(onNext: {
                self.fetchData()
            }).disposed(by: disposeBag)
    }
    
    private func setPicker() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        let pickerToolbar = UIToolbar()
        pickerToolbar.barStyle = .default
        pickerToolbar.sizeToFit()
        
        let btnDone = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(onPickDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btnCancel = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(onPickCancel))
        pickerToolbar.setItems([btnCancel , space , btnDone], animated: true)
        pickerToolbar.isUserInteractionEnabled = true
        
        ratingTextField.inputView = pickerView
        ratingTextField.inputAccessoryView = pickerToolbar
    }
    
    @objc func onPickDone() {
        changeRaingTextField()
        ratingTextField.resignFirstResponder()
    }
    
    @objc func onPickCancel() {
        initRating()
        changeRaingTextField()
        ratingTextField.resignFirstResponder()
    }
    
    private func changeRaingTextField() {
        ratingTextField.text = rating
    }
    
    private func initRating() {
        rating = ""
    }
    
    private func fetchData() {
        LoadingIndicator.showLoading()
        
        let resource = Resource<MovieResponse>(url: URL(string: "https://yts.mx/api/v2/list_movies.json?minimum_rating=\(rating)&limit=10&sort_by=rating")!)
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { MovieResponse in
                self.movieList = MovieResponse.data?.movies
                self.viewModel = MovieListViewModel(self.movieList!)
            }, onError: { Error in
                print("error: \(Error.localizedDescription)")
                DispatchQueue.main.async { [self] in
                    self.showErrorAlert()
                }
            }, onCompleted: {
                DispatchQueue.main.async { [self] in
                    self.goToMovieList(movieList)
                }
            }, onDisposed: {
                LoadingIndicator.hideLoading()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func goToMovieList(_ movies: [Movie]?) {
        guard let viewController: MovieListViewController = self.storyboard?.instantiateViewController(withIdentifier: "MovieListVC") as? MovieListViewController else {return}
        viewController.receiveItem(movies)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "알림", message: "통신 오류로 인해 영화 리스트를 가져올 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
        let onAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(onAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
}

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratingList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ratingList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rating = ratingList[row]
    }
    
}
