//
//  PokemonViewController.swift
//  PokemonAPI
//
//  Created by Mark Kim on 6/24/20.
//  Copyright © 2020 Mark Kim. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {

    var pokemons = [Pokemon]()
    var nextTenURL: String? = nil
    var pokemonFrontImageURL: String? = nil
    var pokemonBackImageURL: String? = nil
    let pokemonsURL = "https://pokeapi.co/api/v2/pokemon?limit=10"
    
    let pokemonTableView: UITableView = {
        let pokemonTableView = UITableView()
        pokemonTableView.rowHeight = 100
        pokemonTableView.translatesAutoresizingMaskIntoConstraints = false
        return pokemonTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPokemonData(url: "\(pokemonsURL)")
        setUpPokemonTable()
    }
    
    func fetchPokemonData(url: String) {
        
        let defaultSession = URLSession(configuration: .default)
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
                do {
                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let pokemons = try decoder.decode(PokemonList.self, from: data!)
                    self.pokemons.append(contentsOf: pokemons.results)
                    
                    DispatchQueue.main.async {
                        self.pokemonTableView.reloadData()
                    }
                    self.nextTenURL = pokemons.next!
                } catch {
                    print(error.localizedDescription)
                }
            })
            dataTask.resume()
        }
    }
    
    func fetchPokemonImage(url: String) {
        
        let defaultSession = URLSession(configuration: .default)
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                do {
                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let pokemonImage = try decoder.decode(PokemonImage.self, from: data!)
                    self.pokemonFrontImageURL = pokemonImage.sprites.frontDefault
                    self.pokemonBackImageURL = pokemonImage.sprites.backDefault
                    
                    
                    DispatchQueue.main.async {
                        let pokemonImageVC = PokemonImageViewController()
                        pokemonImageVC.frontImageURL = self.pokemonFrontImageURL!
                        pokemonImageVC.backImageURL = self.pokemonBackImageURL!
                        self.navigationController?.pushViewController(pokemonImageVC, animated: true)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            })
            dataTask.resume()
        }
    }
    
    func setUpPokemonTable() {
        self.title = "Pokemons"
        pokemonTableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: PokemonTableViewCell.identifier)
        pokemonTableView.delegate = self
        pokemonTableView.dataSource = self
        view.addSubview(pokemonTableView)
        NSLayoutConstraint.activate([
            pokemonTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pokemonTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pokemonTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pokemonTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension PokemonViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.identifier, for: indexPath)
        cell.textLabel!.text = pokemons[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = (pokemons[indexPath.row].url)
        fetchPokemonImage(url: url)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            fetchPokemonData(url: "\(nextTenURL!)")
        }
    }
    
    
}

