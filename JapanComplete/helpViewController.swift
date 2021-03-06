import UIKit
class helpViewController: UIViewController, UIScrollViewDelegate {
	let backgroundColor = UIColor(red: 97.0/255.0, green: 142.0/255.0, blue: 218.0/255.0, alpha: 1.0)
	let slides = [
		[ "image": "fullmap.png", "text": NSLocalizedString("howto", comment: "")],
	]
	let screen: CGRect = UIScreen.main.bounds
	var scroll: UIScrollView?
	var dots: UIPageControl?
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = backgroundColor
		scroll = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: screen.width, height: screen.height * 0.9))
		scroll?.showsHorizontalScrollIndicator = false
		scroll?.showsVerticalScrollIndicator = false
		scroll?.isPagingEnabled = true
		view.addSubview(scroll!)
		if (slides.count > 1) {
			dots = UIPageControl(frame: CGRect(x: 0.0, y: screen.height * 0.875, width: screen.width, height: screen.height * 0.05))
			dots?.numberOfPages = slides.count
			view.addSubview(dots!)
		}
		for i in 0 ..< slides.count {
			if let image = UIImage(named: slides[i]["image"]!) {
            	let imageView: UIImageView = UIImageView(frame: getFrame(iW: image.size.width, iH: image.size.height, slide: i, offset: screen.height * 0.15))
				imageView.image = image
				scroll?.addSubview(imageView)
			}
			if let text = slides[i]["text"] {
				let textView = UITextView(frame: CGRect(x: screen.width * 0.05 + CGFloat(i) * screen.width, y: screen.height * 0.745, width: screen.width * 0.9, height: 100.0))
				textView.text = text
				textView.isEditable = false
				textView.isSelectable = false
				textView.textAlignment = NSTextAlignment.center
                textView.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0))
				textView.textColor = UIColor.white
				textView.backgroundColor = UIColor.clear
				scroll?.addSubview(textView)
			}
		}
        scroll?.contentSize = CGSize(width:CGFloat(Int(screen.width) *  slides.count), height:screen.height * 0.5)
		scroll?.delegate = self
        dots?.addTarget(self, action: #selector(self.swipe(sender:)), for: UIControl.Event.valueChanged)
		let closeButton = UIButton()
		closeButton.frame = CGRect(x: screen.width - 70, y: 20, width: 60, height: 60)
		closeButton.setTitle("Skip", for: .normal)
		closeButton.setTitleColor(UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5), for: .normal)
		closeButton.titleLabel!.font =  UIFont.systemFont(ofSize: 16)
        closeButton.addTarget(self, action: #selector(self.pressed(sender:)), for: .touchUpInside)
		view.addSubview(closeButton)
	}
    
    @objc func pressed(sender: UIButton!) {
		self.dismiss(animated: true) { () -> Void in
		}
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	func getFrame (iW: CGFloat, iH: CGFloat, slide: Int, offset: CGFloat) -> CGRect {
		let mH: CGFloat = screen.height * 0.50
		let mW: CGFloat = screen.width
		var h: CGFloat
		var w: CGFloat
		let r = iW / iH
		if (r <= 1) {
			h = min(mH, iH)
			w = h * r
		} else {
			w = min(mW, iW)
			h = w / r
		}
        return CGRect(x:max(0, (mW - w) / 2) + CGFloat(slide) * screen.width,
                      y:max(0, (mH - h) / 2) + offset,
                      width:w,
                      height:h
		)
	}
    @objc func swipe(sender: AnyObject) -> () {
		if let scrollView = scroll {
			let x = CGFloat(dots!.currentPage) * scrollView.frame.size.width
            scroll?.setContentOffset(CGPoint(x:x, y:0), animated: true)
		}
	}
	func scrollViewDidEndDecelerating(scrollView: UIScrollView) -> () {
		let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
		dots!.currentPage = Int(pageNumber)
	}
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
