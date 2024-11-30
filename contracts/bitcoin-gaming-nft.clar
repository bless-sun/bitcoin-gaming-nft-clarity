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