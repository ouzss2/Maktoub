//
//  cartManagerOnline.swift
//  Maktoub
//
//  Created by user236595 on 4/4/23.
//

import Foundation


class CartManagerOnline: ObservableObject {
    @Published var cards: [CardC] = []
    
  
    private let userDefaults = UserDefaults.standard
    
    init() {
        if let data = userDefaults.data(forKey: "cards"), let savedCards = try? JSONDecoder().decode([CardC].self, from: data) {
            cards = savedCards
        }
    }
    
    func add(card: CardC) {
        if let index = cards.firstIndex(where: { $0.idpro == card.idpro }) {
            cards[index].qte += card.qte
        } else {
            var newCard = card
            newCard.qte = 1
            cards.append(newCard)
        }
       
        saveCards()
    }
    
    func remove(card: CardC) {
        if let index = cards.firstIndex(of: card) {
            cards[index].qte -= 1
            if cards[index].qte <= 0 {
                cards.remove(at: index)
            }
        }
        saveCards()
    }
    
    func clearCart() {
        cards = []
        saveCards()
    }
    
    private func saveCards() {
        if let encodedCards = try? JSONEncoder().encode(cards) {
            userDefaults.set(encodedCards, forKey: "cards")
        }
    }
    
    func showAll() {
        for card in cards {
           
        }
    }
}
