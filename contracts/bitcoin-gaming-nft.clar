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

;; Reward pool management
(define-data-var total-reward-pool uint u0)
(define-data-var reward-per-point uint u10)  ;; 10 sats per point as default

;; Mint a new game NFT
(define-public (mint-game-nft 
  (name (string-ascii 50))
  (description (string-ascii 200))
  (rarity (string-ascii 20))
  (game-type (string-ascii 50))
)
  (let 
    (
      (token-id (+ (var-get last-token-id) u1))
    )
    ;; Ensure only contract owner can mint initially
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    
    ;; Validate input parameters
    (asserts! (> (len name) u0) ERR-INVALID-PARAMETERS)
    (asserts! (> (len description) u0) ERR-INVALID-PARAMETERS)
    
    ;; Mint the NFT
    (try! (nft-mint? game-asset token-id tx-sender))
    
    ;; Store metadata
    (map-set nft-metadata 
      {token-id: token-id}
      {
        name: name,
        description: description,
        rarity: rarity,
        game-type: game-type,
        minted-at: block-height
      }
    )
    
    ;; Update last token ID
    (var-set last-token-id token-id)
    
    ;; Return the new token ID
    (ok token-id)
  )
)

;; Transfer an NFT
(define-public (transfer 
  (token-id uint)
  (sender principal)
  (recipient principal)
)
  (begin
    (asserts! (is-owner token-id sender) ERR-NOT-AUTHORIZED)
    (try! (nft-transfer? game-asset token-id sender recipient))
    (ok true)
  )
)

;; Check if a principal is the owner of a specific NFT
(define-private (is-owner 
  (token-id uint)
  (user principal)
)
  (match (nft-get-owner? game-asset token-id)
    owner (is-eq user owner)
    false)
)

;; Get NFT metadata
(define-read-only (get-nft-metadata (token-id uint))
  (map-get? nft-metadata {token-id: token-id})
)

;; Record player score
(define-public (record-player-score 
  (player principal)
  (score uint)
)
  (let 
    (
      (current-score 
        (default-to 
          {total-score: u0, last-updated: u0, total-rewards-earned: u0}
          (map-get? player-scores {player: player})
        )
      )
      (new-total-score (+ (get total-score current-score) score))
    )
    ;; Ensure only contract can call this
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    
    ;; Update player scores
    (map-set player-scores 
      {player: player}
      {
        total-score: new-total-score,
        last-updated: block-height,
        total-rewards-earned: (+ (get total-rewards-earned current-score) (* score (var-get reward-per-point)))
      }
    )
    
    (ok new-total-score)
  )
)