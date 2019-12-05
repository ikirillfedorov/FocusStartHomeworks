//
//  DetailsAuthorPresenter.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

protocol IDetailsAuthorPresenter {
	func getAuthor() -> Creator
	func getComicsesCount() -> Int
	func getComics(index: Int) -> Comic
	func getComicsImage(index: Int)
	func setupView()
	func setupBackgroungImage()
}

class DetailsAuthorPresenter {
	weak var detailsView: DetailsAuthorViewController?
	var author: Creator
	var repository: Repository
	var comicses: [Comic] = []
	let serialQueue = DispatchQueue(label: "loadComicsesQueue")
	
	
	init(author: Creator, repository: Repository) {
		self.author = author
		self.repository = repository
		setupView()
		setupBackgroungImage()
	}
	deinit {
		print("DetailsAuthorPresenter deinit")
	}
}

extension DetailsAuthorPresenter: IDetailsAuthorPresenter {
	func setupBackgroungImage() {
		self.repository.loadImage(urlString:
			String.getUrlString(image: author.thumbnail, variant: ThumbnailVarians.standardFantastic))
		{ imageResult in
			switch imageResult {
			case .success(let image):
				DispatchQueue.main.async {
					self.detailsView?.backgroundImageView.image = image
				}
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
	
	func getComicsesCount() -> Int {
		return comicses.count
	}
	
	func getComics(index: Int) -> Comic {
		return comicses[index]
	}
	
	func setupView() {
		repository.loadComics(fromPastScreen: PastScreen.authors, with: author.id, searchResult: nil) { [weak self] comicsesResult in
			
			guard let self = self else { return }
			switch comicsesResult {
			case .success(let loadedData):
				self.comicses = loadedData.data.results
				DispatchQueue.main.async {
					self.detailsView?.activityIndicator.stopAnimating()
					self.detailsView?.updateData()
				}
			case .failure(let error):
				DispatchQueue.main.async {
					self.detailsView?.activityIndicator.stopAnimating()
				}
				print(error.localizedDescription)
			}
		}
	}
	
	func getComicsImage(index: Int) {
		serialQueue.async { [weak self] in
			guard let self = self else { return }
			let comics = self.comicses[index]
			self.repository.loadImage(urlString:
				String.getUrlString(image: comics.thumbnail, variant: ThumbnailVarians.standardMedium))
			{ imageResult in
				switch imageResult {
				case .success(let image):
					DispatchQueue.main.async {
						guard let cell = self.detailsView?.comicsesTableView.cellForRow(at: IndexPath(row: index, section: 0)) else { return }
						cell.imageView?.image = image
						cell.layoutSubviews()
					}
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
		}
		
	}
	
	func getAuthor() -> Creator {
		return author
	}
}
