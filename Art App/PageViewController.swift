//
//  PageViewController.swift
//  Art App
//
//  Created by Sachin Katyal on 7/3/19.
//  Copyright © 2019 Sachin Katyal. All rights reserved.
//

import UIKit

class PageViewController: UIViewController,UIScrollViewDelegate {
    
    let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var pageControl : UIPageControl = UIPageControl(frame:CGRect(x: 0, y: 0, width: 200, height: 50))
    
    var fileHandler: FileHandler? = nil
    
    var image: UIImage!
    
    
    var panGesture       = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        scrollView.isUserInteractionEnabled = true
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swiptDown(gesture:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView))
//        scrollView.isUserInteractionEnabled = true
//        scrollView.addGestureRecognizer(panGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var transform = scrollView.transform
        var otherTransform = pageControl.transform
        transform = transform.translatedBy(x: 0.0, y:  -1 * UIScreen.main.bounds.height * 0.8)
        otherTransform = otherTransform.translatedBy(x: 0.0, y: -1 * UIScreen.main.bounds.height * 0.8)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.transform = transform
            self.pageControl.transform = otherTransform
        })
        
        //fileHandler = FileHandler(fileName: "test.txt")
        
    }
    
    
    func setUpUI() {
        scrollView.layer.position = CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height + scrollView.bounds.height / 2 )
        pageControl.layer.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height + scrollView.bounds.height - 0.3 * scrollView.bounds.height)
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.center = view.center
        imageView.image = image
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
        let prediction = ImageHandler(image: ImageHandler.resizeImage(image: imageView.image!, targetSize: CGSize(width: 50, height: 50)))
        fileHandler = FileHandler(fileName: prediction.predict())

        
        
        // Do any additional setup after loading the view, typically from a nib.
        configurePageControl()
        
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        for index in 0..<3 {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            
            let subView = UIView(frame: CGRect(x: frame.origin.x + 0.025 * UIScreen.main.bounds.width, y: frame.origin.y, width: frame.width * 0.95, height: UIScreen.main.bounds.height * 0.75 ))
            subView.backgroundColor = .white
            subView.layer.cornerRadius = 15
            subView.backgroundColor = UIColor(white: 1, alpha: 0.97)
            self.scrollView.addSubview(subView)
            
            let viewDownButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 32))
            viewDownButton.layer.position = CGPoint(x: subView.frame.width / 2, y: 20)
            viewDownButton.setBackgroundImage(UIImage(named: "down_arrow"), for: .normal)
            viewDownButton.addTarget(self, action: #selector(self.viewDown), for: .touchUpInside)
            subView.addSubview(viewDownButton)

            
            
        }
        self.scrollView.isPagingEnabled = true
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * 3, height: self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        pageControl.layer.zPosition = 200
        
        setUpGeneralView()
        setUpArtView()
        setUpArtistView()
        
    }
    
    func setUpGeneralView() {
        let generalView = scrollView.subviews[0]

        
        let artImage = UIImageView(image: UIImage(named: "dog-1"))
        artImage.frame = CGRect(x: 0, y: generalView.frame.height * 0.1, width: (artImage.image?.size.width)! * 0.3, height: (artImage.image?.size.height)! * 0.3)
        artImage.layer.position = CGPoint(x: generalView.frame.width / 2 , y: artImage.layer.position.y)
        artImage.layer.cornerRadius = 15
        artImage.layer.masksToBounds = true
        
        let title = UILabel()
        title.text = fileHandler?.getTitle()
        title.bounds = CGRect(x: 0, y: 0, width: generalView.bounds.width * 0.95, height: 400)
        title.textAlignment = .center
        title.textColor = .darkGray
        title.font = UIFont(name: "Helvetica", size: 27)
        title.font = UIFont.boldSystemFont(ofSize: title.font.pointSize)
        title.sizeToFit()
        title.frame.origin = CGPoint(x: generalView.frame.width / 2 - title.frame.width / 2, y: artImage.layer.position.y + artImage.frame.height / 2)

        
        let author = UILabel()
        author.text = fileHandler?.getAuthorName()
        author.bounds = CGRect(x: 0, y: 0, width: generalView.bounds.width, height: 30)
        author.textColor = .gray
        author.textAlignment = .center
        author.font = UIFont(name: "Helvetica", size: 17)
        author.font = UIFont.boldSystemFont(ofSize: author.font.pointSize)
        author.sizeToFit()
        author.frame.origin = CGPoint(x: generalView.frame.width / 2 - author.frame.width / 2, y: artImage.layer.position.y + artImage.frame.height / 2 + title.frame.height)
        
        
        generalView.addSubview(artImage)
        generalView.addSubview(title)
        generalView.addSubview(author)
        
 
    }
    
    func setUpArtView() {
        let artView = scrollView.subviews[1]
        
        
        let header = UILabel()
        header.text = "About the Artwork"
        header.bounds = CGRect(x: 0, y: 0, width: artView.bounds.width * 0.95, height: 30)
        header.textAlignment = .center
        header.textColor = .darkGray
        header.font = UIFont(name: "Helvetica", size: 30)
        header.font = UIFont.boldSystemFont(ofSize: header.font.pointSize)
        header.sizeToFit()
        header.frame.origin = CGPoint(x: artView.frame.width / 2 - header.frame.width / 2, y: 40)
        
        let description = UITextView()
        description.text = fileHandler?.getDescription()
        let attrString = NSMutableAttributedString(string: description.text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: description.text.count))
        description.attributedText = attrString
        description.backgroundColor = .clear
        description.frame = CGRect(x: 0, y: 0, width: artView.frame.width * 0.95, height: artView.frame.height * 0.75)
        description.frame.origin = CGPoint(x: artView.frame.width / 2 - description.frame.width / 2, y: header.layer.position.y + header.frame.height)
        description.isScrollEnabled = true
        description.textColor = .gray
        description.font = UIFont(name: "Helvetica", size: 17)
        description.font = UIFont.boldSystemFont(ofSize: (description.font?.pointSize)!)

        artView.addSubview(header)
        artView.addSubview(description)
        
    }
    
    
    func setUpArtistView() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch: UITouch? = touches.first
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != scrollView {
            viewDown(sender: nil)
        }
    }
    
    @objc func swiptDown(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.down:
                viewDown(sender: nil)
            default:
                break
            }
        }
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.view.bringSubview(toFront: scrollView.subviews[0])
        let translation = sender.translation(in: self.view)
        scrollView.subviews[0].center = CGPoint(x: scrollView.subviews[0].center.x, y: scrollView.subviews[0].center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func viewDown(sender: UIButton!) {
        var transform = scrollView.transform
        var otherTransform = pageControl.transform
        transform = transform.translatedBy(x: 0.0, y:  1 * UIScreen.main.bounds.height * 0.8)
        otherTransform = otherTransform.translatedBy(x: 0.0, y: 1 * UIScreen.main.bounds.height * 0.8)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.transform = transform
            self.pageControl.transform = otherTransform
            
        }, completion: {
            (value: Bool) in
            self.performSegue(withIdentifier: "ImageToCameraSegue", sender: self)

        })
    }

    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.darkGray
        self.view.addSubview(pageControl)
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        view.removeFromSuperview()
        view = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
