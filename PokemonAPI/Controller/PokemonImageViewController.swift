//
//  PokemonImageViewController.swift
//  PokemonAPI
//
//  Created by Mark Kim on 6/27/20.
//  Copyright © 2020 Mark Kim. All rights reserved.
//

import UIKit

class PokemonImageViewController: UIViewController {
    
    var frontImageURL: String? = nil
    var backImageURL: String? = nil
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var pokemonFrontImageView: UIImageView = {
        let pokeImageView = UIImageView()
        pokeImageView.contentMode = .scaleAspectFit
        pokeImageView.translatesAutoresizingMaskIntoConstraints = false
        return pokeImageView
    }()
    
    var pokemonBackImageView: UIImageView = {
        let pokeImageView = UIImageView()
        pokeImageView.contentMode = .scaleAspectFit
        pokeImageView.translatesAutoresizingMaskIntoConstraints = false
        return pokeImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPokemonFrontImage(url: frontImageURL!)
        fetchPokemonBackImage(url: backImageURL!)
//        fetchPokemonImageV2(from: imageURL!)
        setUpImageView()
    }
    
    func fetchPokemonImageV2(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        print(url)
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.pokemonFrontImageView.image = image
            }
        }
    }
    
    func fetchPokemonFrontImage(url: String) {
        let defaultSession = URLSession(configuration: .default)
        if let url = URL(string: url) {
            print(url)
            let request = URLRequest(url: url)
            let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.pokemonFrontImageView.image = image
                    }
                }
            })
            dataTask.resume()
        }
    }
    
    func fetchPokemonBackImage(url: String) {
        let defaultSession = URLSession(configuration: .default)
        if let url = URL(string: url) {
            print(url)
            let request = URLRequest(url: url)
            let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.pokemonBackImageView.image = image
                    }
                }
            })
            dataTask.resume()
        }
    }
    
    func setUpImageView() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.addArrangedSubview(pokemonFrontImageView)
        stackView.addArrangedSubview(pokemonBackImageView)
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            pokemonFrontImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.5),
            pokemonFrontImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),

            pokemonBackImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.5),
            pokemonBackImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }

}
