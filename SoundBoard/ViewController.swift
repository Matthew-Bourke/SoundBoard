//
//  ViewController.swift
//  SoundBoard
//
//  Created by Matthew Bourke on 20/8/17.
//  Copyright © 2017 Matthew Bourke. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var soundList: UITableView!
    var audioPlayer : AVAudioPlayer? = nil
    
    var sounds : [Sound] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        soundList.delegate = self
        soundList.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            sounds = try context.fetch(Sound.fetchRequest())
            soundList.reloadData()
        } catch {
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let sound = sounds[indexPath.row]
        
        cell.textLabel?.text = sound.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row]
        do {
            audioPlayer = try AVAudioPlayer(data: sound.audio! as Data)
            audioPlayer?.play()
        } catch {
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sound = sounds[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(sound)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                sounds = try context.fetch(Sound.fetchRequest())
                soundList.reloadData()
            } catch {
                
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

