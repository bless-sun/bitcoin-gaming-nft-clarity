;; title: Bitcoin Gaming NFT Smart Contract
;; summary: A smart contract for managing a collection of Bitcoin Gaming NFTs, including minting, transferring, and rewarding players.
;; description: This smart contract implements a non-fungible token (NFT) system for Bitcoin Gaming NFTs. It includes functionalities for minting new NFTs, transferring ownership, recording player scores, distributing Bitcoin rewards, and managing a reward pool. The contract ensures only the contract owner can perform certain actions and validates input parameters to maintain data integrity. The contract also provides read-only functions to retrieve NFT metadata, reward pool balance, and token ownership information.

(impl-trait .nft-trait.nft-trait)

;; Errors
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INVALID-PARAMETERS (err u101))
(define-constant ERR-NFT-NOT-FOUND (err u102))
(define-constant ERR-ALREADY-MINTED (err u103))
(define-constant ERR-INSUFFICIENT-FUNDS (err u104))
(define-constant ERR-TRANSFER-FAILED (err u105))
(define-constant ERR-REWARD-DISTRIBUTION-FAILED (err u106))

;; Contract owner
(define-data-var contract-owner principal tx-sender)

;; NFT collection name
(define-data-var collection-name (string-ascii 32) "Bitcoin Gaming NFTs")

;; Storing game metadata
(define-map nft-metadata 
  {token-id: uint}
  {
    name: (string-ascii 50),
    description: (string-ascii 200),
    rarity: (string-ascii 20),
    game-type: (string-ascii 50),
    minted-at: uint
  }
)

;; NFT registry
(define-non-fungible-token game-asset uint)

;; Token counter to generate unique IDs
(define-data-var last-token-id uint u0)

;; Leaderboard tracking
(define-map player-scores 
  {player: principal}
  {
    total-score: uint,
    last-updated: uint,
    total-rewards-earned: uint
  }
)