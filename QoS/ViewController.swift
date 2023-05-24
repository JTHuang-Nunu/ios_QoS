//
//  ViewController.swift
//  QoS
//
//  Created by Mac15 on 2023/5/24.
//

import UIKit

class ViewController: UIViewController {
    var inactiveQ: DispatchQueue!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        queueWithQos()
        concurrentQ()
        if let queue = inactiveQ{
            queue.activate()
        }
        queueWithDelay()
    }
    
    func queueWithQos(){
        let queue1 = DispatchQueue(label: "queue1", qos: DispatchQoS.userInteractive
        )
        let queue2 = DispatchQueue(label: "queue2", qos: DispatchQoS.utility)
        
//        queue1.async {
//            for i in 0...10 {
//                print("🍎", i)
//            }
//            for i in 100...110 {
//                print("🍏", i)
//            }
//        }
//
//        queue2.async {
//            for i in 100...110 {
//                print("🍏", i)
//            }
//        }
        
        for i in 0...10 {
            print("🍎", i)
        }
        for i in 100...110 {
            print("🍏", i)
        }
        for i  in 1000...1005{
            print("😃", i)
        }
    }
    
    func concurrentQ(){
        let anotherQueue = DispatchQueue(label: "anotherQueue", qos: .utility, attributes: .concurrent)
        inactiveQ = anotherQueue
        anotherQueue.async {
            for i in 0...1000 {
                print("🍎", i)
            }
        }
        anotherQueue.async {
            for i in 0...10 {
                print("🍏", i)
            }
        }
        anotherQueue.async {
            for i in 0...10 {
                print("😃", i)
            }
        }
    }
    
    func queueWithDelay(){
        let delayQueue = DispatchQueue(label: "delayQueue", qos: .userInitiated)
        print(Date())
        let additionalTime: DispatchTimeInterval = .seconds(2)
        
        delayQueue.asyncAfter(deadline: .now() + additionalTime){
            print(Date())
        }
    }
    
    let globalQueue = DispatchQueue.global(qos: .userInitiated)
    
    func globalQueues(){
        globalQueue.async {
            for i in 0...5 {
                print("🍎", i)
            }
        }
        DispatchQueue.main.async {
            for i in 100...105 {
                print("🍏", i)
            }
        }
    }
    
    func fetchImage(){
        let imageURL: URL = URL(string: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fmoptt.tw%2Fp%2FBeauty.M.1641193813.A.44B&psig=AOvVaw3XvUd-ZOPP_ibn48u9i32B&ust=1685000952264000&source=images&cd=vfe&ved=0CA4QjRxqFwoTCNCl5Ou7jf8CFQAAAAAdAAAAABAD")
        (URLSession(configuration: URLSessionConfiguration.default))
            .dataTask(with: imageURL, completionHandler: {(imageData, response, error) in
                if let data = imageData{
                    print("Did download image data")
                    
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            })
    }
    
}

