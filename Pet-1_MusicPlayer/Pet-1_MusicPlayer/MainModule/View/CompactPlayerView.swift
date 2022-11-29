//
//  PlayerView.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/23/22.
//

import UIKit

class CompactPlayerView: UIView {
    
    static let shared = CompactPlayerView()
    var presenter: MainViewPresenterProtocol!
    var isShowed: Bool = false
    var yConstraint: NSLayoutConstraint!
    private var buttonState: Bool!
    
    private let closeButton: UIButton = {
        var butt = UIButton()
        butt.setImage(UIImage(named: "cancel"), for: .normal)
        butt.translatesAutoresizingMaskIntoConstraints = false
        return butt
    }()
    
    private let playPauseButton: UIButton = {
        var butt = UIButton()
        butt.setImage(UIImage(named: "play"), for: .normal)
        butt.translatesAutoresizingMaskIntoConstraints = false
        return butt
    }()
    
    private let artistNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "artist name"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let trackNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "track name"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var loadIndicator = LoadIndicator.shared
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 10
        self.addSubview(artistNameLabel)
        self.addSubview(trackNameLabel)
        self.addSubview(closeButton)
        self.addSubview(playPauseButton)
        self.addSubview(loadIndicator)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(gest:))))
        self.closeButton.addTarget(self, action: #selector(tapCencelButton(butt:)), for: .touchUpInside)
        self.playPauseButton.addTarget(self, action: #selector(playPauseButtonAction(sender:)), for: .touchUpInside)
        
        UIApplication.shared.keyWindow?.addSubview(self)
        if let  layoutGuide  = UIApplication.shared.keyWindow?.layoutMarginsGuide {
            yConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: layoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([
                self.heightAnchor.constraint(equalToConstant: 50),
                yConstraint,
                self.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)
            ])
                }
        
        closeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        closeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        playPauseButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playPauseButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        playPauseButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        playPauseButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        artistNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        artistNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -15).isActive = true
        artistNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2/3).isActive = true

        trackNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        trackNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15).isActive = true
        trackNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2/3).isActive = true
        
        loadIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        loadIndicator.leftAnchor.constraint(equalTo: closeButton.rightAnchor, constant: 10).isActive = true
        loadIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        loadIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true

        
        UIView.animate(withDuration: 0.5, animations: {
                   self.frame.origin.y = -150
                   self.artistNameLabel.frame.origin.y -= 150
                   self.trackNameLabel.frame.origin.y -= 150
        }, completion: { bool in
            if bool {
                self.isShowed = true
            } else {
                self.isShowed = false
            }
        })
    }
    
    @objc func tapCencelButton(butt: UIButton) {
        presenter.hideCompsctPlayer()
        presenter.dismissPlayer()
    }
    @objc func tap(gest: UITapGestureRecognizer) {
        presenter.tapOnThePlayer()
    }
    @objc func playPauseButtonAction(sender: UIButton) {
        if !buttonState {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            presenter.changePlayerState(state: .pause)
        } else {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            presenter.changePlayerState(state: .play)
        }
    }
}
extension CompactPlayerView : CompactPlayerViewProtocol {
    func changeButtonState(state: PlauerState) {
        switch state {
        case .play:
            self.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            self.buttonState = false
        case .pause:
            self.playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            self.buttonState = true
        case .stop:
            self.playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            self.buttonState = false
        }
    }
    
    
    func hidePlayerView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.yConstraint.constant = 100
            UIApplication.shared.keyWindow?.layoutIfNeeded()
        }, completion: { [weak self] bool in
            self?.removeFromSuperview()
            self?.isShowed = false
        })
    }
    
    func setupValues(index: Int) {
        trackNameLabel.text = presenter.favoriteTracks[index].trackName
        artistNameLabel.text = presenter.favoriteTracks[index].artistName
        
    }
    
    var isShow: Bool {
        return self.isShowed
    }
    
    func showPlayerView() {
        setup()
    }
}
