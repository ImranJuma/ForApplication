//
//  ViewController.swift
//  ByFit2.0
//
//  Created by Imran Juma on 2017-04-18.
//  Copyright © 2017 Imran Juma. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

protocol LoginControllerDelegate: class {
    func finishLogginIn()
}

// Import Facebook SDK Here Later If Needed

class LoginController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LoginControllerDelegate {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
    } ()
    
    let cellId = "cellId"
    let loginCellId = "loginCellId"
    
    let pages: [Page] = {
        let firstPage = Page(title: "Welcome To ByFit®" , message: "Here, you'll be able to view all the newest new's about healthy living, choosing the right foods, and creating A healthy lifestyle" , imageName: "CollectionView1")
        let secondPage = Page(title: "ByFit® Makes It Personal" , message: "By creating your own personal profile, you'll be able to track your food chages, manage intake, track your progress, and crush those goals you've been striving for!" , imageName: "CollectionView2")
        let thirdPage = Page(title: "Share Your Achievements " , message: "With ByFit® we've integrated some of the most popular and advanced socail media interfaces allowing you to share your healthy lifestyle changes with all your friends, encouraging them to make the switch" , imageName: "CollectionView3")
        return [firstPage, secondPage, thirdPage]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
        pc.numberOfPages = self.pages.count + 1
        return pc
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return button
    }()
    
    func skip() {
        // Insted of writing lines, and lines of code, we can just rip eveything from the nextButton function
        pageControl.currentPage = pages.count - 1
        nextPage()
        
    }
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()
    
    func nextPage() {
        
        // If we hit this function, it means we are now on the last page; This prevents the application from crashing.
        if pageControl.currentPage == pages.count {
            return
        }
        
        // Hitting second last page, and knowing what to animate
        // Insted of having all the values written out, we creatated a function called moveControlConstraintsOffScreen() and then called that
        if pageControl.currentPage == pages.count - 1 {
            moveControlConstraintsOffScreen()
            
            // This is what actually does the animation
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
    var pageControllBottomAncor: NSLayoutConstraint?
    var skipButtonTopAncor: NSLayoutConstraint?
    var nextButtonTopAncor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboardNotifications()
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)

//        // Facebook SDK Stuff
//        let loginButton = FBSDKLoginButton()
//        view.addSubview(loginButton)
//        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
//        loginButton.delegate = self
        
        
        
       pageControllBottomAncor = pageControl.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)[1]
        
        skipButtonTopAncor = skipButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first
        
        nextButtonTopAncor = nextButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first
        
        //collectionView.frame = view.frame
        //Use Auto Layout Insted 
        
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        registerCells()
        
    }
    
    // More Facebook SDK Stuff
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        print("Did Log Out Of Facebook")
//    }
//    
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        if error != nil {
//            print(error)
//            return
//        }
//        print("Sucessful Login With Facebook")
//    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            // Specifing How Much keybaord to show when in landscape mode
            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -100: -15
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        // We Are On The Last Page
        // Insted of having all the values written out, we creatated a function called moveControlConstraintsOffScreen() and then called that
        if pageNumber == pages.count {
            moveControlConstraintsOffScreen()
            
        } else {
            //Back On Regular Pages
            pageControllBottomAncor?.constant = 0
            skipButtonTopAncor?.constant = 16
            nextButtonTopAncor?.constant = 16
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    
    fileprivate func moveControlConstraintsOffScreen() {
        pageControllBottomAncor?.constant = 40
        skipButtonTopAncor?.constant = -40
        nextButtonTopAncor?.constant = -40
    }
    
    fileprivate func registerCells() {
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // We are rendering our last login cell here
        if indexPath.item == pages.count {
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath) as! LoginCell
            loginCell.delegate = self
            return loginCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
        
        let page = pages[(indexPath as NSIndexPath).item]
        cell.page = page
        
        return cell
    }

    func finishLogginIn() {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        guard let MainNavigationController = rootViewController as?
            MainNavigationController else { return }
        MainNavigationController.viewControllers = [HomeController()]
        dismiss(animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Line below will just test to see if the benith rotation will work
       // print(UIDevice.current.orientation)
        collectionView.collectionViewLayout.invalidateLayout()
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        // This will scroll to index path when reached index path
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally , animated: true)
            // Reloads the image, so we have the correct image during boot up, this will also reboot all the cells
            self.collectionView.reloadData()
        }
    }
    
}
