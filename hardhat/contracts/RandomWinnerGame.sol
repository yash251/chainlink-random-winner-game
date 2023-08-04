// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract RandomWinnerGame is VRFConsumerBase, Ownable {

    // the amount of LINK to send with the request
    uint256 public fee;

    // ID of a public key against which randomness is generated
    bytes32 public keyHash;

    // address of the players
    address[] public players;

    // max number of players in one game
    uint8 maxPlayers;

    // variable to indicate if the game has started or not
    bool public gameStarted;

    // fees for entering the game
    uint256 entryFee;

    // current game ID
    uint256 public gameId;

    //EVENTS
    // emitted when the game starts
    event GameStarted(uint256 gameId, uint8 maxPlayers, uint256 entryFee);

    // emitted when someone joins a game
    event PlayerJoined(uint256 gameId, address player);

    // event when the game ends
    event GameEnded(uint256 gameId, address winner, bytes32 requestId);

    /**
    * constructor inherits a VRFConsumerBase and initiates the values for keyHash, fee and gameStarted
    * @param vrfCoordinator address of VRFCoordinator contract
    * @param linkToken address of LINK token contract
    * @param vrfFee the amount of LINK to send with the request
    * @param vrfKeyHash ID of public key against which randomness is generated
    */
    constructor (address vrfCoordinator, address linkToken, bytes32 vrfKeyHash, uint256 vrfFee) VRFConsumerBase(vrfCoordinator, linkToken) {
        keyHash = vrfKeyHash;
        fee = vrfFee;
        gameStarted = false;
    }

    /**
        startGame starts the game by setting appropriate values for all the variables
    */
    function startGame(uint8 _maxPlayers, uint256 _entryFee) public onlyOwner {
        // check if there is a game already running
        require(!gameStarted, "Game is currently running");
        // Check is _maxPlayers is greater than 0
        require(_maxPlayers > 0, "You cannot create a game with max players limit equal 0");
        // empty the players array
        delete players;
        // set the max players for this game
        maxPlayers = _maxPlayers;
        // set the game started to true
        gameStarted = true;
        // set up the entryFee for the game
        entryFee = _entryFee;
        gameId += 1;
        emit GameStarted(gameId, _maxPlayers, entryFee);
    }

    /**
        joinGame is called when a player wants to enter the game
    */
    function joinGame() public payable {
        // check if a game is already running
        require(gameStarted, "Game has not been started yet");
        // check if the value sent by the user matches the entry fee
        require(msg.value == entryFee, "value sent is not equal to entry fee");
        // check if there is still some space left in the game to add another player
        require(players.length < maxPlayers, "Game is full");
        // add the sender to the players list
        players.push(msg.sender);
        emit PlayerJoined(gameId, msg.sender);

        // If the list is full, start the winner selection process
        if (players.length == maxPlayers) {
            getRandomWinner();
        }
    }
}