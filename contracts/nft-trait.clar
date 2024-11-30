;; title: NFT Trait Definition
;; summary: Defines the standard trait for Non-Fungible Tokens (NFTs) in Clarity.
;; description: This trait outlines the essential functions required for an NFT contract, including retrieving the last used token ID, fetching the URI for a specific token, and getting the owner of a specific token.

(define-trait nft-trait
  (
    ;; Get the last used token ID
    (get-last-token-id () (response uint uint))
    
    ;; Get the URI for a specific token
    (get-token-uri (uint) (response (optional (string-ascii 256)) uint))
    
    ;; Get the owner of a specific token
    (get-owner (uint) (response (optional principal) uint))
  )
)