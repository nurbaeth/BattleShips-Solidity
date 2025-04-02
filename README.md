# BattleShips Solidity

BattleShips Solidity is an on-chain implementation of the classic Battleship game using Ethereum smart contracts. Players deploy their fleets, take turns attacking, and compete to sink their opponent's ships. The game ensures transparency and fairness through blockchain technology.

## Features
- **Decentralized Gameplay** – All game logic runs on the Ethereum blockchain.
- **Turn-Based Mechanics** – Players take turns attacking enemy coordinates.
- **On-Chain State** – Ship placements, attacks, and results are recorded immutably.
- **Automatic Win Detection** – The game ends when one player loses all ships. 

## How It Works
1. **Join the Game:** Two players can join the game by calling `joinGame()`.   
2. **Place Ships:** Each player places 3 ships on a 5x5 grid using `placeShip(x, y)`.
3. **Start Playing:** Players take turns attacking coordinates with `attack(x, y)`. Hits and misses are recorded.
4. **Win Condition:** A player wins when their opponent has no remaining ships. 

## Smart Contract
The game logic is handled by a Solidity smart contract deployed on Ethereum. It includes functions for: 
- Joining the game
- Placing ships
- Attacking enemy positions 
- Determining the winner 

## Deployment
To deploy the contract, use Remix or Hardhat:

### Using Remix:
1. Open [Remix Ethereum IDE](https://remix.ethereum.org/)
2. Create a new Solidity file and paste the contract code
3. Compile and deploy using Injected Web3 (MetaMask)

### Using Hardhat:
1. Install dependencies:
   ```bash
   npm install --save-dev hardhat ethers
   ```
2. Compile the contract:
   ```bash
   npx hardhat compile
   ```
3. Deploy the contract:
   ```bash
   npx hardhat run scripts/deploy.js --network goerli
   ```

## Interacting with the Contract
You can interact with the contract using Ethers.js or Web3.js. Example using Ethers.js:
```javascript
const contract = new ethers.Contract(contractAddress, abi, signer);
await contract.joinGame();
await contract.placeShip(2, 3);
await contract.attack(1, 1);
```

## Future Enhancements
- **Hidden Ship Placement:** Using zk-SNARKs to keep ship positions private.
- **Larger Grid Sizes:** Configurable game board sizes.
- **Multiplayer Expansion:** Support for more than two players.

## License
This project is licensed under the MIT License.

