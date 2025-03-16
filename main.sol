// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BattleShips {
    uint8 constant GRID_SIZE = 5;
    address public player1;
    address public player2;
    bool public gameStarted;
    bool public gameOver;
    address public winner;

    enum CellState { Empty, Ship, Hit, Miss }
    
    struct Player {
        bool registered;
        bool ready;
        uint8 shipsRemaining;
        mapping(uint8 => mapping(uint8 => CellState)) grid;
    }

    mapping(address => Player) private players;
    address private currentTurn;

    event GameStarted();
    event ShipPlaced(address player, uint8 x, uint8 y);
    event MoveMade(address player, uint8 x, uint8 y, bool hit);
    event WinnerDeclared(address winner);

    modifier onlyPlayers() {
        require(msg.sender == player1 || msg.sender == player2, "Not a player");
        _;
    }

    modifier onlyCurrentTurn() {
        require(msg.sender == currentTurn, "Not your turn");
        _;
    }

    function joinGame() external {
        require(!gameStarted, "Game already started");

        if (player1 == address(0)) {
            player1 = msg.sender;
        } else if (player2 == address(0)) {
            player2 = msg.sender;
            startGame();
        } else {
            revert("Game full");
        }
        
        players[msg.sender].registered = true;
        players[msg.sender].shipsRemaining = 3; // Количество кораблей
    }

    function startGame() private {
        require(player1 != address(0) && player2 != address(0), "Waiting for players");
        gameStarted = true;
        currentTurn = player1;
        emit GameStarted();
    }

    function placeShip(uint8 x, uint8 y) external onlyPlayers {
        require(!gameOver, "Game over");
        require(!gameStarted, "Ships already placed");
        require(x < GRID_SIZE && y < GRID_SIZE, "Out of bounds");

        Player storage player = players[msg.sender];
        require(player.shipsRemaining > 0, "No ships left");
        require(player.grid[x][y] == CellState.Empty, "Cell occupied");

        player.grid[x][y] = CellState.Ship;
        player.shipsRemaining--;
        emit ShipPlaced(msg.sender, x, y);

        if (player1 != address(0) && player2 != address(0) &&
            players[player1].shipsRemaining == 0 &&
            players[player2].shipsRemaining == 0) {
            gameStarted = true;
            emit GameStarted();
        }
    }

    function attack(uint8 x, uint8 y) external onlyPlayers onlyCurrentTurn {
        require(gameStarted, "Game not started");
        require(!gameOver, "Game over");
        require(x < GRID_SIZE && y < GRID_SIZE, "Out of bounds");

        address opponent = (msg.sender == player1) ? player2 : player1;
        Player storage enemy = players[opponent];

        require(enemy.grid[x][y] != CellState.Hit && enemy.grid[x][y] != CellState.Miss, "Already attacked");

        bool hit = (enemy.grid[x][y] == CellState.Ship);
        enemy.grid[x][y] = hit ? CellState.Hit : CellState.Miss;

        if (hit) {
            enemy.shipsRemaining--;
            if (enemy.shipsRemaining == 0) {
                gameOver = true;
                winner = msg.sender;
                emit WinnerDeclared(winner);
                return;
            }
        }

        emit MoveMade(msg.sender, x, y, hit);
        currentTurn = opponent; // Передача хода другому игроку
    }
}
