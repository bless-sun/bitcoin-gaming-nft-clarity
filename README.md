# Bitcoin Gaming NFT Smart Contract

## Overview

This Clarity smart contract implements a sophisticated Non-Fungible Token (NFT) system for a Bitcoin-themed gaming platform. The contract provides comprehensive functionality for minting, transferring, and managing game-related NFTs with advanced features for player scoring and reward distribution.

## Features

### 1. NFT Management

- **Minting**: Create unique game NFTs with detailed metadata
- **Transfer**: Securely transfer NFTs between players
- **Metadata**: Store and retrieve detailed information for each NFT

### 2. Player Scoring System

- Track player performance across gaming sessions
- Record and manage player scores
- Implement a reward mechanism based on player achievements

### 3. Reward Pool Management

- Maintain a Bitcoin reward pool
- Distribute rewards based on player performance
- Add funds to the reward pool

### 4. Access Control

- Contract ownership management
- Restricted access to critical functions
- Ownership transfer mechanism

## Contract Specifications

### Error Handling

The contract defines several custom error codes to handle different scenarios:

- `ERR-NOT-AUTHORIZED (u100)`: Unauthorized access attempt
- `ERR-INVALID-PARAMETERS (u101)`: Invalid input parameters
- `ERR-NFT-NOT-FOUND (u102)`: NFT does not exist
- `ERR-ALREADY-MINTED (u103)`: NFT already minted
- `ERR-INSUFFICIENT-FUNDS (u104)`: Insufficient reward pool funds
- `ERR-TRANSFER-FAILED (u105)`: NFT transfer failed
- `ERR-REWARD-DISTRIBUTION-FAILED (u106)`: Reward distribution error

### NFT Metadata

Each NFT contains the following metadata:

- Name (up to 50 characters)
- Description (up to 200 characters)
- Rarity (limited to: "common", "rare", "epic", "legendary")
- Game Type (up to 50 characters)
- Minting Timestamp

### Rarity Types

Supported rarity types:

- Common
- Rare
- Epic
- Legendary

### Reward Mechanism

- Default reward: 10 sats per point
- Flexible reward pool management
- Score-based reward calculation

## Public Functions

### NFT Operations

- `mint-game-nft`: Create a new game NFT
- `transfer`: Transfer an NFT between principals
- `get-nft-metadata`: Retrieve NFT metadata
- `get-last-token-id`: Get the last minted token ID
- `get-token-uri`: Retrieve the URI for a specific token

### Player Management

- `record-player-score`: Log player performance
- `distribute-bitcoin-rewards`: Distribute rewards to players

### Ownership and Pool Management

- `add-to-reward-pool`: Add funds to the reward pool
- `get-reward-pool-balance`: Check current reward pool balance
- `transfer-ownership`: Transfer contract ownership

## Security Considerations

- Only contract owner can mint NFTs
- Strict input validation
- Principal validation
- Restricted access to critical functions
- Score and reward limits implemented

## Initialization

- Initial reward pool: 1,000,000 sats
- Default reward per point: 10 sats

## Usage Example

```clarity
;; Mint a new NFT
(contract-call? .bitcoin-gaming-nft mint-game-nft
  "Legendary Sword"
  "A powerful weapon in the Bitcoin gaming universe"
  "legendary"
  "RPG"
)

;; Record a player's score
(contract-call? .bitcoin-gaming-nft record-player-score
  player-principal
  500
)

;; Distribute rewards
(contract-call? .bitcoin-gaming-nft distribute-bitcoin-rewards player-principal)
```

## Deployment Requirements

- Requires Clarinet for local development
- Compatible with Stacks blockchain
- Implements `.nft-trait.nft-trait`

## Potential Improvements

- Implement direct Bitcoin reward transfers
- Add more granular rarity effects
- Enhance score calculation mechanisms
- Implement more complex reward distribution strategies
